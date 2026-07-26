<?php
namespace App\Services\AI;
use App\Contracts\AiProviderInterface;
use Illuminate\Support\Facades\Http;
use RuntimeException;
final class GeminiProvider implements AiProviderInterface
{
 public function structured(array $messages,array $schema,array $options=[]): array {
  $key=(string)config('services.gemini.key'); if($key==='') throw new RuntimeException('Gemini API anahtarı yapılandırılmamış.');
  $model=$options['model']??env('AI_DEFAULT_MODEL','gemini-2.5-flash');
  $response=Http::timeout($options['timeout']??45)->retry(2,500)->post("https://generativelanguage.googleapis.com/v1beta/models/{$model}:generateContent?key={$key}",['contents'=>[['parts'=>[['text'=>json_encode($messages,JSON_UNESCAPED_UNICODE)]]]],'generationConfig'=>['responseMimeType'=>'application/json','responseJsonSchema'=>$schema,'temperature'=>$options['temperature']??0.2]]);
  $response->throw(); $text=data_get($response->json(),'candidates.0.content.parts.0.text'); $decoded=json_decode((string)$text,true);
  if(!is_array($decoded)) throw new RuntimeException('AI sağlayıcısı geçerli yapılandırılmış yanıt vermedi.'); return $decoded;
 }
}
