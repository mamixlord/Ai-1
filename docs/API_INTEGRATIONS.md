# API entegrasyonları

- **Apify:** Bearer token; actor/run/dataset uçları; webhook HMAC, event idempotency ve normalizer kuyruğu.
- **YouTube Data API v3:** API key, kanal/video parçaları ve saatlik cache; kota hatası kullanıcıya kontrollü yansıtılır.
- **Gemini/OpenAI:** JSON Schema cevap, düşük sıcaklık, timeout/retry, kanıt zorunluluğu; scraped içerik güvenilmeyen veri olarak ayrılır.
- **Stripe:** hosted Checkout, imzalı ve beş dakika toleranslı webhook; event ID unique; kart verisi tutulmaz.
- **PageSpeed:** `PAGESPEED_API_KEY` varsa opsiyonel web metriği.

Tüm secret'lar `.env` veya encrypted cast'te tutulur ve log bağlamından maskelenir.

## NVIDIA NIM

OpenAI uyumlu NVIDIA NIM chat-completions adapterı kullanılabilir. `AI_DEFAULT_PROVIDER=nvidia_nim` seçildikten sonra `NVIDIA_NIM_API_KEY`, HTTPS base URL ve erişilebilir model kimliği girilmelidir. Ayrıntılı kurulum `docs/NVIDIA_NIM.md` dosyasındadır.
