# QLineSec

---

# 🚀 Linux Yedekleme Yönetim Paneli (Cron-Based Backup Manager)

Bu proje, Linux sistemler üzerinde zamanlanmış görevleri (Cron Jobs) yönetmek, yedekleme işlemlerini otomatize etmek ve sonuçları **Telegram** üzerinden anlık olarak takip etmek için geliştirilmiş bir web tabanlı yönetim arayüzüdür.

## ✨ Özellikler

* **İnsan Okunabilir Cron:** `*/5 * * * *` gibi karmaşık ifadeleri "Her 5 dakikada bir" gibi anlaşılır metinlere dönüştürür.
* **Zamanlanmış Görev Sihirbazı:** Kullanıcı dostu arayüz ile yeni yedekleme görevleri planlama.
* **Bash Script Entegrasyonu:** Yedekleme işlemleri Python üzerinden tetiklenen profesyonel bir `.sh` scripti ile yürütülür.
* **Otomatik Paketleme:** Yedeklenen dosyalar otomatik olarak `.zip` formatına sıkıştırılır.
* **Telegram Bildirimi:** İşlem tamamlandığında hem durum mesajı hem de yedeklenen dosya Telegram botu aracılığıyla iletilir.
* **Python SSE ile Canlı Log:** Sayfa yenilenmeden, arka planda gerçekleşen tüm işlemler Python üzerinden anlık olarak web arayüzüne yansıtılır.

---

## 🛠️ Kurulum ve Gereksinimler

### 1. Sistem Paketleri

Projenin yedekleme (zip) yapabilmesi için sistemde `zip` paketinin yüklü olması gerekir:

```bash
sudo apt update && sudo apt install zip -y

```

### 2. Python Bağımlılıkları

Gerekli tüm kütüphaneleri tek seferde kurmak için:

```bash
pip install flask apscheduler cron-descriptor requests urllib3 flask-cors --quiet

```

### 3. Dosya İzinleri

Yedekleme scriptinin çalışabilmesi için çalıştırma izni verilmelidir:

```bash
chmod +x backup.sh

```

---

## 🚀 Çalıştırma

1. `app.py` dosyasını açın ve `TELEGRAM_TOKEN` ile `CHAT_ID` alanlarını kendi bilgilerinizle güncelleyin.
2. Uygulamayı başlatın:
```bash
python3 app.py

```


3. Tarayıcınızdan `http://localhost:5000` adresine gidin.

---

## 📂 Proje Yapısı

* `app.py`: Ana sunucu, zamanlayıcı (Scheduler) ve Telegram entegrasyonu.
* `backup.sh`: Dosyaları sıkıştıran ve yedekleme mantığını yürüten Linux betiği.
* `templates/index.html`: Web arayüzü ve canlı log takip ekranı.
* `README.md`: Proje dökümantasyonu.

---

## 🛡️ Çalışma Mantığı

1. **Frontend:** Kullanıcıdan sorumluluk, dosya yolu ve cron bilgisini alır.
2. **Backend:** Gelen bilgiyi `APScheduler` ile zamanlar.
3. **Bash Script:** Zamanı geldiğinde Python tarafından tetiklenir, dosyayı zipleyip sonucu geri döndürür.
4. **Telegram API:** Python, hazırlanan zip dosyasını ve işlem sonucunu Telegram üzerinden kullanıcıya iletir.
5. **SSE (Server-Sent Events):** İşlem logu Python tarafından tarayıcıya "push" edilir.

---

> **Not:** Windows kullanıcıları, bu projeyi tam uyumlulukla çalıştırmak için **WSL (Windows Subsystem for Linux)** kullanmalıdır.

---

### Bu README dosyası projenin akademik sunumu için yeterli mi, yoksa "Teknik Detaylar" veya "Hata Giderme" gibi ek bölümler ekleyelim mi?
