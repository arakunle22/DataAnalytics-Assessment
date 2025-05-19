-- Assessment_Q1.sql
-- Question 1: High-Value Customers with Multiple Products
-- Scenario: Identify customers with both savings and investment plans for cross-selling
-- Task: Find customers with ≥1 funded savings AND ≥1 funded investment plan, sorted by total deposits

SELECT 
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.plan_id END) AS savings_count,
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.plan_id END) AS investment_count,
    SUM(s.confirmed_amount) / 100 AS total_deposits  -- Convert from kobo to currency
FROM 
    users_customuser u
JOIN 
    savings_savingsaccount s ON u.id = s.owner_id
JOIN 
    plans_plan p ON s.plan_id = p.id
WHERE 
    p.is_regular_savings = 1 OR p.is_a_fund = 1  -- Filter for savings or investment plans
GROUP BY 
    u.id, u.first_name, u.last_name
HAVING 
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN s.plan_id END) > 0  -- At least one savings plan
    AND COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN s.plan_id END) > 0  -- At least one investment plan
ORDER BY 
    total_deposits DESC;