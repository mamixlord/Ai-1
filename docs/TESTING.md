# Test

`php artisan test`, `vendor/bin/pint --test` ve `vendor/bin/phpstan analyse` çalıştırılır. Feature kapsamı tenant yetkisi, auth, paket/ödeme/webhook, rezervasyon/settlement ve rapor indirmedir. Unit kapsamı metrik sınırları, SSRF, normalizer ve AI JSON doğrulamasıdır. HTTP entegrasyonları `Http::fake`, eşzamanlı finans testleri gerçek MySQL ile çalıştırılır.
