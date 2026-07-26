# Production checklist

- [ ] `APP_ENV=production`, `APP_DEBUG=false`, benzersiz `APP_KEY`, HTTPS
- [ ] DB least-privilege kullanıcı, yedek ve geri yükleme testi
- [ ] Secure cookie, SMTP ve doğrulanmış gönderen
- [ ] Apify/YouTube/AI/Stripe secret ve webhook rotasyonu
- [ ] Migration, storage link, optimize; yazılabilir storage/cache
- [ ] Scheduler ve kısa ömürlü queue cron'u gözlemleniyor
- [ ] Günlük log rotation, hassas veri maskeleme, alertler
- [ ] Demo parolaları değişti, süper admin 2FA etkin
- [ ] Veri saklama/temizleme ve KVKK talepleri test edildi
