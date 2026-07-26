# Cron

cPanel Cron Jobs'a PHP'nin mutlak yolu ve proje yoluyla ekleyin:

```cron
* * * * * cd /home/USER/app && /usr/local/bin/php artisan schedule:run >> /dev/null 2>&1
* * * * * cd /home/USER/app && /usr/local/bin/php artisan queue:work --stop-when-empty --max-time=50 >> /dev/null 2>&1
```

`withoutOverlapping` aynı scheduler işinin çakışmasını önler; başarısız işler `failed_jobs` üzerinden incelenir.
