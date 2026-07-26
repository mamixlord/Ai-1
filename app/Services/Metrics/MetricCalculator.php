<?php
namespace App\Services\Metrics;
final class MetricCalculator
{
 public function mean(array $values): float { $v=$this->numbers($values); return $v === [] ? 0.0 : array_sum($v)/count($v); }
 public function median(array $values): float { $v=$this->numbers($values); if($v===[]) return 0.0; sort($v,SORT_NUMERIC); $m=intdiv(count($v),2); return count($v)%2 ? $v[$m] : ($v[$m-1]+$v[$m])/2; }
 public function standardDeviation(array $values): float { $v=$this->numbers($values); if($v===[]) return 0.0; $mean=$this->mean($v); return sqrt(array_sum(array_map(fn($x)=>($x-$mean)**2,$v))/count($v)); }
 public function engagementRate(int|float $interactions, int|float $audience): float { return $audience <= 0 ? 0.0 : round(($interactions/$audience)*100,4); }
 public function growthRate(int|float $before, int|float $after): float { return $before == 0 ? 0.0 : round((($after-$before)/abs($before))*100,4); }
 private function numbers(array $values): array { return array_values(array_map('floatval',array_filter($values,'is_numeric'))); }
}
