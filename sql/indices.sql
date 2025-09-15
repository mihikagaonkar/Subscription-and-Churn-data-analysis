SET search_path TO saas,public;

CREATE INDEX idx_accounts_country ON accounts(country);
CREATE INDEX idx_accounts_signup_date ON accounts(signup_date);
CREATE INDEX idx_accounts_plan_tier ON accounts(plan_tier);

CREATE INDEX idx_subscriptions_account_id ON subscriptions(account_id);
CREATE INDEX idx_subscriptions_start_date ON subscriptions(start_date);
CREATE INDEX idx_subscriptions_end_date ON subscriptions(end_date);
CREATE INDEX idx_subscriptions_plan_tier ON subscriptions(plan_tier);
CREATE INDEX idx_subscriptions_billing_freq ON subscriptions(billing_frequency);
CREATE INDEX idx_subscriptions_churn_flag ON subscriptions(churn_flag);

CREATE INDEX idx_events_account_id ON events(account_id);
CREATE INDEX idx_events_churn_date ON events(churn_date);
CREATE INDEX idx_events_reason_code ON events(reason_code);

CREATE INDEX idx_tickets_account_id ON support_tickets(account_id);
CREATE INDEX idx_tickets_submitted_at ON support_tickets(submitted_at);
CREATE INDEX idx_tickets_priority ON support_tickets(priority);
CREATE INDEX idx_tickets_escalation_flag ON support_tickets(escalation_flag);

CREATE INDEX idx_feature_usage_subscription_id ON feature_usage(subscription_id);
CREATE INDEX idx_feature_usage_usage_date ON feature_usage(usage_date);
CREATE INDEX idx_feature_usage_feature_name ON feature_usage(feature_name);
CREATE INDEX idx_feature_usage_is_beta_feature ON feature_usage(is_beta_feature);

CREATE INDEX idx_subscriptions_account_start 
    ON subscriptions(account_id, start_date);

CREATE INDEX idx_events_account_churn 
    ON events(account_id, churn_date);

CREATE INDEX idx_tickets_account_priority 
    ON support_tickets(account_id, priority);

CREATE INDEX idx_feature_usage_subs_feature 
    ON feature_usage(subscription_id, feature_name);
