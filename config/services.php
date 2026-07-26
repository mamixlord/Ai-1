<?php
return ['apify'=>['token'=>env('APIFY_TOKEN'),'webhook_secret'=>env('APIFY_WEBHOOK_SECRET')],'youtube'=>['key'=>env('YOUTUBE_API_KEY')],'gemini'=>['key'=>env('GEMINI_API_KEY')],'openai'=>['key'=>env('OPENAI_API_KEY')],'stripe'=>['key'=>env('STRIPE_KEY'),'secret'=>env('STRIPE_SECRET'),'webhook_secret'=>env('STRIPE_WEBHOOK_SECRET')]];
