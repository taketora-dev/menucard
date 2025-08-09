# Menu Card (Standalone)

Menu Card adalah sistem menu digital untuk restoran (FiveM/GTAV) dengan tampilan modern dan performa tinggi, mendukung virtual scroll untuk ribuan item menu.

## Fitur
- **Tampilan modern dan responsif** (HTML, CSS, JS)
- **Integrasi dengan Lua config** (untuk data menu dinamis)
- **Virtual scroll** dengan Clusterize.js (super cepat walau menu sangat banyak)
- **Kategori menu** (Combo, Food, Drink, Dessert) mudah dikustomisasi
- **Aksesibilitas**: navigasi keyboard, ARIA role pada elemen penting
- **Mudah diintegrasikan** ke resource restoran Anda

## Cara Pakai

### 1. Instalasi
1. Clone repo ini ke resource folder server FiveM Anda.
2. Pastikan semua file `html/`, `client.lua`, `server.lua`, dan `config.lua` ada.

### 2. Konfigurasi Menu
Edit `config.lua` untuk menambah/ubah paket combo, food, drink, dessert, harga, dan deskripsi.

### 3. Jalankan
Tambahkan resource ke `server.cfg`:
```
ensure menucard
```

### 4. Virtual Scroll (Clusterize.js)
- Tidak perlu setup tambahan, sudah include via CDN di `html/index.html`.
- Jika menu Anda sangat banyak, performa tetap lancar!

## Struktur File
- `html/index.html` — UI utama menu
- `html/style.css` — styling modern & responsif
- `html/script.js` — logika menu, kategori, virtual scroll
- `config.lua` — konfigurasi menu dan lokasi
- `client.lua` — integrasi dengan gameplay
- `server.lua` — log server & order handler

## Customisasi
- Untuk menambah kategori: tambahkan tombol di `index.html` dan daftarkan di `config.lua`.
- Untuk ganti gambar menu: taruh file gambar di `html/img/` dan sesuaikan `name` pada config.

## Dependensi
- [Clusterize.js](https://clusterize.js.org/) (sudah di-load via CDN, tidak perlu install manual)

## Credit
- Dibuat oleh [Taketora](https://github.com/yon0697)
- Inspirasi UI: OurCity RP

## Lisensi
Lihat file [LICENSE](LICENSE).

---
