<?php
namespace App\Models;
use LogicException; use Illuminate\Database\Eloquent\Concerns\HasUuids; use Illuminate\Database\Eloquent\Model;
final class CreditLedger extends Model { use HasUuids; protected $table='credit_ledger'; protected $guarded=[]; public function save(array $options=[]){if($this->exists)throw new LogicException('Kredi defteri kayıtları değiştirilemez.');return parent::save($options);} public function delete(){throw new LogicException('Kredi defteri kayıtları silinemez.');} }
