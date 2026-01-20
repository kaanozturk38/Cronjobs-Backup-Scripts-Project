
---

### `docs/documentation.md`

# 📖 Sistem Kullanım ve Operasyonel Yönetim Kılavuzu

Bu döküman, **Linux Yedekleme ve Görev Zamanlayıcı** sisteminin kurulumu, konfigürasyonu, operasyonel süreçleri ve hata giderme prosedürlerini kapsar.

---

## 1. Sisteme Genel Bakış

Sistem; karmaşık Cron zamanlamalarını, Linux dosya sistemi işlemlerini ve bulut tabanlı bildirim mekanizmalarını tek bir merkezden yöneten hibrit bir otomasyon aracıdır. Temel amacı, sistem yöneticilerine teknik karmaşadan uzak, görsel bir yedekleme deneyimi sunmaktır.

---

## 2. Kurulum ve Deployment (Devreye Alma)

### 2.1. Sistem Gereksinimleri

* **İşletim Sistemi:** Ubuntu 20.04+, Debian veya WSL (Windows Subsystem for Linux).
* **Bağımlılıklar:** `zip` yardımcı programı sisteme `sudo apt install zip` komutu ile dahil edilmelidir.
* **Çalışma Zamanı:** Python 3.8+ ortamı sağlanmalıdır.

### 2.2. Dizin Yapılandırması

Uygulamanın çalışabilmesi için aşağıdaki dosya izinleri kritik öneme sahiptir:

```bash
# Script'e çalıştırma yetkisi verilir
chmod +x backup.sh

# Çıktı klasörü için yazma izni (Opsiyonel)
chmod 755 /hedef/yedekleme/dizini

```

---

## 3. Kullanıcı Arayüzü Rehberi

### 3.1. Görev Tanımlama Paneli

Arayüz üç temel girdi üzerinde yükselir:

1. **Sorumlu Operatör:** İşlemi kayıt altına alan yetkilinin kimliği.
2. **Dosya Yolu (Target Path):** Yedeklenecek objenin sistemdeki mutlak (absolute) yolu.
3. **Cron Dizisi:** `minute hour day month day_of_week` formatındaki zamanlama parametresi.

### 3.2. Canlı İzleme (Real-time Monitoring)

Panelin alt kısmında yer alan "Görev Durumları" tablosu, **Server-Sent Events (SSE)** teknolojisini kullanır. Sunucu tarafında tetiklenen her yedekleme işlemi, sayfa yenilenmesine gerek kalmadan anlık olarak tabloya "Push" edilir.

---

## 4. Bildirim Sistemi ve Telegram Entegrasyonu

Sistem, yedekleme tamamlandığında otomatik olarak iki aşamalı bildirim gönderir:

1. **Status Message:** İşlemin başarı/hata durumu, sorumlu kişi ve tarih bilgisi.
2. **Artifact Delivery:** Oluşturulan `.zip` paketi, doğrudan Telegram sohbetine bir dosya objesi olarak iletilir.

---

## 5. Hata Senaryoları ve Çözümler (Troubleshooting)

| Belirti | Olası Neden | Çözüm |
| --- | --- | --- |
| **HTTP 400 Hatası** | Geçersiz Cron dizimi veya eksik alan. | Cron ifadesinin 5 parçadan oluştuğunu teyit edin (Örn: `* * * * *`). |
| **Dosya Bulunamadı Hatası** | Yanlış mutlak yol kullanımı. | Terminalde `readlink -f dosya_adi` komutuyla tam yolu alın. |
| **Zamanlanan Görev Çalışmıyor** | Python Scheduler saati ile sistem saati farkı. | Terminalde `date` komutuyla sistem saatini kontrol edin. |
| **Telegram Mesajı Gelmiyor** | Hatalı Bot Token veya Chat ID. | Botun `@userinfobot` üzerinden alınan ID ile konfigüre edildiğinden emin olun. |

---

## 6. Güvenlik ve Uyumluluk

* **Data Privacy:** Sistem, yedeklenen dosyaları sunucu üzerinde kalıcı olarak depolamaz (Opsiyonel olarak `os.remove()` aktif edilebilir).
* **Validation:** Tüm girdiler sunucu tarafında (Backend) `cron_descriptor` ve `try-except` blokları ile sanitize edilmektedir.
