<?php
namespace App\Services\AI;
use App\Contracts\AiProviderInterface;
use Illuminate\Support\Facades\Http;
use RuntimeException;
final class OpenAiProvider implements AiProviderInterface
{
 public function structured(array $messages,array $schema,array $options=[]): array {
  $key=(string)config('services.openai.key'); if($key==='') throw new RuntimeException('OpenAI API anahtarı yapılandırılmamış.');
  $r=Http::withToken($key)->timeout($options['timeout']??45)->retry(2,500)->post('https://api.openai.com/v1/responses',['model'=>$options['model']??'gpt-5-mini','input'=>$messages,'text'=>['format'=>['type'=>'json_schema','name'=>'competitive_analysis','strict'=>true,'schema'=>$schema]]]);
  $r->throw(); $decoded=json_decode((string)data_get($r->json(),'output.0.content.0.text'),true); if(!is_array($decoded)) throw new RuntimeException('AI sağlayıcısı geçerli JSON vermedi.'); return $decoded;
 }
}
