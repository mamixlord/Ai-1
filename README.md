# Rekabet Insight

Laravel 13 tabanlı, organizasyon izoleli AI destekli rakip analiz SaaS çekirdeği. Instagram/TikTok için Apify, YouTube Data API, güvenli PHP crawler, Gemini/OpenAI ve Stripe adapter mimarisi içerir.

## Gereksinimler ve kurulum

PHP 8.3+, MySQL 8+, Composer 2 ve gereken PHP eklentileri (`ctype`, `curl`, `dom`, `fileinfo`, `mbstring`, `openssl`, `pdo_mysql`, `tokenizer`, `xml`).

```bash
composer install
cp .env.example .env
php artisan key:generate
php artisan migrate --seed
php artisan storage:link
php artisan serve
```

Demo hesapları: `admin@demo.test` ve `demo@demo.test`; parola `ChangeMe!2026`. Bunları production'da derhal değiştirin.

## İşletim

```bash
php artisan schedule:run
php artisan queue:work --stop-when-empty --max-time=50
php artisan test
vendor/bin/pint --test
vendor/bin/phpstan analyse
```

Production kurulumu: `APP_ENV=production`, `APP_DEBUG=false`, HTTPS ve güvenli cookie ayarlarını kullanın; ardından:

```bash
composer install --no-dev --optimize-autoloader
php artisan migrate --force
php artisan storage:link
php artisan optimize
```

`storage` ile `bootstrap/cache` web kullanıcısı tarafından yazılabilir olmalıdır. Cron ayrıntıları `docs/CRON_SETUP.md` içindedir.

## Dış servisler

`.env` içinde Apify token/webhook secret, YouTube API anahtarı, seçilen Gemini veya OpenAI anahtarı, Stripe anahtarları ve SMTP değerlerini girin. Kart verisi uygulamada tutulmaz. PageSpeed isteğe bağlıdır.

## Doğrudan MySQL kurulumu

Artisan çalıştırılamayan kısıtlı cPanel ortamlarında `database/mysql/README.md` içindeki MySQL 8 kurulum dosyaları sırayla içe aktarılabilir. Normal kurulumlarda migrationlar kaynak gerçekliğidir; SQL dump ile migration yolunu aynı veritabanında birlikte kullanmayın.

### NVIDIA NIM

NVIDIA NIM kullanmak için `AI_DEFAULT_PROVIDER=nvidia_nim` seçin ve `NVIDIA_NIM_API_KEY`, `NVIDIA_NIM_BASE_URL`, `NVIDIA_NIM_MODEL` değerlerini girin. Model erişimi ve kota NVIDIA hesabından sağlanır; ayrıntılar `docs/NVIDIA_NIM.md` dosyasındadır.
