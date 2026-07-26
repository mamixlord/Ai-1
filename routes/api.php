<?php
use Illuminate\Support\Facades\Route;
Route::middleware(['auth:sanctum','throttle:analysis'])->get('/me',fn($request)=>$request->user());
