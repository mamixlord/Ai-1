<?php
use Illuminate\Support\Facades\Route;
Route::view('/','welcome')->name('home');
Route::view('/gizlilik','legal.privacy')->name('privacy');
Route::view('/kullanim-kosullari','legal.terms')->name('terms');
Route::middleware(['auth','verified'])->group(function(){Route::view('/dashboard','dashboard')->name('dashboard');Route::view('/projeler','projects.index')->name('projects.index');Route::view('/rakipler','competitors.index')->name('competitors.index');Route::view('/krediler','credits.index')->name('credits.index');Route::view('/raporlar','reports.index')->name('reports.index');});
