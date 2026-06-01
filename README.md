# morsequest

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


lib/
│
├── core/                   # Pengaturan inti dan utilitas global aplikasi
│   ├── constants/          # Warna tema, ukuran font, konstanta API endpoint
│   ├── theme/              # Konfigurasi ThemeData (warna ceria, font playful)
│   └── utils/              # Fungsi bantuan (misal: format waktu, konverter morse)
│
├── data/                   # Layer komunikasi dengan Backend
│   ├── models/             # Class model data (User, LeaderboardEntry, dll)
│   ├── network/            # Setup HTTP Client (Dio/http) untuk request API
│   └── storage/            # Local storage (Secure Storage) untuk simpan Token JWT
│
├── features/               # Halaman utama aplikasi, dibagi per fitur
│   ├── auth/               # Fitur Login & Register
│   │   ├── screens/        # UI Halaman (LoginScreen, RegisterScreen)
│   │   └── widgets/        # Komponen khusus auth (FormInput, LoginButton)
│   │
│   ├── gameplay/           # Fitur Utama (Challenge Mode & Latihan)
│   │   ├── logic/          # Logika timer, deteksi ketukan (dot/dash), nyawa
│   │   ├── screens/        # UI Halaman (ChallengeScreen, LobbyScreen)
│   │   └── widgets/        # Komponen (TapButton, HealthBar, TimerWidget)
│   │
│   ├── library/            # Fitur Kamus Morse
│   │   ├── screens/        # UI Halaman (MorseLibraryScreen)
│   │   └── widgets/        # Komponen khusus (MorseGridTile)
│   │
│   ├── leaderboard/        # Fitur Papan Peringkat
│   │   └── screens/        # UI Halaman (LeaderboardScreen)
│   │
│   └── profile/            # Fitur Profil User
│       └── screens/        # UI Halaman (ProfileScreen, SettingsScreen)
│
├── shared/                 # Komponen UI global yang dipakai di banyak tempat
│   ├── widgets/            # Custom button chunky, dialog pop-up, loading indicator
│   └── layouts/            # Dynamic Header, Bottom Navigation Bar
│
└── main.dart               # Titik awal aplikasi (Entry point)