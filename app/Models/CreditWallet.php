<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Concerns\HasUuids; use Illuminate\Database\Eloquent\Model;
final class CreditWallet extends Model { use HasUuids; protected $guarded=[]; protected function casts():array{return ['subscription_balance'=>'decimal:4','promotion_balance'=>'decimal:4','purchased_balance'=>'decimal:4','reserved_balance'=>'decimal:4'];} }
