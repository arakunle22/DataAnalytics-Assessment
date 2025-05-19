# Data Analyst Assessment Solutions

## Repository Overview

This repository contains my solutions to the Data Analyst SQL assessment, demonstrating proficiency in querying relational databases to solve business problems. The structured approach follows the requested format with clear documentation of my thought process for each solution.

```
DataAnalytics-Assessment/
├── Assessment_Q1.sql
├── Assessment_Q2.sql
├── Assessment_Q3.sql
├── Assessment_Q4.sql
└── README.md
```

---

## Question 1: Identifying High-Value Customers with Multiple Products

### Objective:
Find customers with ≥1 funded savings AND ≥1 funded investment plan, sorted by total deposits

### My Approach:
Firstly, I carefully examined table relationships using the provided schema hints. After understanding the table structure, I joined the three needed tables to gather customer information, transaction details, and plan types. I used the `WHERE` clause to filter only savings plans (`is_regular_savings = 1`) or investment plans (`is_a_fund = 1`). 

Using `CASE` statements with `COUNT(DISTINCT ...)` allowed me to separately count savings and investment plans per customer, ensuring each plan was only counted once using `DISTINCT`. I summed the `confirmed_amount` (the field for inflow value) and divided by 100 to convert from kobo to the base currency. I further used the `HAVING` clause to ensure we only include customers with at least one of each plan type. Finally, I sorted the results by total deposits in descending order to show the highest-value customers first.

### Key Challenges & Solutions:

**Understanding Plan Types**  
- Initially, I wasn't sure how to distinguish between savings and investment plans  
- Carefully reviewed schema hints and used:
  - `is_regular_savings = 1` for savings plans
  - `is_a_fund = 1` for investment plans  

**Handling Kobo to Currency Conversion**  
- As all amount fields are in kobo, I made sure to divide by 100 in the final output  
- Chose to convert after aggregation for precision  

Solutions:  
- Thorough review of table structure and hints  
- Tried different query approaches  
- Focused on business needs (customers with both types, sorted by deposits)  

---

## Question 2: Customer Transaction Frequency Analysis

### Objective:
Categorize customers as High/Medium/Low frequency based on monthly transactions

### My Approach:
Firstly, I joined users with their transactions and grouped by customer and month (`'YYYY-MM'` format). Then, I counted transactions per customer per month and calculated each customer's average monthly transactions. 

I categorized customers into three frequency groups (high, medium, and low), excluded the low frequency group, and only kept high/medium customers(per expected output). For final output, I counted the number of customers in each remaining group, calculated their average transaction rate, and ordered High Frequency first, then Medium.

### Key Challenges:
- Struggled initially with formatting monthly grouping in MySQL; used `DATE_FORMAT()`
- I Had to handle edge cases like:
  - Customers with only one transaction ever
  - Transactions spanning multiple years
  - Customers with no transactions (excluded)

Final solution was structured for clarity:  
1. Calculate monthly transactions  
2. Average per customer  
3. Categorize groups  

---

## Question 3: Identifying Dormant Accounts

### Objective:
Find active savings/investment accounts with no transactions in 365 days

### My Approach:
I first understood the requirements, then:  
- Got account info from `plans` table  
- Added account type using `CASE`  
- Joined with savings table to find transactions  
- Calculated the date of the last transaction  
- Used `DATE()` to strip time from datetime values  
- Applied filters: active, not archived/deleted accounts  
- Filtered only accounts inactive for 365+ days  
- Ordered the results

### Challenges:
- Needed to ensure only the date part was extracted (used `DATE()`)
- Initially overlooked filtering out archived/deleted accounts, I fixed it with `is_archived = 0` and `is_deleted = 0`

Solutions:  
- Careful reading of requirements  
- Testing with sample data  
- Consideration of edge cases  

---

## Question 4: Customer Lifetime Value Estimation

### Objective:
Calculate CLV using tenure, transaction count, and 0.1% profit per transaction

### My Approach:
- I identified required data: customer details, account age, transactions  
- Setup the Key calculations:
  - `TIMESTAMPDIFF` to calculate months since signup  
  - `COUNT` for total transactions  
  - `AVG` for average transaction value  
- Then, Implemented CLV formula: tenure × avg. transaction value × profit rate  
- I Joined tables, grouped by customer, sorted by CLV  
- I had to make use of `ROUND(..., 2)` for monetary formatting  

### Challenges:
- Needed to clarify that only deposits (`confirmed_amount`) count toward CLV  

---

## Verification & Quality Assurance

To ensure solution accuracy, I implemented a series of tests:

### Sample Validation:
- Confirmed all filtering conditions matched requirements  
- Validated sorting orders  
- Verified output columns matched specifications  

### Performance Check:
- Added appropriate indexes where necessary  
- Ensured scalable and optimized solutions for large datasets