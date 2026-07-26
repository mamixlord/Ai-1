<?php
namespace Tests\Unit;
use App\Services\Security\SafeUrlValidator;use InvalidArgumentException;use PHPUnit\Framework\TestCase;
final class SafeUrlValidatorTest extends TestCase{public function test_public_url_is_accepted():void{self::assertSame('https://example.com/x',(new SafeUrlValidator())->validate('https://example.com/x',fn()=>['93.184.216.34']));}public function test_private_and_unsafe_targets_are_blocked():void{$this->expectException(InvalidArgumentException::class);(new SafeUrlValidator())->validate('http://metadata.test',fn()=>['169.254.169.254']);}}
