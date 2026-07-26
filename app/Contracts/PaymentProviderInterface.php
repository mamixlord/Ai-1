<?php
namespace App\Contracts;
interface PaymentProviderInterface { public function checkout(array $purchase): array; public function verifyWebhook(string $payload, string $signature): array; }
