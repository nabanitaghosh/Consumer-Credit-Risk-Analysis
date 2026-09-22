/*
00_setup.sql
Purpose: create a typed analytics table from the imported Loan table.
Assumption: the CSV has been imported to SQLite as table Loan using original column names.
*/

DROP TABLE IF EXISTS loan_applications;

CREATE TABLE loan_applications AS
SELECT
    NULLIF(TRIM(ApplicationDate), '') AS application_date,
    CAST(NULLIF(TRIM(Age), '') AS INTEGER) AS age,
    CAST(NULLIF(TRIM(AnnualIncome), '') AS REAL) AS annual_income,
    CAST(NULLIF(TRIM(CreditScore), '') AS INTEGER) AS credit_score,
    NULLIF(TRIM(EmploymentStatus), '') AS employment_status,
    NULLIF(TRIM(EducationLevel), '') AS education_level,
    CAST(NULLIF(TRIM(Experience), '') AS INTEGER) AS experience_years,
    CAST(NULLIF(TRIM(LoanAmount), '') AS REAL) AS loan_amount,
    CAST(NULLIF(TRIM(LoanDuration), '') AS INTEGER) AS loan_duration_months,
    NULLIF(TRIM(MaritalStatus), '') AS marital_status,
    CAST(NULLIF(TRIM(NumberOfDependents), '') AS INTEGER) AS dependents,
    NULLIF(TRIM(HomeOwnershipStatus), '') AS home_ownership_status,
    CAST(NULLIF(TRIM(MonthlyDebtPayments), '') AS REAL) AS monthly_debt_payments,
    CAST(NULLIF(TRIM(CreditCardUtilizationRate), '') AS REAL) AS credit_card_utilization_rate,
    CAST(NULLIF(TRIM(NumberOfOpenCreditLines), '') AS INTEGER) AS open_credit_lines,
    CAST(NULLIF(TRIM(NumberOfCreditInquiries), '') AS INTEGER) AS credit_inquiries,
    CAST(NULLIF(TRIM(DebtToIncomeRatio), '') AS REAL) AS debt_to_income_ratio,
    CAST(NULLIF(TRIM(BankruptcyHistory), '') AS INTEGER) AS bankruptcy_history,
    NULLIF(TRIM(LoanPurpose), '') AS loan_purpose,
    CAST(NULLIF(TRIM(PreviousLoanDefaults), '') AS INTEGER) AS previous_loan_defaults,
    CAST(NULLIF(TRIM(PaymentHistory), '') AS INTEGER) AS payment_history,
    CAST(NULLIF(TRIM(LengthOfCreditHistory), '') AS INTEGER) AS credit_history_years,
    CAST(NULLIF(TRIM(SavingsAccountBalance), '') AS REAL) AS savings_balance,
    CAST(NULLIF(TRIM(CheckingAccountBalance), '') AS REAL) AS checking_balance,
    CAST(NULLIF(TRIM(TotalAssets), '') AS REAL) AS total_assets,
    CAST(NULLIF(TRIM(TotalLiabilities), '') AS REAL) AS total_liabilities,
    CAST(NULLIF(TRIM(MonthlyIncome), '') AS REAL) AS monthly_income,
    CAST(NULLIF(TRIM(UtilityBillsPaymentHistory), '') AS REAL) AS utility_payment_history,
    CAST(NULLIF(TRIM(JobTenure), '') AS INTEGER) AS job_tenure_years,
    CAST(NULLIF(TRIM(NetWorth), '') AS REAL) AS net_worth,
    CAST(NULLIF(TRIM(BaseInterestRate), '') AS REAL) AS base_interest_rate,
    CAST(NULLIF(TRIM(InterestRate), '') AS REAL) AS interest_rate,
    CAST(NULLIF(TRIM(MonthlyLoanPayment), '') AS REAL) AS monthly_loan_payment,
    CAST(NULLIF(TRIM(TotalDebtToIncomeRatio), '') AS REAL) AS total_debt_to_income_ratio,
    CAST(NULLIF(TRIM(LoanApproved), '') AS INTEGER) AS loan_approved,
    CAST(NULLIF(TRIM(RiskScore), '') AS REAL) AS risk_score,

    CASE
        WHEN CAST(NULLIF(TRIM(AnnualIncome), '') AS REAL) > 0
        THEN CAST(NULLIF(TRIM(LoanAmount), '') AS REAL)
             / CAST(NULLIF(TRIM(AnnualIncome), '') AS REAL)
    END AS loan_to_annual_income,

    CASE
        WHEN CAST(NULLIF(TRIM(AnnualIncome), '') AS REAL) > 0
        THEN CAST(NULLIF(TRIM(NetWorth), '') AS REAL)
             / CAST(NULLIF(TRIM(AnnualIncome), '') AS REAL)
    END AS net_worth_to_income,

    CASE
        WHEN CAST(NULLIF(TRIM(LoanAmount), '') AS REAL) > 0
        THEN CAST(NULLIF(TRIM(TotalAssets), '') AS REAL)
             / CAST(NULLIF(TRIM(LoanAmount), '') AS REAL)
    END AS asset_to_loan_ratio,

    COALESCE(CAST(NULLIF(TRIM(SavingsAccountBalance), '') AS REAL), 0)
      + COALESCE(CAST(NULLIF(TRIM(CheckingAccountBalance), '') AS REAL), 0)
      AS liquid_assets

FROM Loan;

CREATE INDEX IF NOT EXISTS idx_loan_applications_approved
    ON loan_applications (loan_approved);

CREATE INDEX IF NOT EXISTS idx_loan_applications_income
    ON loan_applications (annual_income);

CREATE INDEX IF NOT EXISTS idx_loan_applications_credit_score
    ON loan_applications (credit_score);
