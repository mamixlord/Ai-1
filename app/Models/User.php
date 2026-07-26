<?php
namespace App\Models;
use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Concerns\HasUuids;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
final class User extends Authenticatable implements MustVerifyEmail { use HasFactory,HasUuids,Notifiable; protected $fillable=['name','email','password','email_verified_at','is_super_admin']; protected $hidden=['password','remember_token','two_factor_secret']; protected function casts():array{return ['email_verified_at'=>'datetime','password'=>'hashed','is_super_admin'=>'boolean','two_factor_secret'=>'encrypted'];} public function organizations(){return $this->belongsToMany(Organization::class)->withPivot(['role','status'])->withTimestamps();} }
