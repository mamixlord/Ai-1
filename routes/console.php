<?php
use Illuminate\Support\Facades\Schedule;
Schedule::command('queue:work --stop-when-empty --max-time=50')->everyMinute()->withoutOverlapping();
Schedule::command('model:prune')->daily();
