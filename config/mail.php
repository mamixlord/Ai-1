<?php
return ['default'=>env('MAIL_MAILER','smtp'),'mailers'=>['smtp'=>['transport'=>'smtp','scheme'=>env('MAIL_SCHEME'),'url'=>env('MAIL_URL'),'host'=>env('MAIL_HOST'),'port'=>env('MAIL_PORT',587),'username'=>env('MAIL_USERNAME'),'password'=>env('MAIL_PASSWORD'),'timeout'=>null]],'from'=>['address'=>env('MAIL_FROM_ADDRESS','noreply@example.com'),'name'=>env('MAIL_FROM_NAME','Rekabet Insight')]];
