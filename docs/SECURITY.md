# Güvenlik

CSRF, Blade escaping, validation, rate limiting, secure/HttpOnly/SameSite cookie ve policy kullanılır. Crawler yalnız HTTP(S), 80/443 ve public IP kabul eder; her redirect yeniden doğrulanmalıdır. DNS cevaplarının tamamı kontrol edilir. Webhook HMAC ve idempotency zorunludur. Kredi satırı kilitlenir, ledger güncellenemez. API anahtarı, parola, token, kart ve tam kişisel veri loglanmaz. Scrape metni prompt talimatı sayılmaz. İhlaller `security_events`, yetkili değişiklikler `audit_logs` kayıtlarına yazılır.
