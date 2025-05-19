-- Assessment_Q2.sql
-- Question 2: Transaction Frequency Analysis
-- Scenario: Segment customers by transaction frequency for tailored services
-- Task: Categorize customers as High/Medium/Low frequency based on monthly transactions

WITH monthly_transactions AS (
    -- Calculate monthly transaction counts per customer
    SELECT 
        u.id AS customer_id,
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS month,
        COUNT(*) AS transaction_count
    FROM 
        users_customuser u
    JOIN 
        savings_savingsaccount s ON u.id = s.owner_id
    GROUP BY 
        u.id, DATE_FORMAT(s.transaction_date, '%Y-%m')
),

customer_stats AS (
    -- Calculate average monthly transactions per customer
    SELECT 
        customer_id,
        AVG(transaction_count) AS avg_monthly_transactions
    FROM 
        monthly_transactions
    GROUP BY 
        customer_id
)

-- Categorize customers and aggregate results (only High and Medium frequency)
SELECT 
    frequency_category,
    customer_count,
    avg_transactions_per_month
FROM (
    SELECT 
        CASE 
            WHEN avg_monthly_transactions >= 10 THEN 'High Frequency'
            WHEN avg_monthly_transactions >= 3 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category,
        COUNT(*) AS customer_count,
        ROUND(AVG(avg_monthly_transactions), 1) AS avg_transactions_per_month
    FROM 
        customer_stats
    GROUP BY 
        frequency_category
) AS categorized_results
WHERE frequency_category IN ('High Frequency', 'Medium Frequency')
ORDER BY 
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
    END;