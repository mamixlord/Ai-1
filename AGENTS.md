# Repository guidance

- Target PHP 8.3+ and Laravel 13; follow PSR-12 and keep controllers thin.
- Tenant-owned records must carry `organization_id` and be authorized before use.
- Financial ledger entries are append-only; corrections are compensating entries.
- External integrations belong behind contracts and must never log secrets.
- Add tests for domain invariants and security boundaries with every feature.
- Keep the application compatible with database queues and cPanel cron execution.

