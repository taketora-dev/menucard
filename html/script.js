// dynamic menu items loaded from Lua config via NUI callback
let menuItems = [];

async function loadMenuData(){
  try{
    const resp = await fetch(`https://${GetParentResourceName()}/getMenuData`, {
      method:'POST',
      headers:{ 'Content-Type':'application/json' },
      body: JSON.stringify({})
    });
    // Some runtimes return JSON, some text; support both
    let data;
    const ct = resp.headers.get('content-type') || '';
    if (ct.includes('application/json')) data = await resp.json();
    else {
      const txt = await resp.text();
      try { data = JSON.parse(txt); } catch { data = null; }
    }
    if (Array.isArray(data)) menuItems = data; else menuItems = [];
  }catch(e){
    console.error('Failed to load menu data:', e);
    menuItems = [];
  }
}

window.addEventListener('message', function(event){
  if(event.data && event.data.action === 'openMenu'){
    document.body.style.display = 'block';
    const outer = document.getElementById('outerFrame');
    outer.setAttribute('aria-hidden','false');
    // Set tab aktif ke Paket Combo saat pertama kali buka
    document.querySelectorAll('.cat').forEach(b=>b.classList.remove('active'));
    const comboBtn = document.querySelector('.cat[data-cat="combo"]');
    if (comboBtn) comboBtn.classList.add('active');
    // load data from config, then render
    loadMenuData().then(()=> buildGrid('combo'));
  }
});

document.getElementById('closeX').addEventListener('click', ()=>{
  fetch(`https://${GetParentResourceName()}/closeMenu`, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({}) });
  document.body.style.display = 'none';
  document.getElementById('outerFrame').setAttribute('aria-hidden','true');
});

// items now come from loadMenuData() into menuItems

function renderImages(it) {
  if (Array.isArray(it.imgs) && it.imgs.length >= 2) {
    return `
      <div style="display:flex; gap:8px; justify-content:center; align-items:center;">
        <img src="${it.imgs[0]}" alt="${it.name} 1" style="width:48%; height:auto; max-height:100px; object-fit:contain; border-radius:0; background:transparent;">
        <img src="${it.imgs[1]}" alt="${it.name} 2" style="width:48%; height:auto; max-height:100px; object-fit:contain; border-radius:0; background:transparent;">
      </div>`;
  }
  return `
    <div style="display:flex; justify-content:center; align-items:center;">
      <img src="${it.img}" alt="${it.name}" style="width:auto; max-width:92%; height:auto; max-height:100px; object-fit:contain; border-radius:0; background:transparent;">
    </div>`;
}

function buildGrid(filter = 'combo') {
  const grid = document.getElementById('menuGrid');
  grid.innerHTML = '';
  const items = (Array.isArray(menuItems) ? menuItems : []).filter(i => i.cat === filter);
  items.forEach(it => {
    const d = document.createElement('div');
    d.className = 'item';
    d.setAttribute('role', 'listitem');
    d.innerHTML = `
      ${renderImages(it)}
      <div class="iname">${it.name}</div>
      <div class="iprice">${it.price}</div>
    `;
    grid.appendChild(d);
  });
}

// --- Improved Best Practice for Category Selection ---
const allowedCategories = Array.from(document.querySelectorAll('.cat')).map(btn => btn.getAttribute('data-cat'));

document.querySelectorAll('.cat').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.cat').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    const cat = btn.getAttribute('data-cat');
    buildGrid(allowedCategories.includes(cat) ? cat : 'combo');
  });
});
