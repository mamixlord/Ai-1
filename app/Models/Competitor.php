<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Concerns\HasUuids; use Illuminate\Database\Eloquent\Model; use Illuminate\Database\Eloquent\SoftDeletes;
final class Competitor extends Model { use HasUuids,SoftDeletes; protected $guarded=[]; protected function casts():array{return ['tags'=>'array','last_analyzed_at'=>'datetime'];} }
