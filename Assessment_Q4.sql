-- Assessment_Q4.sql
-- Question 4: Customer Lifetime Value (CLV) Estimation
-- Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume
-- Task: Calculate CLV using tenure, transaction count, and 0.1% profit per transaction

SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    -- Calculate account tenure in months (since signup)
    TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE) AS tenure_months,
    -- Count all transactions for this customer
    COUNT(s.id) AS total_transactions,
    -- CLV calculation formula:
    -- (transactions/tenure) * 12 * (0.1% of avg transaction value)
    -- Note: Amounts converted from kobo (/100) and profit is 0.1% (*0.001)
    -- NULLIF prevents division by zero for new customers
    ROUND(
        (COUNT(s.id)/NULLIF(TIMESTAMPDIFF(MONTH, u.date_joined, CURRENT_DATE), 0)) * 12 * 
        ((AVG(s.confirmed_amount)/100) * 0.001),
        2
    ) AS estimated_clv
FROM 
    users_customuser u
LEFT JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
GROUP BY 
    u.id, u.first_name, u.last_name, u.date_joined
-- Order by highest CLV first (most valuable customers)
ORDER BY 
    estimated_clv DESC;