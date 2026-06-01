Berikut adalah draft struktur dan deskripsi README.md yang profesional, menarik, dan representatif untuk proyek MorseQuest kamu. Kamu bisa menyalin teks di bawah ini dan menyimpannya sebagai file README.md di root directory repositori (baik untuk Frontend maupun Backend).

🚀 MorseQuest
Petualangan seru belajar Sandi Morse melalui sentuhan jari!

MorseQuest adalah aplikasi edukasi interaktif berbasis mobile yang dirancang untuk membuat proses belajar Sandi Morse menjadi menyenangkan, intuitif, dan tidak membosankan. Melalui pendekatan gamification, aplikasi ini mengajak pengguna—terutama anak-anak dan pemula—untuk menghafal dan mempraktikkan kode Morse (Alfabet dan Angka) melalui petualangan dan misi yang interaktif.

Proyek ini dibangun menggunakan Flutter untuk sisi Frontend (mobile app) dan Go (Golang) untuk sisi Backend (REST API).

✨ Fitur Utama
📚 Kamus Sandi Morse Interaktif (Library)
Pelajari 26 alfabet dan 10 angka beserta kode Morsenya (titik dan garis). Dilengkapi dengan fitur toggle pencarian dan audio (suara sandi).

🎮 Level Permainan Terstruktur
Pilih tingkat kesulitan petualanganmu: Gampang (huruf dasar), Sedang (kata umum), atau Sulit (kosakata rumit) dengan antarmuka carousel yang mulus.

📡 Transmisi Real-Time (Play/Transmit)
Sistem input inovatif di mana pengguna dapat memasukkan kode Morse langsung dengan menekan tombol utama: Tap Short untuk Titik (Dot) dan Hold Long untuk Garis (Dash).

👤 Profil & Progres Pemain
Pantau pencapaian, kumpulkan Bintang & Koin dari setiap misi, dan tingkatkan Pangkat/Level Morse kamu.

🛠️ Teknologi yang Digunakan
Aplikasi ini dipisahkan menjadi dua repositori/bagian utama:

Frontend (Mobile App)

Framework: Flutter (Dart)

State Management: (Isi dengan arsitektur yang kamu gunakan, misal: BLoC / Provider / GetX)

Arsitektur: Feature-First / Folder-by-Feature (Shared & Features)

Backend (REST API)

Bahasa Pemrograman: Go (Golang)

Framework: Gin Web Framework

Live Reload: Air

Arsitektur: Layered Architecture (Controllers, Services, Repositories)

Database: (Isi dengan database pilihanmu, misal: PostgreSQL / MySQL)

📂 Struktur Proyek
Proyek ini menerapkan pemisahan kode yang rapi. Berikut adalah gambaran singkat strukturnya:

Frontend (Flutter)
Plaintext
lib/
├── core/       # Konstanta, Tema, Utilities
├── data/       # Model, Network, Storage lokal
├── features/   # Fitur utama (Auth, Library, Main Page, Game, Profile, About)
│   └── [feature_name]/
│       ├── logic/
│       ├── screens/
│       └── widgets/
└── shared/     # Widget global (seperti Custom Bottom Nav)
Backend (Golang)
Plaintext
morsequest-backend/
├── cmd/api/          # Entry point utama aplikasi (main.go)
├── internal/         # Kode tertutup aplikasi
│   ├── config/       # Setup database
│   ├── controllers/  # Handler HTTP (Input/Output API)
│   ├── models/       # Struct data (User, Level, dll)
│   ├── repositories/ # Query langsung ke Database
│   ├── routes/       # Definisi endpoint API
│   └── services/     # Logika bisnis
└── pkg/              # Helper dan utilitas publik
🚀 Cara Menjalankan Proyek (Getting Started)
Prasyarat
Flutter SDK terinstal (untuk Frontend).

Go terinstal beserta air untuk live-reloading (untuk Backend).

Emulator Android/iOS atau device fisik.

Menjalankan Backend (Golang)
Buka terminal dan masuk ke folder backend.

Jalankan perintah go mod tidy untuk mengunduh dependensi.

Jalankan server dengan perintah:

air

4. Server akan berjalan di `http://localhost:8080`.

### Menjalankan Frontend (Flutter)
1. Buka terminal dan masuk ke folder frontend.
2. Jalankan perintah `flutter pub get` untuk mengunduh paket.
3. Jalankan aplikasi di emulator atau perangkat fisik dengan perintah:
   ```bash
   flutter run