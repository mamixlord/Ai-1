# NVIDIA NIM API yapılandırması

Uygulama NVIDIA NIM'in OpenAI uyumlu chat-completions uç noktasını `NvidiaNimProvider` adapterı üzerinden destekler. Anahtar yalnız environment/config katmanından okunur; isteğe veya log mesajına eklenmez.

## Environment

```dotenv
AI_DEFAULT_PROVIDER=nvidia_nim
NVIDIA_NIM_API_KEY=nvapi-...
NVIDIA_NIM_BASE_URL=https://integrate.api.nvidia.com/v1
NVIDIA_NIM_MODEL=meta/llama-3.3-70b-instruct
```

NVIDIA model kataloğunda hesabınız için etkin olan model kimliğini `NVIDIA_NIM_MODEL` alanına yazın. Self-hosted NIM kullanılıyorsa `NVIDIA_NIM_BASE_URL` HTTPS adresini kendi gateway'inize yöneltin. Provider güvenlik nedeniyle düz HTTP adreslerini reddeder.

Değişiklikten sonra Laravel config cache'ini yenileyin:

```bash
php artisan config:clear
php artisan config:cache
```

## Davranış

- Bearer authentication ve JSON istek gövdesi kullanılır.
- Timeout, retry, sıcaklık, maksimum token ve model çalışma zamanında override edilebilir.
- Streaming kapalıdır; kredi settlement için tek ve ölçülebilir yanıt beklenir.
- JSON dışındaki markdown fence yanıtları güvenli biçimde ayıklanır.
- Sonuç, çağrıda verilen JSON Schema'nın zorunlu alanları ve temel/nested türleriyle yerel olarak doğrulanır.
- Scrape edilmiş içerik güvenilmeyen harici veri olarak işaretlenir ve içindeki talimatların uygulanmaması sistem mesajında belirtilir.

API anahtarını repository'ye commit etmeyin. Model erişimi, kota ve fiyatlandırma NVIDIA hesabı tarafından sağlanmalıdır.
