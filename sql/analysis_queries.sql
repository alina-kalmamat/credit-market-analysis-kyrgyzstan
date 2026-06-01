-- SQL queries for credit market analysis

-- Importing data into tables
CREATE TABLE new_loans (
    year INTEGER,
    month INTEGER,
    sector VARCHAR(100),
    loan_volume NUMERIC,
    interest_rate NUMERIC
);

CREATE TABLE outstanding_loans (
    year INTEGER,
    month INTEGER,
    sector VARCHAR(100),
    outstanding_loans NUMERIC,
    interest_rate NUMERIC
);

CREATE TABLE regional_loans (
    region VARCHAR(100),
    sector VARCHAR(100),
    year INTEGER,
    quarter INTEGER,
    loan_amount NUMERIC
);

-- QUERY 1: Which sectors received the largest volume of new loans between 2018 and 2025?
SELECT
    sector,
    ROUND(SUM(loan_volume)::numeric, 2) AS total_new_loans
FROM new_loans
GROUP BY sector
ORDER BY total_new_loans DESC;


-- QUERY 2: Which sectors contributed most to lending growth between 2018 and 2025?
WITH sector_growth AS (
    SELECT
        sector,
        SUM(CASE WHEN year = 2018 THEN loan_volume END) AS loans_2018,
        SUM(CASE WHEN year = 2025 THEN loan_volume END) AS loans_2025
    FROM new_loans
    GROUP BY sector
)

SELECT
    sector,
    ROUND(loans_2018::numeric, 2) AS loans_2018,
    ROUND(loans_2025::numeric, 2) AS loans_2025,
    ROUND(
        (loans_2025 - loans_2018)::numeric,
        2
    ) AS absolute_growth
FROM sector_growth
ORDER BY absolute_growth DESC;


-- QUERY 3: Which sectors hold the largest outstanding loan portfolios?
SELECT
    sector,
    ROUND(
        SUM(outstanding_loans)::numeric,
        2
    ) AS total_portfolio
FROM outstanding_loans
GROUP BY sector
ORDER BY total_portfolio DESC;


-- QUERY 4: Which sectors have the highest average interest rates?
SELECT
    sector,
    ROUND(
        AVG(interest_rate)::numeric,
        2
    ) AS avg_interest_rate
FROM outstanding_loans
GROUP BY sector
ORDER BY avg_interest_rate DESC;


-- QUERY 5: How concentrated is lending across regions?
SELECT
    region,
    ROUND(
        SUM(loan_amount)::numeric,
        2
    ) AS total_loans,
    ROUND(
        100.0 * SUM(loan_amount)
        /
        SUM(SUM(loan_amount)) OVER (),
        2
    ) AS market_share_pct
FROM regional_loans
GROUP BY region
ORDER BY total_loans DESC;


-- QUERY 6: Which sectors receive the highest volume of new loans relative to their existing portfolio size?
WITH new_lending AS (
    SELECT
        sector,
        SUM(loan_volume) AS total_new_loans
    FROM new_loans
    GROUP BY sector
),

portfolio AS (
    SELECT
        sector,
        SUM(outstanding_loans) AS total_portfolio
    FROM outstanding_loans
    GROUP BY sector
)

SELECT
    n.sector,
    ROUND(n.total_new_loans::numeric, 2) AS total_new_loans,
    ROUND(p.total_portfolio::numeric, 2) AS total_portfolio,
    ROUND(
        100.0 * n.total_new_loans / p.total_portfolio,
        2
    ) AS lending_to_portfolio_pct
FROM new_lending n
JOIN portfolio p
    ON n.sector = p.sector
ORDER BY lending_to_portfolio_pct DESC;


-- QUERY 7: Do sectors with higher interest rates receive lower volumes of new lending?
WITH new_lending AS (
    SELECT
        sector,
        SUM(loan_volume) AS total_new_loans
    FROM new_loans
    GROUP BY sector
),

rates AS (
    SELECT
        sector,
        AVG(interest_rate) AS avg_rate
    FROM outstanding_loans
    GROUP BY sector
)

SELECT
    n.sector,
    ROUND(n.total_new_loans::numeric, 2) AS total_new_loans,
    ROUND(r.avg_rate::numeric, 2) AS avg_interest_rate
FROM new_lending n
JOIN rates r
    ON n.sector = r.sector
ORDER BY avg_interest_rate DESC;


-- QUERY 8: Which sectors combine high lending growth and large outstanding portfolios?
WITH growth AS (
    SELECT
        sector,
        SUM(CASE WHEN year = 2018 THEN loan_volume END) AS loans_2018,
        SUM(CASE WHEN year = 2025 THEN loan_volume END) AS loans_2025
    FROM new_loans
    GROUP BY sector
),

portfolio AS (
    SELECT
        sector,
        SUM(outstanding_loans) AS total_portfolio
    FROM outstanding_loans
    GROUP BY sector
)

SELECT
    g.sector,
    ROUND(
        (g.loans_2025 - g.loans_2018)::numeric,
        2
    ) AS absolute_growth,
    ROUND(
        p.total_portfolio::numeric,
        2
    ) AS total_portfolio
FROM growth g
JOIN portfolio p
    ON g.sector = p.sector
ORDER BY absolute_growth DESC;


-- QUERY 9: Which sectors became more important in the credit market between 2018 and 2025?
WITH sector_share AS (
    SELECT
        year,
        sector,
        SUM(loan_volume) AS sector_loans,
        SUM(SUM(loan_volume)) OVER (PARTITION BY year) AS total_market
    FROM new_loans
    WHERE year IN (2018, 2025)
    GROUP BY year, sector
)

SELECT
    sector,
    ROUND(MAX(CASE WHEN year = 2018 THEN sector_loans / total_market * 100 END)::numeric, 2) AS share_2018,
    ROUND(MAX(CASE WHEN year = 2025 THEN sector_loans / total_market * 100 END)::numeric, 2) AS share_2025,
    ROUND(
        (
            MAX(CASE WHEN year = 2025 THEN sector_loans / total_market * 100 END)
            -
            MAX(CASE WHEN year = 2018 THEN sector_loans / total_market * 100 END)
        )::numeric,
        2
    ) AS market_share_change
FROM sector_share
GROUP BY sector
ORDER BY market_share_change DESC;


-- QUERY 10: Which sectors dominate both new lending and outstanding portfolios?
WITH new_lending AS (
    SELECT
        sector,
        SUM(loan_volume) AS total_new_loans
    FROM new_loans
    GROUP BY sector
),

portfolio AS (
    SELECT
        sector,
        SUM(outstanding_loans) AS total_portfolio
    FROM outstanding_loans
    GROUP BY sector
)

SELECT
    n.sector,
    ROUND(n.total_new_loans::numeric, 2) AS total_new_loans,
    ROUND(p.total_portfolio::numeric, 2) AS total_portfolio,

    RANK() OVER (
        ORDER BY n.total_new_loans DESC
    ) AS lending_rank,

    RANK() OVER (
        ORDER BY p.total_portfolio DESC
    ) AS portfolio_rank

FROM new_lending n
JOIN portfolio p
    ON n.sector = p.sector
ORDER BY lending_rank, portfolio_rank;

