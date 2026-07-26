<?php

namespace Tests\Unit;

use App\Services\AI\StructuredOutputValidator;
use PHPUnit\Framework\TestCase;
use RuntimeException;

final class StructuredOutputValidatorTest extends TestCase
{
    public function test_it_accepts_nested_schema_compatible_output(): void
    {
        $schema = [
            'type' => 'object',
            'required' => ['summary', 'actions'],
            'properties' => [
                'summary' => ['type' => 'string'],
                'actions' => [
                    'type' => 'array',
                    'items' => [
                        'type' => 'object',
                        'required' => ['title'],
                        'properties' => ['title' => ['type' => 'string']],
                    ],
                ],
            ],
        ];

        (new StructuredOutputValidator())->validate([
            'summary' => 'Özet',
            'actions' => [['title' => 'Öneri']],
        ], $schema);

        self::assertTrue(true);
    }

    public function test_it_rejects_missing_required_fields(): void
    {
        $this->expectException(RuntimeException::class);

        (new StructuredOutputValidator())->validate([], [
            'type' => 'object',
            'required' => ['summary'],
        ]);
    }
}
