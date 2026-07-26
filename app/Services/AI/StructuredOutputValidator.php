<?php

namespace App\Services\AI;

use RuntimeException;

final class StructuredOutputValidator
{
    public function validate(array $value, array $schema, string $path = '$'): void
    {
        foreach ($schema['required'] ?? [] as $required) {
            if (! array_key_exists($required, $value)) {
                throw new RuntimeException("AI yanıtında zorunlu alan eksik: {$path}.{$required}");
            }
        }

        foreach ($schema['properties'] ?? [] as $name => $property) {
            if (! array_key_exists($name, $value)) {
                continue;
            }

            $this->validateType($value[$name], $property, "{$path}.{$name}");
        }
    }

    private function validateType(mixed $value, array $schema, string $path): void
    {
        $valid = match ($schema['type'] ?? null) {
            'object' => is_array($value) && ! array_is_list($value),
            'array' => is_array($value) && array_is_list($value),
            'string' => is_string($value),
            'integer' => is_int($value),
            'number' => is_int($value) || is_float($value),
            'boolean' => is_bool($value),
            'null' => $value === null,
            null => true,
            default => false,
        };

        if (! $valid) {
            throw new RuntimeException("AI yanıt alanı şemayla uyumsuz: {$path}");
        }

        if (($schema['type'] ?? null) === 'object') {
            $this->validate($value, $schema, $path);
        }

        if (($schema['type'] ?? null) === 'array' && isset($schema['items'])) {
            foreach ($value as $index => $item) {
                $this->validateType($item, $schema['items'], "{$path}[{$index}]");
            }
        }
    }
}
