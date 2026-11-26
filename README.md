# English Fokus — Aplikasi Belajar Bahasa Inggris Dewasa (A1–B1)

Aplikasi mobile *offline-first* berbasis **Flutter + SQLite (Drift)** yang dirancang khusus untuk pembelajar dewasa (usia 30+) agar mudah mengingat kosakata dan memahami pola bahasa Inggris tanpa menghafal mati.

## Fitur Utama
1. **Smart Flashcard SRS (Algoritma SM-2):**
   - Kosakata bertahap level **A1, A2, hingga B1** dengan panduan baca ramah lidah Indonesia, konteks kalimat kerja/keseharian, dan **Jembatan Keledai (*Memory Hook*)** yang bisa diedit sendiri.
   - Audio *offline* **1.0x Normal** dan **0.75x Lambat**.
2. **Micro-Reading & Tap-to-Translate:**
   - Bacaan pendek bertopik dewasa (kantor, bandara, keuangan bulanan, *remote work*, *work-life balance*).
   - Ketuk kata mana saja di dalam teks untuk melihat arti instan, mendengar suara, dan menyimpannya langsung ke antrean hafalan SRS.
3. **Grammar Intuitif & Sentence Builder:**
   - Penjelasan logika tata bahasa sehari-hari tanpa istilah rumit + latihan interaktif menyusun keping kata (*active recall*).
4. **Habit Tracker & Streak Freeze:**
   - Target waktu fleksibel (**5 / 10 / 15 menit**), grafik 7 hari terakhir, pengingat notifikasi lokal, dan **Streak Freeze otomatis** (aman saat libur 1 hari karena lembur).

---

## Cara Build & Download APK Langsung dari HP Android (GitHub Actions)

Karena proyek ini dilengkapi workflow [`.github/workflows/build_apk.yml`](.github/workflows/build_apk.yml), Anda tidak memerlukan laptop/PC untuk mengompilasi file `.apk`:

1. Buat repository kosong baru di akun GitHub Anda (misal `english-adult-learner`).
2. Dari terminal di dalam folder `english_adult_learner`, jalankan:
   ```bash
   git add .
   git commit -m "Initial MVP English Fokus A1-B1"
   git branch -M main
   git remote add origin https://github.com/<USERNAME_ANDA>/<NAMA_REPO>.git
   git push -u origin main
   ```
3. Buka tab **Actions** pada repository GitHub Anda melalui browser HP.
4. Tunggu sekitar 3–5 menit hingga job **Test & Build Release APK** berwarna hijau.
5. Unduh bagian **Artifacts -> `english-fokus-arm64-v8a-apk`**, ekstrak file `.zip`-nya, lalu install **`app-arm64-v8a-release.apk`** di HP POCO (`aarch64`) Anda!

---

## Menjalankan Secara Lokal (Jika Menggunakan PC dengan Flutter SDK)
```bash
flutter create --platforms=android --org com.example .
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter test
flutter run
```
