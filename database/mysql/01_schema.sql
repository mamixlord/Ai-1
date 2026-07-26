-- Rekabet Insight / MySQL 8.0+ schema
-- Prefer `php artisan migrate --force`; this dump supports restricted cPanel installs.
SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET FOREIGN_KEY_CHECKS = 0;

CREATE TABLE users (
 id CHAR(36) PRIMARY KEY, name VARCHAR(255) NOT NULL, email VARCHAR(255) NOT NULL,
 email_verified_at TIMESTAMP NULL, password VARCHAR(255) NOT NULL,
 is_super_admin TINYINT(1) NOT NULL DEFAULT 0, two_factor_secret TEXT NULL,
 remember_token VARCHAR(100) NULL, created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL,
 deleted_at TIMESTAMP NULL, UNIQUE KEY users_email_unique (email)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE organizations (
 id CHAR(36) PRIMARY KEY, owner_id CHAR(36) NOT NULL, name VARCHAR(255) NOT NULL,
 slug VARCHAR(255) NOT NULL, created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL,
 deleted_at TIMESTAMP NULL, UNIQUE KEY organizations_slug_unique (slug),
 CONSTRAINT organizations_owner_fk FOREIGN KEY (owner_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE organization_user (
 organization_id CHAR(36) NOT NULL, user_id CHAR(36) NOT NULL, role VARCHAR(32) NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'active', created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL,
 PRIMARY KEY (organization_id,user_id), KEY organization_user_user_idx(user_id),
 CONSTRAINT organization_user_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,
 CONSTRAINT organization_user_user_fk FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE roles (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,name VARCHAR(255) NOT NULL,label VARCHAR(255) NOT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY roles_name_unique(name)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE permissions (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,name VARCHAR(255) NOT NULL,label VARCHAR(255) NOT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY permissions_name_unique(name)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE password_reset_tokens (email VARCHAR(255) PRIMARY KEY,token VARCHAR(255) NOT NULL,created_at TIMESTAMP NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE sessions (id VARCHAR(255) PRIMARY KEY,user_id CHAR(36) NULL,ip_address VARCHAR(45) NULL,user_agent TEXT NULL,payload LONGTEXT NOT NULL,last_activity INT NOT NULL,KEY sessions_user_idx(user_id),KEY sessions_activity_idx(last_activity)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (id CHAR(36) PRIMARY KEY,slug VARCHAR(64) NOT NULL,name VARCHAR(255) NOT NULL,active TINYINT(1) NOT NULL DEFAULT 1,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY products_slug_unique(slug)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE plans (id CHAR(36) PRIMARY KEY,product_id CHAR(36) NOT NULL,name VARCHAR(255) NOT NULL,level TINYINT UNSIGNED NOT NULL,price_minor BIGINT UNSIGNED NOT NULL,currency CHAR(3) NOT NULL DEFAULT 'TRY',visible TINYINT(1) NOT NULL DEFAULT 1,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY plans_product_level_unique(product_id,level),CONSTRAINT plans_product_fk FOREIGN KEY(product_id) REFERENCES products(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE plan_entitlements (id CHAR(36) PRIMARY KEY,plan_id CHAR(36) NOT NULL,`key` VARCHAR(100) NOT NULL,`value` JSON NOT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY entitlements_plan_key_unique(plan_id,`key`),CONSTRAINT entitlements_plan_fk FOREIGN KEY(plan_id) REFERENCES plans(id) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE projects (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,name VARCHAR(255) NOT NULL,company_name VARCHAR(255) NOT NULL,website_url VARCHAR(2048) NULL,industry VARCHAR(255) NULL,status VARCHAR(32) NOT NULL DEFAULT 'active',created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,deleted_at TIMESTAMP NULL,KEY projects_tenant_status_idx(organization_id,status),CONSTRAINT projects_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE competitors (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,project_id CHAR(36) NOT NULL,company_name VARCHAR(255) NOT NULL,domain VARCHAR(255) NULL,country CHAR(2) NULL,language VARCHAR(8) NULL,industry VARCHAR(255) NULL,description TEXT NULL,tags JSON NULL,notes TEXT NULL,status VARCHAR(32) NOT NULL DEFAULT 'active',last_analyzed_at TIMESTAMP NULL,last_successful_crawl_at TIMESTAMP NULL,last_error TEXT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,deleted_at TIMESTAMP NULL,KEY competitors_tenant_project_status_idx(organization_id,project_id,status),CONSTRAINT competitors_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT competitors_project_fk FOREIGN KEY(project_id) REFERENCES projects(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE competitor_sources (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,competitor_id CHAR(36) NOT NULL,platform VARCHAR(32) NOT NULL,external_id VARCHAR(255) NULL,url VARCHAR(2048) NOT NULL,active TINYINT(1) NOT NULL DEFAULT 1,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY sources_competitor_platform_url(competitor_id,platform,url(255)),KEY sources_tenant_platform_idx(organization_id,platform),CONSTRAINT sources_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT sources_competitor_fk FOREIGN KEY(competitor_id) REFERENCES competitors(id) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE subscriptions (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,product_id CHAR(36) NOT NULL,plan_id CHAR(36) NOT NULL,status VARCHAR(32) NOT NULL,billing_period VARCHAR(20) NOT NULL,starts_at TIMESTAMP NOT NULL,ends_at TIMESTAMP NULL,next_payment_at TIMESTAMP NULL,cancelled_at TIMESTAMP NULL,auto_renew TINYINT(1) NOT NULL DEFAULT 1,price_snapshot_minor BIGINT UNSIGNED NOT NULL,limits_snapshot JSON NOT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,KEY subscriptions_tenant_product_status_idx(organization_id,product_id,status),CONSTRAINT subscriptions_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT subscriptions_product_fk FOREIGN KEY(product_id) REFERENCES products(id),CONSTRAINT subscriptions_plan_fk FOREIGN KEY(plan_id) REFERENCES plans(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE subscription_items (id CHAR(36) PRIMARY KEY,subscription_id CHAR(36) NOT NULL,provider_item_id VARCHAR(255) NULL,quantity INT UNSIGNED NOT NULL DEFAULT 1,metadata JSON NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,CONSTRAINT subscription_items_subscription_fk FOREIGN KEY(subscription_id) REFERENCES subscriptions(id) ON DELETE CASCADE) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE billing_cycles (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,subscription_id CHAR(36) NOT NULL,starts_at TIMESTAMP NOT NULL,ends_at TIMESTAMP NOT NULL,status VARCHAR(32) NOT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY billing_subscription_start_unique(subscription_id,starts_at),CONSTRAINT billing_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT billing_subscription_fk FOREIGN KEY(subscription_id) REFERENCES subscriptions(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE payments (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,subscription_id CHAR(36) NULL,provider VARCHAR(32) NOT NULL,provider_id VARCHAR(255) NOT NULL,amount_minor BIGINT UNSIGNED NOT NULL,currency CHAR(3) NOT NULL,status VARCHAR(32) NOT NULL,metadata JSON NULL,paid_at TIMESTAMP NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY payments_provider_id_unique(provider_id),KEY payments_tenant_status_idx(organization_id,status),CONSTRAINT payments_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT payments_subscription_fk FOREIGN KEY(subscription_id) REFERENCES subscriptions(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE payment_webhooks (id CHAR(36) PRIMARY KEY,provider VARCHAR(32) NOT NULL,event_id VARCHAR(255) NOT NULL,type VARCHAR(100) NOT NULL,payload JSON NOT NULL,processed_at TIMESTAMP NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY webhooks_provider_event_unique(provider,event_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE refunds (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,payment_id CHAR(36) NOT NULL,provider_id VARCHAR(255) NULL,amount_minor BIGINT UNSIGNED NOT NULL,status VARCHAR(32) NOT NULL,reason TEXT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,CONSTRAINT refunds_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT refunds_payment_fk FOREIGN KEY(payment_id) REFERENCES payments(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE topup_products (id CHAR(36) PRIMARY KEY,product_id CHAR(36) NULL,credit_type VARCHAR(32) NOT NULL,credits DECIMAL(16,4) NOT NULL,price_minor BIGINT UNSIGNED NOT NULL,expires_months SMALLINT UNSIGNED NULL,active TINYINT(1) NOT NULL DEFAULT 1,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,CONSTRAINT topup_products_product_fk FOREIGN KEY(product_id) REFERENCES products(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE topup_purchases (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,topup_product_id CHAR(36) NOT NULL,payment_id CHAR(36) NULL,status VARCHAR(32) NOT NULL,credited_at TIMESTAMP NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,CONSTRAINT topup_purchases_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT topup_purchases_product_fk FOREIGN KEY(topup_product_id) REFERENCES topup_products(id),CONSTRAINT topup_purchases_payment_fk FOREIGN KEY(payment_id) REFERENCES payments(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE credit_wallets (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,product_id CHAR(36) NULL,credit_type VARCHAR(32) NOT NULL,subscription_balance DECIMAL(16,4) NOT NULL DEFAULT 0,promotion_balance DECIMAL(16,4) NOT NULL DEFAULT 0,purchased_balance DECIMAL(16,4) NOT NULL DEFAULT 0,reserved_balance DECIMAL(16,4) NOT NULL DEFAULT 0,available_balance DECIMAL(16,4) AS (subscription_balance+promotion_balance+purchased_balance-reserved_balance) STORED,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY wallets_tenant_product_type_unique(organization_id,product_id,credit_type),CONSTRAINT wallets_nonnegative CHECK(subscription_balance>=0 AND promotion_balance>=0 AND purchased_balance>=0 AND reserved_balance>=0 AND reserved_balance<=subscription_balance+promotion_balance+purchased_balance),CONSTRAINT wallets_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT wallets_product_fk FOREIGN KEY(product_id) REFERENCES products(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE credit_ledger (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,user_id CHAR(36) NULL,wallet_id CHAR(36) NOT NULL,product_id CHAR(36) NULL,credit_type VARCHAR(32) NOT NULL,transaction_type VARCHAR(32) NOT NULL,amount DECIMAL(16,4) NOT NULL,previous_balance DECIMAL(16,4) NOT NULL,next_balance DECIMAL(16,4) NOT NULL,reference_type VARCHAR(255) NULL,reference_id CHAR(36) NULL,idempotency_key VARCHAR(255) NOT NULL,description TEXT NOT NULL,occurred_at TIMESTAMP NOT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY ledger_idempotency_unique(idempotency_key),KEY ledger_tenant_type_date_idx(organization_id,credit_type,occurred_at),KEY ledger_reference_idx(reference_type,reference_id),CONSTRAINT ledger_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE RESTRICT,CONSTRAINT ledger_user_fk FOREIGN KEY(user_id) REFERENCES users(id) ON DELETE SET NULL,CONSTRAINT ledger_wallet_fk FOREIGN KEY(wallet_id) REFERENCES credit_wallets(id) ON DELETE RESTRICT,CONSTRAINT ledger_product_fk FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE RESTRICT) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE credit_reservations (id CHAR(36) PRIMARY KEY,organization_id CHAR(36) NOT NULL,wallet_id CHAR(36) NOT NULL,estimated_amount DECIMAL(16,4) NOT NULL,actual_amount DECIMAL(16,4) NULL,status VARCHAR(32) NOT NULL,idempotency_key VARCHAR(255) NOT NULL,expires_at TIMESTAMP NOT NULL,created_at TIMESTAMP NULL,updated_at TIMESTAMP NULL,UNIQUE KEY reservations_idempotency_unique(idempotency_key),KEY reservations_tenant_status_expiry_idx(organization_id,status,expires_at),CONSTRAINT reservations_amounts CHECK(estimated_amount>0 AND (actual_amount IS NULL OR actual_amount>=0)),CONSTRAINT reservations_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE,CONSTRAINT reservations_wallet_fk FOREIGN KEY(wallet_id) REFERENCES credit_wallets(id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Analysis tables share an indexed tenant envelope. JSON holds provider-specific payloads;
-- normalized query fields are indexed independently in the dedicated content tables below.
CREATE TABLE usage_events (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY usage_events_tenant_status_created_idx(organization_id,status,created_at),
 KEY usage_events_project_idx(project_id), KEY usage_events_competitor_idx(competitor_id),
 CONSTRAINT usage_events_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE integration_settings (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY integration_settings_tenant_status_created_idx(organization_id,status,created_at),
 KEY integration_settings_project_idx(project_id), KEY integration_settings_competitor_idx(competitor_id),
 CONSTRAINT integration_settings_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE apify_actors (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY apify_actors_tenant_status_created_idx(organization_id,status,created_at),
 KEY apify_actors_project_idx(project_id), KEY apify_actors_competitor_idx(competitor_id),
 CONSTRAINT apify_actors_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE apify_runs (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY apify_runs_tenant_status_created_idx(organization_id,status,created_at),
 KEY apify_runs_project_idx(project_id), KEY apify_runs_competitor_idx(competitor_id),
 CONSTRAINT apify_runs_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE analysis_jobs (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY analysis_jobs_tenant_status_created_idx(organization_id,status,created_at),
 KEY analysis_jobs_project_idx(project_id), KEY analysis_jobs_competitor_idx(competitor_id),
 CONSTRAINT analysis_jobs_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE website_pages (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY website_pages_tenant_status_created_idx(organization_id,status,created_at),
 KEY website_pages_project_idx(project_id), KEY website_pages_competitor_idx(competitor_id),
 CONSTRAINT website_pages_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE website_snapshots (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY website_snapshots_tenant_status_created_idx(organization_id,status,created_at),
 KEY website_snapshots_project_idx(project_id), KEY website_snapshots_competitor_idx(competitor_id),
 CONSTRAINT website_snapshots_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE website_changes (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY website_changes_tenant_status_created_idx(organization_id,status,created_at),
 KEY website_changes_project_idx(project_id), KEY website_changes_competitor_idx(competitor_id),
 CONSTRAINT website_changes_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE social_profiles (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY social_profiles_tenant_status_created_idx(organization_id,status,created_at),
 KEY social_profiles_project_idx(project_id), KEY social_profiles_competitor_idx(competitor_id),
 CONSTRAINT social_profiles_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE social_contents (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY social_contents_tenant_status_created_idx(organization_id,status,created_at),
 KEY social_contents_project_idx(project_id), KEY social_contents_competitor_idx(competitor_id),
 CONSTRAINT social_contents_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE social_content_metrics (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY social_content_metrics_tenant_status_created_idx(organization_id,status,created_at),
 KEY social_content_metrics_project_idx(project_id), KEY social_content_metrics_competitor_idx(competitor_id),
 CONSTRAINT social_content_metrics_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE social_comments (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY social_comments_tenant_status_created_idx(organization_id,status,created_at),
 KEY social_comments_project_idx(project_id), KEY social_comments_competitor_idx(competitor_id),
 CONSTRAINT social_comments_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE metric_summaries (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY metric_summaries_tenant_status_created_idx(organization_id,status,created_at),
 KEY metric_summaries_project_idx(project_id), KEY metric_summaries_competitor_idx(competitor_id),
 CONSTRAINT metric_summaries_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE ai_providers (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY ai_providers_tenant_status_created_idx(organization_id,status,created_at),
 KEY ai_providers_project_idx(project_id), KEY ai_providers_competitor_idx(competitor_id),
 CONSTRAINT ai_providers_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE ai_models (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY ai_models_tenant_status_created_idx(organization_id,status,created_at),
 KEY ai_models_project_idx(project_id), KEY ai_models_competitor_idx(competitor_id),
 CONSTRAINT ai_models_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE ai_usage_records (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY ai_usage_records_tenant_status_created_idx(organization_id,status,created_at),
 KEY ai_usage_records_project_idx(project_id), KEY ai_usage_records_competitor_idx(competitor_id),
 CONSTRAINT ai_usage_records_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE ai_analyses (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY ai_analyses_tenant_status_created_idx(organization_id,status,created_at),
 KEY ai_analyses_project_idx(project_id), KEY ai_analyses_competitor_idx(competitor_id),
 CONSTRAINT ai_analyses_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE evidence_sources (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY evidence_sources_tenant_status_created_idx(organization_id,status,created_at),
 KEY evidence_sources_project_idx(project_id), KEY evidence_sources_competitor_idx(competitor_id),
 CONSTRAINT evidence_sources_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE recommendations (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY recommendations_tenant_status_created_idx(organization_id,status,created_at),
 KEY recommendations_project_idx(project_id), KEY recommendations_competitor_idx(competitor_id),
 CONSTRAINT recommendations_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE reports (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY reports_tenant_status_created_idx(organization_id,status,created_at),
 KEY reports_project_idx(project_id), KEY reports_competitor_idx(competitor_id),
 CONSTRAINT reports_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE alerts (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY alerts_tenant_status_created_idx(organization_id,status,created_at),
 KEY alerts_project_idx(project_id), KEY alerts_competitor_idx(competitor_id),
 CONSTRAINT alerts_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE notifications (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY notifications_tenant_status_created_idx(organization_id,status,created_at),
 KEY notifications_project_idx(project_id), KEY notifications_competitor_idx(competitor_id),
 CONSTRAINT notifications_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE audit_logs (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY audit_logs_tenant_status_created_idx(organization_id,status,created_at),
 KEY audit_logs_project_idx(project_id), KEY audit_logs_competitor_idx(competitor_id),
 CONSTRAINT audit_logs_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE security_events (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY security_events_tenant_status_created_idx(organization_id,status,created_at),
 KEY security_events_project_idx(project_id), KEY security_events_competitor_idx(competitor_id),
 CONSTRAINT security_events_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE system_settings (
 id CHAR(36) PRIMARY KEY, organization_id CHAR(36) NOT NULL, type VARCHAR(100) NULL,
 status VARCHAR(32) NULL, external_id VARCHAR(255) NULL, project_id CHAR(36) NULL,
 competitor_id CHAR(36) NULL, data JSON NULL, content LONGTEXT NULL, occurred_at TIMESTAMP NULL,
 created_at TIMESTAMP NULL, updated_at TIMESTAMP NULL, deleted_at TIMESTAMP NULL,
 KEY system_settings_tenant_status_created_idx(organization_id,status,created_at),
 KEY system_settings_project_idx(project_id), KEY system_settings_competitor_idx(competitor_id),
 CONSTRAINT system_settings_org_fk FOREIGN KEY(organization_id) REFERENCES organizations(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE jobs (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,queue VARCHAR(255) NOT NULL,payload LONGTEXT NOT NULL,attempts TINYINT UNSIGNED NOT NULL,reserved_at INT UNSIGNED NULL,available_at INT UNSIGNED NOT NULL,created_at INT UNSIGNED NOT NULL,KEY jobs_queue_idx(queue)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE job_batches (id VARCHAR(255) PRIMARY KEY,name VARCHAR(255) NOT NULL,total_jobs INT NOT NULL,pending_jobs INT NOT NULL,failed_jobs INT NOT NULL,failed_job_ids LONGTEXT NOT NULL,options MEDIUMTEXT NULL,cancelled_at INT NULL,created_at INT NOT NULL,finished_at INT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE failed_jobs (id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,uuid VARCHAR(255) NOT NULL,connection TEXT NOT NULL,queue TEXT NOT NULL,payload LONGTEXT NOT NULL,exception LONGTEXT NOT NULL,failed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,UNIQUE KEY failed_jobs_uuid_unique(uuid)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE cache (`key` VARCHAR(255) PRIMARY KEY,`value` MEDIUMTEXT NOT NULL,expiration INT NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE cache_locks (`key` VARCHAR(255) PRIMARY KEY,owner VARCHAR(255) NOT NULL,expiration INT NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

DELIMITER $$
CREATE TRIGGER credit_ledger_block_update BEFORE UPDATE ON credit_ledger
FOR EACH ROW BEGIN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='credit_ledger is append-only'; END$$
CREATE TRIGGER credit_ledger_block_delete BEFORE DELETE ON credit_ledger
FOR EACH ROW BEGIN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT='credit_ledger is append-only'; END$$
DELIMITER ;

SET FOREIGN_KEY_CHECKS = 1;
