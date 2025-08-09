// dynamic menu items loaded from Lua config via NUI callback
let menuItems = [];
let clusterize = null;

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

// Helper render images
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

// Bangun HTML item (array of string) untuk Clusterize
function buildGridRows(filter = 'combo') {
  const items = (Array.isArray(menuItems) ? menuItems : []).filter(i => i.cat === filter);
  return items.map(it => 
    `<div class="item" role="listitem">
      ${renderImages(it)}
      <div class="iname">${it.name}</div>
      <div class="iprice">${it.price}</div>
    </div>`
  );
}

// Inisialisasi atau update Clusterize.js
function buildGrid(filter = 'combo') {
  const rows = buildGridRows(filter);
  if (!clusterize) {
    clusterize = new Clusterize({
      rows,
      scrollId: 'scrollArea',
      contentId: 'contentArea',
      no_data_text: '<div style="padding:24px;text-align:center;">Menu kosong</div>',
    });
  } else {
    clusterize.update(rows);
  }
}

// --- Kategori: best practice ---
const allowedCategories = Array.from(document.querySelectorAll('.cat')).map(btn => btn.getAttribute('data-cat'));
document.querySelectorAll('.cat').forEach(btn => {
  btn.addEventListener('click', () => {
    document.querySelectorAll('.cat').forEach(b => b.classList.remove('active'));
    btn.classList.add('active');
    const cat = btn.getAttribute('data-cat');
    buildGrid(allowedCategories.includes(cat) ? cat : 'combo');
  });
});

// Event openMenu dari NUI
window.addEventListener('message', function(event){
  if(event.data && event.data.action === 'openMenu'){
    document.body.style.display = 'block';
    const outer = document.getElementById('outerFrame');
    outer.setAttribute('aria-hidden','false');
    // Set tab aktif ke Paket Combo saat pertama kali buka
    document.querySelectorAll('.cat').forEach(b=>b.classList.remove('active'));
    const comboBtn = document.querySelector('.cat[data-cat="combo"]');
    if (comboBtn) comboBtn.classList.add('active');
    // load data dari config, lalu render Clusterize
    loadMenuData().then(()=> buildGrid('combo'));
  }
});

// Close menu
document.getElementById('closeX').addEventListener('click', ()=>{
  fetch(`https://${GetParentResourceName()}/closeMenu`, { method:'POST', headers:{'Content-Type':'application/json'}, body: JSON.stringify({}) });
  document.body.style.display = 'none';
  document.getElementById('outerFrame').setAttribute('aria-hidden','true');
});
