<?php
namespace App\Models;
use Illuminate\Database\Eloquent\Concerns\HasUuids; use Illuminate\Database\Eloquent\Model; use Illuminate\Database\Eloquent\SoftDeletes;
final class Project extends Model { use HasUuids,SoftDeletes; protected $fillable=['organization_id','name','company_name','website_url','industry','status']; }
