# Mimari

Blade tabanlı modüler monolit; HTTP/Form Request/Policy katmanı uygulama servislerini çağırır. Uzun işler database queue ile idempotent job zincirlerinde çalışır. Organizasyon bağlamı sorgu kapsamı ve policy ile iki katmanlı korunur. Harici servisler kontrat/adapter arkasındadır. Toplama çıktısı önce normalize edilir; sayısal sonuçlar PHP metrik motorundan, anlatısal sonuçlar kanıt kimlikli AI katmanından gelir. Kredi servisi transaction, satır kilidi ve benzersiz idempotency anahtarı kullanır.
