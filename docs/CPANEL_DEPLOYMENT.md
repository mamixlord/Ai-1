# cPanel deployment

1. PHP 8.3+, gerekli eklentiler ve MySQL 8 veritabanını etkinleştirin.
2. Depoyu home altında açın; document root'u projenin `public/` dizinine yöneltin.
3. README production Composer komutunu çalıştırın, `.env` oluşturup `php artisan key:generate` uygulayın.
4. DB/SMTP/API değerlerini girin; `storage` ve `bootstrap/cache` yazma izinlerini web kullanıcısına verin.
5. `migrate --force`, `storage:link`, `optimize` çalıştırın. Public kökün yönlendirilemediği hostingte yalnızca `public` içeriğini web köküne taşıyıp `index.php` yollarını mutlak proje yoluna düzeltin.
6. Cron kayıtlarını ekleyin; HTTPS yönlendirmesi, `APP_DEBUG=false`, günlük log rotasyonu ve günlük yedek doğrulamasını kontrol edin.
