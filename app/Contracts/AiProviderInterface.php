<?php
namespace App\Contracts;
interface AiProviderInterface { public function structured(array $messages, array $schema, array $options = []): array; }
