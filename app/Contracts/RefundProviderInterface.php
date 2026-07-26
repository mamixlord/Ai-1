<?php
namespace App\Contracts;
interface RefundProviderInterface { public function refund(string $paymentId, int $minorAmount): array; }
