<?php
namespace App\Contracts;
interface SubscriptionPaymentProviderInterface { public function subscribe(array $subscription): array; public function cancel(string $providerId): void; }
