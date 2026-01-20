# 🛠 Teknik Şartname ve Sistem Mimarisi

## 1. Teknoloji Yığın Analizi (Stack Analysis)
Proje, mikroservis mimarisine göz kırpan bir modüler yapıya sahiptir:
- **Backend:** Python 3.x (Flask Framework)
- **Concurrency:** APScheduler (Background Threads)
- **IO Operations:** Linux Subprocess API
- **Frontend:** HTML5, CSS3 (Bootstrap 5), JavaScript (Async Fetch API)
- **Log Streaming:** Server-Sent Events (SSE)

## 2. Sistem Mimarisi (Architectural Layers)



### A. Web Katmanı (Presentation Layer)
İstemci tarafı, sunucuyla asenkron (AJAX) haberleşir. Log akışı için sürekli bir HTTP bağlantısı açık tutulur (Streaming).

### B. Uygulama Mantığı (Logic Layer)
`app.py`, bir **Orchestrator** (yönetici) görevi görür. 
- **Zamanlama Mantığı:** Görevler Python belleğinde (Heap) tutulur. 
- **Hata Yakalama:** `try-except-finally` blokları ile çalışma zamanı (runtime) hataları izole edilir.

### C. Sistem Katmanı (OS Layer)
`backup.sh` bir **Worker**'dır. 
- **Atomik İşlem:** Yedekleme işlemi sırasında dosya kilitlenmesi riskine karşı `zip` komutu güvenli modda çalıştırılır.
- **Exit Codes:** Bash script, işlem sonunda `0` (Başarılı) veya `1` (Hata) dönerek Python'u bilgilendirir.

## 3. Veri Akışı ve Protokoller
1. **JSON Over HTTP:** Arayüzden sunucuya veri transferi.
2. **Standard Output (Stdout):** Bash'ten Python'a veri aktarımı.
3. **Telegram Bot API:** Sunucudan dış dünyaya HTTPS protokolü ile veri transferi (Multipart Form-Data).

## 4. Ölçeklenebilirlik ve Sınırlar
- **Maksimum Görev:** APScheduler teorik olarak binlerce eşzamanlı görevi yönetebilir.
- **Dosya Boyutu:** Telegram Bot API limiti olan 50MB'a kadar olan dosyalar desteklenir. 

---
