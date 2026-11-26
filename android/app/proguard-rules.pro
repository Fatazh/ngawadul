# Pertahankan kelas notifikasi terjadwal agar tidak dihapus R8 saat build release APK
-keep class com.dexterous.** { *; }
-dontwarn com.dexterous.**
