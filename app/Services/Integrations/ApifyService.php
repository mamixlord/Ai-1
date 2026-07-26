<?php
namespace App\Services\Integrations;
use Illuminate\Http\Client\PendingRequest;
use Illuminate\Support\Facades\Http;
final class ApifyService
{
 private function client(): PendingRequest { return Http::baseUrl('https://api.apify.com/v2')->withToken((string)config('services.apify.token'))->acceptJson()->timeout(60)->retry(3,500); }
 public function start(string $actorId,array $input): array { return $this->client()->post('/acts/'.rawurlencode($actorId).'/runs',$input)->throw()->json('data'); }
 public function status(string $runId): array { return $this->client()->get('/actor-runs/'.rawurlencode($runId))->throw()->json('data'); }
 public function dataset(string $datasetId,int $offset=0,int $limit=1000): array { return $this->client()->get('/datasets/'.rawurlencode($datasetId).'/items',compact('offset','limit'))->throw()->json(); }
 public function validSignature(string $payload,string $signature): bool { $secret=(string)config('services.apify.webhook_secret'); return $secret!==''&&hash_equals(hash_hmac('sha256',$payload,$secret),$signature); }
}
