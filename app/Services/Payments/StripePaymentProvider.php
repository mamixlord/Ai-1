<?php
namespace App\Services\Payments;
use App\Contracts\PaymentProviderInterface;
use Illuminate\Support\Facades\Http;
use RuntimeException;
final class StripePaymentProvider implements PaymentProviderInterface
{
 public function checkout(array $p): array { return Http::asForm()->withBasicAuth((string)config('services.stripe.secret'),'')->post('https://api.stripe.com/v1/checkout/sessions',['mode'=>$p['mode']??'payment','success_url'=>$p['success_url'],'cancel_url'=>$p['cancel_url'],'line_items[0][price]'=>$p['price_id'],'line_items[0][quantity]'=>1,'client_reference_id'=>$p['reference']])->throw()->json(); }
 public function verifyWebhook(string $payload,string $signature): array { $parts=[]; foreach(explode(',',$signature) as $part){[$k,$v]=array_pad(explode('=',$part,2),2,null);$parts[$k]=$v;} $timestamp=$parts['t']??'';$expected=hash_hmac('sha256',$timestamp.'.'.$payload,(string)config('services.stripe.webhook_secret')); if(abs(time()-(int)$timestamp)>300||!isset($parts['v1'])||!hash_equals($expected,$parts['v1'])) throw new RuntimeException('Geçersiz webhook imzası.'); return json_decode($payload,true,512,JSON_THROW_ON_ERROR); }
}
