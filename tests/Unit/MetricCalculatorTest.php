<?php
namespace Tests\Unit;
use App\Services\Metrics\MetricCalculator;use PHPUnit\Framework\TestCase;
final class MetricCalculatorTest extends TestCase{public function test_metrics_are_deterministic_and_zero_safe():void{$m=new MetricCalculator();self::assertSame(0.0,$m->engagementRate(10,0));self::assertSame(25.0,$m->engagementRate(25,100));self::assertSame(2.5,$m->median([4,1,3,2]));self::assertSame(2.0,$m->mean([1,2,3]));self::assertSame(50.0,$m->growthRate(100,150));}}
