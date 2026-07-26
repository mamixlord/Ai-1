<?php
namespace App\Services\Integrations;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
final class YouTubeService { public function channel(string $id): array { return Cache::remember("youtube:channel:$id",3600,fn()=>Http::baseUrl('https://www.googleapis.com/youtube/v3')->get('/channels',['part'=>'snippet,statistics,contentDetails','id'=>$id,'key'=>config('services.youtube.key')])->throw()->json()); } }
