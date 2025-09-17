# SaaS Subscription & Churn Analytics Dashboard

This project demonstrates how to process SaaS subscription data in PostgreSQL and build an executive-level analytics dashboard in Tableau.  
The goal is to track key SaaS growth metrics (ARR, MRR, Activation, Retention, Churn) and generate actionable insights for product, growth, and customer success teams.

---

## 🔧 Data Processing (PostgreSQL)

The project uses the [Rivalytics SaaS Subscription & Churn dataset](https://www.kaggle.com/datasets/rivalytics/saas-subscription-and-churn-analytics-dataset), loaded into PostgreSQL.

### Steps:
1. **Data Loading**  
   - CSVs imported into PostgreSQL tables: `accounts`, `subscriptions`, `events`, `support_tickets` and `feature_usage`.  
   - Created indexes on dates and account IDs for performance.  

2. **Data Modeling**  
   - **`subscription_months`**: expanded each subscription into active months using `generate_series()`.  
   - **`revenue_mrr`**: aggregated MRR and ARR per month.  
   - **`trial_to_paid`**: tracked conversion from free/trial accounts into paid accounts.  
   - **`cohort_retention`**: calculated retention rates by signup cohort over time.  
   - **`monthly_churn`**: computed churn rates by comparing active accounts across consecutive months.  
   - **`churn_vs_support`**: linked churn trends with customer support ticket volume.  

3. **Business Logic**  
   - ARR = 12 × MRR.  
   - Activation defined as users who converted from trial/free to paid.  
   - Retention rate = percentage of a cohort’s accounts still active after N months.  
   - Churn excluded for the latest month since no future data exists.  


---

## 📊 Tableau Dashboard

The Tableau dashboard connects to these views and presents key SaaS metrics:

### 1. **KPI Cards**
- **MRR** (Monthly Recurring Revenue)  
- **ARR** (Annual Recurring Revenue)  
- **Activation Rate** (Trial → Paid conversion %)  
- **Churn Rate** (Customer churn %)  

### 2. **MRR Trend**
- Line chart showing revenue growth over time.  
- Highlights seasonal patterns, growth trajectory, and revenue sustainability.  



### 3. **Cohort Retention Heatmap**
- Rows = signup cohorts by month.  
- Columns = months since signup.  
- Cells = % of accounts still active.  
- Reveals how retention changes over time and which cohorts are stickier.  

### 4. **Monthly Churn Trend**
- Line chart showing monthly churn rates.  
- Includes reference line for average churn.  
- Last month excluded since churn cannot be computed reliably.  

### 5. **Support vs. Churn**
- Dual-axis chart comparing churn rate with average support tickets.  
- Highlights correlation between customer issues and higher churn.  

---

## 🚀 Insights & Applications
This workflow mirrors real SaaS analytics practices:
- **Growth**: Identify acquisition channels with highest conversion.  
- **Product**: Detect retention drop-off points to improve onboarding.  
- **Customer Success**: Spot support-heavy accounts with higher churn risk.  

The project demonstrates end-to-end skills in:
- **SQL (PostgreSQL)**: data cleaning, modeling, cohort analysis.  
- **BI (Tableau)**: interactive dashboards for SaaS KPIs.  
- **Data Storytelling**: turning raw data into actionable insights.  

---

