# Research Result for gemini-fast


### 1. Çalışma Mantığı: Kavramsal ve Teknik Yaklaşım

**Kavramsal Olarak:**
Bir cronjob'u, bilgisayarınızın ajandasına eklediğiniz "şu saatte şu işi yap" notu olarak düşünebilirsiniz. Yedekleme scripti ise bu notun içeriğidir; yani "nereyi, nasıl ve nereye" kopyalayacağını bilen bir talimat listesidir.

**Teknik Olarak:**

* **Cron:** Unix benzeri işletim sistemlerinde arka planda çalışan bir **daemon (crond)** sürecidir. Sistem her dakika uyanır ve `/etc/crontab` veya kullanıcıya özel crontab dosyalarını kontrol eder. Zaman tanımı eşleşen bir görev bulduğunda, ilgili komutu yeni bir kabuk (shell) altında çalıştırır.
* **Yedekleme Scriptleri:** Genellikle Bash, Python veya Go ile yazılır. Kaynak veriyi (dosya veya veritabanı) okur, sıkıştırır (tar, gzip), şifreler ve bir hedefe (bulut, uzak sunucu veya lokal disk) transfer eder.

---

### 2. Kabul Görmüş En Doğru Yöntemler (Best Practices)

Sektör standartlarına göre güvenilir bir otomasyon şu kurallara dayanmalıdır:

* **3-2-1 Kuralı:** Verinin en az **3** kopyası olmalı, bunlar **2** farklı medya türünde saklanmalı ve **1** tanesi fiziksel olarak farklı bir konumda (off-site) bulunmalıdır.
* **Hata Yönetimi (Logging):** Scriptler sadece çalışmamalı, her adımı loglamalıdır. `2>&1` operatörü ile hata çıktıları mutlaka bir dosyaya yönlendirilmelidir.
* **İzleme (Monitoring):** "Yedekleme çalıştı mı?" sorusuna cevap veren bir sağlık kontrolü (Healthcheck) mekanizması (örn: Healthchecks.io) kullanılmalıdır.
* **Değişmezlik (Immutability):** Fidye yazılımlarına karşı, yedeklendikten sonra silinemeyen veya değiştirilemeyen "immutable storage" çözümleri tercih edilmelidir.

---

### 3. Açık Kaynak Araçlar ve Alternatifleri

Bu alanda tekerleği yeniden icat etmek yerine güçlü topluluk desteği olan araçlar kullanılır:

| Araç | Türü | Öne Çıkan Özelliği |
| --- | --- | --- |
| **Restic / BorgBackup** | Yedekleme Yazılımı | Deduplication (tekrarlanan veriyi silme) ve yerleşik şifreleme. |
| **Rclone** | Senkronizasyon | 40'tan fazla bulut sağlayıcısı (S3, Drive, Dropbox) ile veri transferi. |
| **Bacula / Bareos** | Kurumsal Yedekleme | Büyük veri merkezleri için kompleks ağ tabanlı yedekleme. |
| **Anacron** | Zamanlayıcı | Bilgisayarın kapalı olduğu sürelerde kaçırılan görevleri açılışta çalıştırır. |
| **Systemd Timers** | Zamanlayıcı | Cron'un modern alternatifi; bağımlılık yönetimi ve gelişmiş loglama sunar. |

---

### 4. Kritik Konfigürasyon Dosyaları ve Parametreler

Sistemde bu operasyonları yöneten ana dosyalar şunlardır:

* **/etc/crontab:** Sistem genelindeki görevleri içerir.
* **/var/spool/cron/crontabs/ [kullanıcı]:** Kullanıcılara özel görevlerin tutulduğu yerdir.
* **Parametreler (Cron Syntax):**
* `* * * * *` (Dakika, Saat, Gün, Ay, Haftanın Günü)
* `MAILTO`: Hata oluştuğunda çıktının gönderileceği e-posta adresi.
* `PATH`: Scriptin içindeki komutların bulunabilmesi için tanımlanan çevre değişkeni.



---

### 5. Güvenlik Riskleri

* **Yetki Yükseltme (Privilege Escalation):** Eğer bir cronjob `root` yetkisiyle çalışıyor ve script dosyası normal bir kullanıcı tarafından yazılabilir durumdaysa, saldırgan bu scripti değiştirerek sistemin tam kontrolünü ele geçirebilir.
* **Açık Metin Kimlik Bilgileri:** Scriptlerin içine doğrudan yazılan veritabanı şifreleri veya API keyler.
* **Eksik PATH Tanımı:** Script içinde `/bin/ls` yerine sadece `ls` kullanılması, saldırganın sahte bir `ls` dosyasıyla "Path Injection" yapmasına neden olabilir.

---

### 6. Neden Var? (İhtiyaç Analizi)

* **İnsan Hatasını Minimize Etmek:** Kimse her gece saat 03:00'te uyanıp manuel yedek almaz.
* **Felaket Kurtarma (Disaster Recovery):** Sunucu yanarsa veya hacklenirse iş sürekliliğini sağlamak.
* **Veri Tutarlılığı:** Veritabanı gibi sürekli değişen verilerin, sistemin en az yoğun olduğu saatlerde düzenli "snapshot"larının alınması gerekir.

---

### 7. Saldırgan Müdahale Ederse Ne Olur?

Bir saldırgan cronjoblara veya scriptlere sızarsa şu senaryolar gerçekleşir:

1. **Kalıcılık (Persistence):** Saldırgan kendi zararlı yazılımını her 5 dakikada bir çalışacak şekilde cron'a ekler. Siz dosyayı silseniz bile cron onu tekrar geri getirir.
2. **Veri Sızıntısı (Exfiltration):** Yedekleme scriptini manipüle ederek yedekleri kendi sunucusuna kopyalar.
3. **Veri Tahribatı:** Yedekleme işlemini durdurur veya yedek dosyalarını silerek/şifreleyerek (Ransomware) sizi savunmasız bırakır.
4. **Arka Kapı (Backdoor):** `root` yetkisindeki bir cronjob üzerinden sisteme her zaman girebileceği gizli bir kullanıcı oluşturur.

---
