# Credit Market Analysis of Kyrgyzstan (2018–2025)

## Project Overview

This project analyzes the structure and development of the Kyrgyz credit market between 2018 and 2025 using PostgreSQL and Python.

The analysis focuses on:

* New loan issuance by economic sector
* Outstanding loan portfolios
* Interest rates across sectors
* Regional distribution of lending activity
* Changes in the structure of the credit market over time

The project combines SQL-based analysis with data visualization to identify key trends in lending activity across sectors and regions.

## Objectives

The main goals of this project are:

* Analyze the composition of the Kyrgyz credit market
* Identify sectors driving lending growth
* Examine the concentration of credit across regions
* Explore changes in market structure between 2018 and 2025
* Practice real-world SQL analysis workflows using PostgreSQL

## Dataset Source

Data was obtained from publicly available statistics published by:

* National Bank of the Kyrgyz Republic

Datasets:

* New loans by sector (2018–2025)
* Outstanding loan portfolios by sector
* Regional lending activity

## Technologies Used

* PostgreSQL
* DBeaver
* Python
* Pandas
* Matplotlib
* Jupyter Notebook
* Git & GitHub

## Repository Structure

* [**data**](./data)

  * Raw and cleaned credit market datasets
  * SQL query exports used for visualizations

* [**notebooks**](./notebooks)

  * Jupyter notebook containing the complete analysis workflow
  * Data preparation, SQL analysis summary, visualizations, and conclusions
  * Notebook Preview: - [View notebook in NBViewer](https://nbviewer.org/github/alina-kalmamat/kyrgyzstan-credit-market-analysis/blob/main/notebooks/credit_market_analysis.ipynb)

* [**sql**](./sql)

  * PostgreSQL queries used to analyze the credit market
  * Aggregations, CTEs, JOINs, window functions, and ranking functions

* [**visuals**](./visuals)

  * Charts generated from SQL analysis results

* **Main Files**

  * `credit_market_analysis.ipynb` — Complete project workflow and findings
  * `analysis_queries.sql` — SQL queries used throughout the project
  * `README.md` — Project documentation

## Key Findings

* Trade and Consumer Loans accounted for the largest share of lending activity.
* Consumer Loans were the primary driver of credit market growth between 2018 and 2025.
* Trade maintained the largest outstanding loan portfolio.
* Bishkek accounted for more than half of total lending activity.
* The structure of the credit market shifted toward household borrowing over the study period.

## Conclusion

The analysis shows that the Kyrgyz credit market experienced substantial growth and structural transformation between 2018 and 2025. While Trade remained one of the most important lending sectors, Consumer Loans emerged as the dominant driver of market expansion. Lending activity was highly concentrated in Bishkek, and the overall structure of the market shifted toward household borrowing during the study period.
