SET search_path TO saas,public;

CREATE TABLE accounts (
    account_id       VARCHAR(50) PRIMARY KEY,
    account_name     TEXT,
    industry         TEXT,
    country          TEXT,
    signup_date      DATE,
    referral_source  TEXT,
    plan_tier        TEXT,
    seats            INT,
    is_trial         BOOLEAN,
    churn_flag       BOOLEAN
);


CREATE TABLE subscriptions (
    subscription_id     VARCHAR(50) PRIMARY KEY,  
    account_id          VARCHAR(50) NOT NULL,     
    start_date          DATE NOT NULL,
    end_date            DATE,
    plan_tier           TEXT,                     
    seats               INT,
    mrr_amount          NUMERIC(12,2),            
    arr_amount          NUMERIC(12,2),            
    is_trial            BOOLEAN,
    upgrade_flag        BOOLEAN,                  
    downgrade_flag      BOOLEAN,                  
    churn_flag          BOOLEAN,                  
    billing_frequency   TEXT,                     
    auto_renew_flag     BOOLEAN,
    
    CONSTRAINT fk_account FOREIGN KEY (account_id)
        REFERENCES accounts(account_id)
);


CREATE TABLE events (
    churn_event_id           VARCHAR(50) PRIMARY KEY,  
    account_id               VARCHAR(50) NOT NULL,     
    churn_date               DATE NOT NULL,            
    reason_code              TEXT,                     
    refund_amount_usd        NUMERIC(12,2),            
    preceding_upgrade_flag   BOOLEAN,                  
    preceding_downgrade_flag BOOLEAN,                  
    is_reactivation          BOOLEAN,                  
    feedback_text            TEXT,                     
    
    CONSTRAINT fk_account FOREIGN KEY (account_id) 
        REFERENCES accounts(account_id)
);


CREATE TABLE support_tickets (
    ticket_id                   VARCHAR(50) PRIMARY KEY,  
    account_id                  VARCHAR(50) NOT NULL,     
    submitted_at                TIMESTAMP NOT NULL,       
    closed_at                   TIMESTAMP,                
    resolution_time_hours       NUMERIC(6,2),             
    priority                    TEXT,                     
    first_response_time_minutes NUMERIC(6,2),             
    satisfaction_score          INT,                      
    escalation_flag             BOOLEAN,                  
    
    CONSTRAINT fk_account FOREIGN KEY (account_id) 
        REFERENCES accounts(account_id)
);

CREATE TABLE feature_usage (
    usage_id            VARCHAR(50) PRIMARY KEY,  
    subscription_id     VARCHAR(50) NOT NULL,     
    usage_date          DATE NOT NULL,            
    feature_name        TEXT NOT NULL,            
    usage_count         INT,                      
    usage_duration_secs NUMERIC(12,2),            
    error_count         INT,                      
    is_beta_feature     BOOLEAN,                  
    
    CONSTRAINT fk_subscription FOREIGN KEY (subscription_id) 
        REFERENCES subscriptions(subscription_id)
);
