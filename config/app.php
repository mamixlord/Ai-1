<?php
return ['name'=>env('APP_NAME','Rekabet Insight'),'env'=>env('APP_ENV','production'),'debug'=>(bool)env('APP_DEBUG',false),'url'=>env('APP_URL','http://localhost'),'timezone'=>'UTC','locale'=>'tr','fallback_locale'=>'tr','key'=>env('APP_KEY'),'cipher'=>'AES-256-CBC','providers'=>[App\Providers\AppServiceProvider::class]];
