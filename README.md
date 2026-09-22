# Consumer Credit Risk Analysis Using SQL

## Project overview

This portfolio project analyzes a synthetic consumer-loan application dataset to identify common characteristics of **approved vs. declined applicants** using SQL only.

The analysis is designed as a compact credit-risk case study suitable for an analytics / strategic insights portfolio. It focuses on population definition, approval-rate segmentation, financial-capacity analysis, credit-history analysis, risk-score interpretation, data-quality validation, and chart-ready SQL outputs.

**Source dataset:** Kaggle — [Financial Risk for Loan Approval](https://www.kaggle.com/datasets/lorenzozoppelletto/financial-risk-for-loan-approval)

The supplied dataset contains 20,000 applications and 36 columns, with `LoanApproved` as the binary approval outcome.

## Business questions

1. What does the overall approval population look like?
2. How do approved and declined applicants differ in income, credit score, assets, net worth, and requested loan size?
3. How does approval rate change across income and credit-score bands?
4. Are bankruptcy history and previous loan defaults associated with approval outcomes?
5. Which employment, education, housing, and loan-purpose segments have materially different approval rates?
6. Which variables appear to carry little descriptive separation?
7. Is `RiskScore` useful for describing the observed decision, and should it be treated as an independent underwriting characteristic?
8. Can the analytical population and key metrics be independently reconciled?

## Tools

- SQL
- SQLite / DBeaver
- GitHub

No Python, R, Excel, or machine-learning model is required for this project.

## Repository structure

```text
consumer-credit-risk-sql/
├── README.md
├── LICENSE
├── data/
│   └── Loan.csv
└── queries/
    ├── 00_setup.sql
    ├── 01_data_quality.sql
    ├── 02_portfolio_overview.sql
    ├── 03_approved_vs_declined.sql
    ├── 04_income_and_credit_score.sql
    ├── 05_credit_history.sql
    ├── 06_financial_capacity.sql
    ├── 07_application_segments.sql
    ├── 08_risk_score_review.sql
    ├── 09_interaction_segments.sql
    ├── 10_validation.sql
    ├── 11_visualization_extracts.sql
    └── loan_credit_risk_master.sql
```

## How to run

### 1. Load the CSV

Create a SQLite database in DBeaver (or another SQLite client), import `data/Loan.csv` as a table named `Loan`, and keep the original column names.

### 2. Run setup

Run:

```text
queries/00_setup.sql
```

This creates a typed analytics table called `loan_applications` and adds reusable derived fields.

### 3. Run the analysis

Run the remaining SQL files in order. `loan_credit_risk_master.sql` combines the main analytical sections into one script.

## Grain and population

The source file does not provide a unique application ID. The working grain is therefore **one row per application record in the supplied CSV**. The first validation step checks the row count and flags exact duplicate records.

`LoanApproved = 1` is treated as approved and `LoanApproved = 0` as declined.

## Key findings from the supplied data

The 20,000 applications contain 4,780 approved applications and 15,220 declined applications, for an overall approval rate of 23.9%.

### Approved vs. declined profile

| Metric | Declined | Approved |
|---|---:|---:|
| Average annual income | ~$45.6K | ~$102.2K |
| Average credit score | ~567.6 | ~584.5 |
| Average loan amount | ~$26.7K | ~$19.1K |
| Average total assets | ~$84.5K | ~$136.6K |
| Average net worth | ~$59.9K | ~$111.8K |
|
The largest descriptive differences are in annual income, total assets, net worth, and requested loan amount. Credit score also separates the groups, although the average difference is smaller.

### Approval rate by annual income

| Annual income band | Approval rate |
|---|---:|
| <$40K | ~2.4% |
| $40–60K | ~13.2% |
| $60–80K | ~32.8% |
| $80–120K | ~58.1% |
| $120–160K | ~82.5% |
| $160K+ | ~95.6% |

### Approval rate by credit score

| Credit score band | Approval rate |
|---|---:|
| ≤550 | ~18.0% |
| 551–600 | ~22.1% |
| 601–650 | ~30.2% |
| 651–700 | ~44.7% |
| 701+ | ~66.7%* |

\* The 701+ segment is very small, so it should not be generalized beyond this sample.

### Credit history

| Indicator | Approval rate |
|---|---:|
| No bankruptcy history | ~24.6% |
| Prior bankruptcy | ~11.1% |
| No previous loan defaults | ~24.8% |
| Previous loan defaults | ~15.5% |

### Variables with little descriptive separation

Several applicant characteristics are nearly identical between the two groups in this dataset, including average debt-to-income ratio, credit-card utilization, dependents, and job tenure. The analysis therefore avoids the common mistake of treating every available column as an equally meaningful approval signal.

## Important analytical caveat

This is a **descriptive credit-risk analysis**, not a causal underwriting study. A high difference in approval rate does not prove that a variable caused the decision.

Some fields should be treated with additional caution:

- `RiskScore` may already encode information used in the approval outcome.
- `InterestRate` may reflect pricing after risk evaluation rather than an independent applicant attribute.
- `MonthlyLoanPayment` is mechanically related to loan terms and pricing and may also be downstream of decisioning.

These fields are therefore analyzed separately instead of being presented as independent underwriting drivers.

## Portfolio takeaway

The observed approved population has a materially stronger financial-capacity profile: higher income, higher assets and net worth, and a smaller requested loan relative to available resources. Credit history also matters descriptively, with lower approval rates among applicants with bankruptcy or previous-default history. Credit score shows a positive monotonic relationship with approval rate, while several household and utilization variables show little separation.

The next logical production step would be to validate whether these relationships remain stable across application cohorts and whether the decision-linked variables were available at the time of underwriting.

## Reproducibility / validation

The validation script checks:

- total row count
- approved + declined reconciliation
- binary target values
- missing / blank key fields
- exact duplicate records
- category coverage
- aggregate population reconciliation
- small-cell warnings for segmented approval rates

## License and data note

The SQL and documentation in this repository are original portfolio material. The `Loan.csv` file is the dataset from Kaggle. Before publishing the raw CSV to a public repository, verify the current Kaggle data-license terms; public references identify this dataset as CC0/Public Domain, but the source-of-record should be checked at publication time.
