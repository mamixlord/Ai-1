<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
final class Organization extends Model { use HasUuids,SoftDeletes; protected $fillable=['name','slug','owner_id']; public function users(){return $this->belongsToMany(User::class)->withPivot(['role','status'])->withTimestamps();} }
