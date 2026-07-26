<?php

namespace App\Providers;

use App\Contracts\AiProviderInterface;
use App\Contracts\PaymentProviderInterface;
use App\Services\AI\GeminiProvider;
use App\Services\AI\NvidiaNimProvider;
use App\Services\AI\OpenAiProvider;
use App\Services\Payments\StripePaymentProvider;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
use InvalidArgumentException;

final class AppServiceProvider extends ServiceProvider
{
    public function register(): void
    {
        $this->app->bind(AiProviderInterface::class, function (): AiProviderInterface {
            return match (config('services.ai.default_provider')) {
                'gemini' => $this->app->make(GeminiProvider::class),
                'openai' => $this->app->make(OpenAiProvider::class),
                'nvidia_nim' => $this->app->make(NvidiaNimProvider::class),
                default => throw new InvalidArgumentException('Desteklenmeyen AI sağlayıcısı.'),
            };
        });

        $this->app->bind(PaymentProviderInterface::class, StripePaymentProvider::class);
    }

    public function boot(): void
    {
        RateLimiter::for('login', fn (Request $request) => Limit::perMinute(5)
            ->by($request->ip().'|'.$request->string('email')));
        RateLimiter::for('analysis', fn (Request $request) => Limit::perMinute(10)
            ->by((string) $request->user()?->id));
    }
}
