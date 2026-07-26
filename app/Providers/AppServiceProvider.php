<?php
namespace App\Providers;
use App\Contracts\AiProviderInterface;
use App\Contracts\PaymentProviderInterface;
use App\Services\AI\GeminiProvider;
use App\Services\Payments\StripePaymentProvider;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
final class AppServiceProvider extends ServiceProvider
{
 public function register(): void { $this->app->bind(AiProviderInterface::class, GeminiProvider::class); $this->app->bind(PaymentProviderInterface::class, StripePaymentProvider::class); }
 public function boot(): void { RateLimiter::for('login', fn(Request $r)=>Limit::perMinute(5)->by($r->ip().'|'.$r->string('email'))); RateLimiter::for('analysis', fn(Request $r)=>Limit::perMinute(10)->by((string)$r->user()?->id)); }
}
