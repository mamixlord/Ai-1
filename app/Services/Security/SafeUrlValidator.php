<?php
namespace App\Services\Security;
use InvalidArgumentException;
final class SafeUrlValidator
{
 private const PORTS=[80,443];
 public function validate(string $url, ?callable $resolver=null): string
 {
  $parts=parse_url($url); $scheme=strtolower((string)($parts['scheme']??''));
  if(!in_array($scheme,['http','https'],true)||empty($parts['host'])) throw new InvalidArgumentException('Yalnızca geçerli HTTP/HTTPS adresleri desteklenir.');
  if(isset($parts['user'])||isset($parts['pass'])) throw new InvalidArgumentException('URL kimlik bilgisi içeremez.');
  $port=(int)($parts['port']??($scheme==='https'?443:80)); if(!in_array($port,self::PORTS,true)) throw new InvalidArgumentException('Port kullanımına izin verilmiyor.');
  $host=rtrim(strtolower($parts['host']),'.'); if($host==='localhost'||str_ends_with($host,'.localhost')) throw new InvalidArgumentException('Yerel adres engellendi.');
  $ips=filter_var($host,FILTER_VALIDATE_IP)?[$host]:($resolver?($resolver)($host):gethostbynamel($host));
  if(!$ips) throw new InvalidArgumentException('Alan adı çözümlenemedi.');
  foreach($ips as $ip) if(!filter_var($ip,FILTER_VALIDATE_IP,FILTER_FLAG_NO_PRIV_RANGE|FILTER_FLAG_NO_RES_RANGE)) throw new InvalidArgumentException('Özel veya ayrılmış ağ adresi engellendi.');
  return $url;
 }
}
