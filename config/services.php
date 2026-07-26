<?php

return [
    'ai' => [
        'default_provider' => env('AI_DEFAULT_PROVIDER', 'gemini'),
    ],
    'apify' => [
        'token' => env('APIFY_TOKEN'),
        'webhook_secret' => env('APIFY_WEBHOOK_SECRET'),
    ],
    'youtube' => ['key' => env('YOUTUBE_API_KEY')],
    'gemini' => ['key' => env('GEMINI_API_KEY')],
    'openai' => ['key' => env('OPENAI_API_KEY')],
    'nvidia_nim' => [
        'api_key' => env('NVIDIA_NIM_API_KEY'),
        'base_url' => env('NVIDIA_NIM_BASE_URL', 'https://integrate.api.nvidia.com/v1'),
        'model' => env('NVIDIA_NIM_MODEL', 'meta/llama-3.3-70b-instruct'),
    ],
    'stripe' => [
        'key' => env('STRIPE_KEY'),
        'secret' => env('STRIPE_SECRET'),
        'webhook_secret' => env('STRIPE_WEBHOOK_SECRET'),
    ],
];
