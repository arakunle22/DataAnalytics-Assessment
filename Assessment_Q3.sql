-- Assessment_Q3.sql
-- Question 3: Account Inactivity Alert
-- Scenario: Flag accounts with no deposits for >1 year for re-engagement
-- Task: Find active savings/investment accounts with no transactions in 365 days


SELECT 
    p.id AS plan_id,
    p.owner_id,
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
    END AS type,
    DATE(MAX(s.transaction_date)) AS last_transaction_date,  -- Extract date only
    DATEDIFF(CURRENT_DATE, MAX(s.transaction_date)) AS inactivity_days
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount s ON p.id = s.plan_id
WHERE 
    -- Active accounts only (not archived or deleted)
    p.is_archived = 0 
    AND p.is_deleted = 0
    -- Only savings or investment accounts
    AND (p.is_regular_savings = 1 OR p.is_a_fund = 1)
GROUP BY 
    p.id, p.owner_id, p.is_regular_savings, p.is_a_fund
HAVING 
    -- No transactions in last 365 days
    last_transaction_date IS NULL 
    OR DATEDIFF(CURRENT_DATE, last_transaction_date) > 365
ORDER BY 
    inactivity_days DESC;