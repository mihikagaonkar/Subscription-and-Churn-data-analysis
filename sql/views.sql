SET search_path TO saas,public;

CREATE OR REPLACE VIEW months AS
SELECT generate_series(
  (SELECT date_trunc('month', MIN(signup_date)) FROM accounts),
  (SELECT date_trunc('month', COALESCE(MAX(end_date), CURRENT_DATE)) FROM subscriptions),
  interval '1 month'
)::date AS month_start;

CREATE OR REPLACE VIEW subscription_months AS
WITH spans AS (
  SELECT
    s.subscription_id,
    s.account_id,
    s.plan_tier,
    s.mrr_amount,
    s.start_date,
    COALESCE(s.end_date, CURRENT_DATE) AS end_date
  FROM subscriptions s
),
expanded AS (
  SELECT
    subscription_id, account_id, plan_tier, mrr_amount,
    date_trunc('month', gs)::date AS month_start
  FROM spans,
  LATERAL generate_series(start_date, end_date, interval '1 month') gs
)
SELECT * FROM expanded;

CREATE OR REPLACE VIEW revenue_mrr AS
SELECT
  month_start,
  SUM(mrr_amount) AS mrr,
  SUM(mrr_amount)*12 AS arr
FROM subscription_months
GROUP BY month_start
ORDER BY month_start;

CREATE OR REPLACE VIEW trial_to_subscription AS
WITH paid_any AS (
  SELECT account_id,
         MIN(start_date) AS first_paid_date
  FROM subscriptions
  WHERE is_trial = FALSE   
  GROUP BY account_id
)
SELECT
  date_trunc('month', u.signup_date)::date AS signup_month,
  COUNT(DISTINCT u.account_id) AS accounts_signed_up,
  COUNT(DISTINCT p.account_id) AS accounts_paid,
  (COUNT(DISTINCT p.account_id)::float / NULLIF(COUNT(DISTINCT u.account_id), 0)) AS trial_to_paid_rate
FROM accounts u
LEFT JOIN paid_any p USING (account_id)
GROUP BY 1
ORDER BY 1;

CREATE OR REPLACE VIEW cohorts AS
WITH first_seen AS (
  SELECT account_id, MIN(signup_date) AS cohort_start
  FROM accounts
  GROUP BY 1
),
active AS (
  SELECT DISTINCT account_id, month_start
  FROM subscription_months
)
SELECT
  date_trunc('month', f.cohort_start)::date AS cohort_month,
  a.month_start,
  EXTRACT(MONTH FROM age(a.month_start, date_trunc('month', f.cohort_start)))::int AS months_since_cohort,
  COUNT(DISTINCT a.account_id) AS active_accounts
FROM first_seen f
JOIN active a USING (account_id)
WHERE a.month_start >= date_trunc('month', f.cohort_start)
GROUP BY 1,2,3
ORDER BY 1,3;

CREATE OR REPLACE VIEW cohort_retention AS
WITH cohort_sizes AS (
  SELECT cohort_month, COUNT(DISTINCT account_id) AS cohort_size
  FROM (
    SELECT account_id, date_trunc('month', MIN(signup_date))::date AS cohort_month
    FROM accounts
    GROUP BY 1
  ) x
  GROUP BY 1
)
SELECT
  c.cohort_month,
  c.months_since_cohort,
  c.active_accounts,
  s.cohort_size,
  (c.active_accounts::float / NULLIF(s.cohort_size,0)) AS retention_rate
FROM cohorts c
JOIN cohort_sizes s USING (cohort_month)
ORDER BY c.cohort_month, c.months_since_cohort;

CREATE OR REPLACE VIEW account_mrr_month AS
SELECT account_id, month_start, SUM(mrr_amount) AS mrr
FROM subscription_months
GROUP BY 1,2;

CREATE OR REPLACE VIEW monthly_churn AS
WITH prev AS (
  SELECT account_id, month_start, mrr,
         (month_start + interval '1 month')::date AS next_month
  FROM account_mrr_month
  WHERE mrr > 0
),
next AS (
  SELECT account_id, month_start, mrr
  FROM account_mrr_month
)
SELECT
  p.month_start AS month,
  COUNT(*) FILTER (WHERE n.account_id IS NULL) AS churned_accounts,
  COUNT(*) AS accounts_last_month,
  (COUNT(*) FILTER (WHERE n.account_id IS NULL)::float / NULLIF(COUNT(*),0)) AS churn_rate
FROM prev p
LEFT JOIN next n
  ON n.account_id = p.account_id
 AND n.month_start = p.next_month
GROUP BY 1
ORDER BY 1;

CREATE OR REPLACE VIEW support_30d AS
SELECT
  a.account_id,
  date_trunc('month', t.submitted_at)::date AS month_start,
  COUNT(*) AS tickets_30d
FROM support_tickets t
JOIN (SELECT DISTINCT account_id FROM subscriptions) a USING (account_id)
GROUP BY 1,2;

CREATE OR REPLACE VIEW churn_vs_support AS
SELECT
  c.month,
  c.churn_rate,
  AVG(s.tickets_30d) AS avg_tickets_30d
FROM monthly_churn c
LEFT JOIN support_30d s
  ON s.month_start = c.month
GROUP BY 1,2
ORDER BY 1;
