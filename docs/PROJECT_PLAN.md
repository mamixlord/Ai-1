# Proje planı

1. **Temel:** Laravel 13, kimlik, organizasyon üyeliği ve tenant politikaları.
2. **Ticari çekirdek:** veritabanı yönetimli ürün/paket, snapshot abonelik, ödeme ve append-only kredi defteri.
3. **Toplama:** Apify sosyal actor'ları, önbellekli YouTube API ve SSRF korumalı web crawler.
4. **Zekâ:** normalize içerik, deterministik metrik, kanıt bağlı yapılandırılmış AI analizleri.
5. **Sunum:** Radar, rapor/PDF/CSV, danışman, kullanıcı ve süper admin ekranları.
6. **İşletim:** database queue, cron, KVKK yaşam döngüsü, audit ve production sertleştirme.

Küçük belirsizliklerde varsayım: para minor-unit integer, kimlik UUID, durumlar genişletilebilir string ve her tenant kaydı `organization_id` taşır.
