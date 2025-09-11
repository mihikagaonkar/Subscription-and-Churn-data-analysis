\copy saas.accounts              FROM 'data/ravenstack_accounts.csv'              WITH (FORMAT csv, HEADER true);
\copy saas.subscriptions      FROM 'data/ravenstack_subscriptions.csv'      WITH (FORMAT csv, HEADER true);
\copy saas.events             FROM 'data/ravenstack_churn_events.csv'             WITH (FORMAT csv, HEADER true);
\copy saas.support_tickets    FROM 'data/ravenstack_support_tickets.csv'    WITH (FORMAT csv, HEADER true);
\copy saas.feature_usage    FROM 'data/ravenstackfeature_usage.csv'    WITH (FORMAT csv, HEADER true);

