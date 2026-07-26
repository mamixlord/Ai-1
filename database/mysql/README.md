# MySQL kurulum dosyaları

Bu klasör, Composer/Artisan erişimi kısıtlı cPanel ortamları için MySQL 8.0+ kurulum alternatifi sağlar. Normal deployment'ta kaynak gerçekliği Laravel migrationlarıdır ve `php artisan migrate --force` tercih edilmelidir.

## Dosyalar

1. `00_create_database.sql`: veritabanı ve least-privilege uygulama kullanıcısı oluşturur. Parolayı çalıştırmadan önce değiştirin.
2. `01_schema.sql`: InnoDB/utf8mb4 tablolarını, foreign key ve indeksleri, kredi bakiyesi CHECK constraint'ini ve append-only ledger trigger'larını oluşturur.
3. `02_seed_catalog.sql`: dört ürünü, her ürünün üç paketini ve düzenlenebilir başlangıç haklarını idempotent olarak ekler.
4. `03_verify_installation.sql`: tablo motoru/collation, paket sayıları ve ledger trigger'larını doğrular.

## Komut satırı kurulumu

```bash
mysql -u root -p < database/mysql/00_create_database.sql
mysql -u rekabet_app -p rekabet < database/mysql/01_schema.sql
mysql -u rekabet_app -p rekabet < database/mysql/02_seed_catalog.sql
mysql -u rekabet_app -p rekabet < database/mysql/03_verify_installation.sql
```

cPanel phpMyAdmin kullanılıyorsa dosyaları aynı sırayla **Import** ekranından yükleyin. `00_create_database.sql` çoğu paylaşımlı hostingte çalıştırılmaz; veritabanını ve kullanıcıyı cPanel MySQL Databases ekranından oluşturup kullanıcıya tüm uygulama yetkilerini atayın.

## Güvenlik ve bakım

- SQL dosyalarında production API anahtarı, kullanıcı parolası veya demo hesabı bulunmaz.
- Uygulama kullanıcısına global ya da `GRANT OPTION` yetkisi vermeyin.
- `credit_ledger` UPDATE/DELETE trigger'larını kaldırmayın; düzeltmeler ters kayıtla yapılır.
- Kurulumdan sonra `.env` içindeki `DB_*` alanlarını güncelleyin ve SQL dosyalarını web root dışında tutun.
- Migration ile SQL dump'ı aynı veritabanında art arda çalıştırmayın. Laravel migration geçmişi gerekliyse temiz bir veritabanında migration yolunu kullanın.
- Yedekleri şifreli ve web root dışında saklayıp düzenli geri yükleme testi yapın.
