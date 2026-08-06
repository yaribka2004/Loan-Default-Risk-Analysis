SELECT 
    l.loan_id,
    l.loan_amount,
    l.loan_status,
    l.defaulted,
    b.borrower_id,
    b.annual_income,
    b.credit_score
FROM 
	loans l
JOIN 
	borrowers b 
	ON l.borrower_id = b.borrower_id
LIMIT 5;

SELECT 
    COUNT(loan_id) AS total_loans,
    SUM(defaulted) AS defaulted_loans,
    ROUND(AVG(defaulted) * 100, 2) AS default_rate_pct
FROM 
	loans;

SELECT 
    loan_purpose,
    COUNT(loan_id) AS total_loans,
    SUM(defaulted) AS defaulted_loans,
    ROUND(AVG(defaulted) * 100, 2) AS default_rate_pct,
    ROUND(AVG(loan_amount), 2) AS avg_loan_amount
FROM 
	loans
GROUP BY 
	loan_purpose
ORDER BY 
	default_rate_pct DESC;

SELECT 
    b.employment_status,
    COUNT(l.loan_id) AS total_loans,
    SUM(l.defaulted) AS defaulted_loans,
    ROUND(AVG(l.defaulted) * 100, 2) AS default_rate_pct
FROM 
	loans l
JOIN 
	borrowers b 
	ON l.borrower_id = b.borrower_id
GROUP BY 
	b.employment_status
ORDER BY 
	default_rate_pct DESC;

SELECT 
    loan_purpose,
    ROUND(AVG(CASE 
				WHEN defaulted = 1 
				THEN loan_amount 
			  END), 2) AS avg_defaulted_amount,
    ROUND(AVG(CASE 
				WHEN defaulted = 0 
				THEN loan_amount 
			  END), 2) AS avg_non_defaulted_amount
FROM 
	loans
GROUP BY 
	loan_purpose;
