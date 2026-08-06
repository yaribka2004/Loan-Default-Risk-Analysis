# Loan Default Risk Analysis

## Project Overview
This project presents an end-to-end credit risk analysis for Horizon Financial Group, a mid-size consumer lending institution. Facing a rising portfolio default rate of **24.3%** (well above the target threshold of 12%), this investigation identifies core drivers of loan defaults using **SQL**, **Python (Pandas, Seaborn, matplotlib, Numpy)**, and an executive **Power BI Dashboard**.

The primary objective is to evaluate multi-factor risk interactions—specifically how Credit Scores, Debt-to-Income (DTI) ratios, Employment Tenure, and Loan Purposes interact—to uncover critical underwriting gaps and optimize credit approval policies.

---

## Objectives
* **Quantify Core Risk Drivers:** Determine how credit scores, DTI ratios, employment status, work tenure, and loan purposes impact default probabilities.
* **Expose Loan Amount Discrepancies:** Analyze average loan amounts between defaulted and non-defaulted borrowers across loan categories.
* **Identify Underwriting Traps:** Evaluate multi-dimensional risk interactions using cross-segmentation and interaction matrices.
* **Expose Structural Risk Loops:** Analyze correlation matrices to understand how pricing (interest rates) feeds into borrower default behavior.
* **Deliver Actionable Recommendations:** Propose concrete policy changes, underwriting thresholds, and risk caps to bring overall portfolio defaults closer to target thresholds.

---

## Skills & Tools Demonstrated
* **SQL Data Extraction & Aggregation:** Multi-table `JOIN`s, group aggregation, conditional aggregation (`CASE WHEN`), metrics calculation (default rate %), and purpose/employment segmentation.
* **Python Data Analysis:**
  * Risk bucket segmentation using `pd.cut()` for Credit Score (`<580` to `750+`) and DTI (`<20%` to `>50%`).
  * Feature engineering for short employment tenure (`years_employed < 2`).
  * Risk Matrix creation via `pd.pivot_table()`.
  * Correlation analysis (`df.corr()`) across key numeric financial features.
* **Data Visualization:** Custom heatmaps using `seaborn` and `matplotlib`.
* **Executive Dashboarding:** Built an interactive **Power BI** report featuring KPI cards, dynamic slicers (date, income, employment), purpose-level breakdowns, and embedded interaction risk tables.

---

## Key Insights & Risk Drivers

### 1. Credit Score vs. Default Rate (Primary Risk Driver)
Default risk drops significantly as credit scores improve ($r = -0.29$ inverse correlation with default):
* **Poor (<580):** 43.24% default rate
* **Fair (580–639):** 41.88% default rate
* **Good (640–699):** 25.81% default rate
* **Very Good (700–749):** 16.28% default rate
* **Excellent (750+):** 11.69% default rate

### 2. DTI Overrides Credit Quality
Debt-to-Income ratio above **50%** acts as a critical failure point (34.27% overall default rate). Crucially, a high DTI severely dilutes good credit history: borrowers in the **"Good" (640–699)** tier with a Critical DTI (>50%) experience a **42.4% default rate**.

### 3. Employment Tenure & Work Status Impact
* **Short Employment Tenure (<2 Years):** Borrowers with less than 2 years of work experience exhibit a **34.52% default rate** compared to **22.63%** for those with 2+ years—a **+11.89 percentage point increase** in default probability.
* **Employment Status:** `Part-Time` (**27.69%**) and `Self-Employed` (**24.76%**) applicants carry higher risk due to income volatility, whereas `Contract` (**22.73%**), `Retired` (**23.33%**), and `Full-Time` (**23.93%**) remain closer to portfolio benchmarks.

### 4. High-Risk Hotspot
Cross-analyzing Credit Score tiers against DTI ratios within a risk matrix revealed the portfolio's highest risk concentration:

* Critical Risk Segment: Combining a Credit Score < 580 with a DTI > 50% drives an extreme 57.1% default rate

### 5. Loan Purpose Vulnerabilities & Amount Discrepancies
* **Highest-Risk Purposes:** Loans issued for discretionary or high-expense purposes show elevated default rates:
  * **Wedding:** 32.14% default rate (AVG Amount: $21,892.86)
  * **Home Improvement:** 28.57% default rate (AVG Amount: $23,407.14)
  * **Auto Loan:** 27.12% default rate (AVG Amount: $19,554.24)
* **Defaulted vs. Non-Defaulted Amount Gap:** For non-collateralized or high-expense categories like **Education** ($29,183 defaulted vs. $17,115 non-defaulted) and **Medical Expenses** ($30,421 defaulted vs. $21,298 non-defaulted), defaulted loans carry significantly higher principal balances, proving that large loan sizes serve as an additional default catalyst.

### 6. The "Rate Burden Loop"
Correlation analysis revealed a strong negative correlation between **Credit Score** and **Interest Rate** ($r = -0.76$):
* Penalizing lower-score borrowers with high interest rates inflates their `monthly_payment` ($r = 0.68$ with loan amount).
* Higher monthly payments directly inflate `dti_ratio` ($r = 0.67$), triggering an involuntary default feedback loop.

---

## Risk Matrix & Correlation Heatmap

### Risk Matrix: Default Rate (%) by Credit Score & DTI

| Credit Score Tier | <20% (Low) | 20-35% (Moderate) | 35-50% (High) | >50% (Critical) | Total |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **750+ (Excellent)** | 15.4% | 6.7% | 12.3% | 13.9% | **11.7%** |
| **700-749 (Very Good)** | 11.1% | 8.7% | 12.0% | 26.9% | **16.3%** |
| **640-699 (Good)** | 18.2% | 9.1% | 24.0% | 40.0% | **25.8%** |
| **580-639 (Fair)** | 28.6% | 20.0% | 38.7% | 52.5% | **41.9%** |
| **<580 (Poor)** | 12.5% | 25.0% | 25.0% | **57.1%** | **43.2%** |
| **Overall Average** | **16.7%** | **10.5%** | **20.7%** | **34.4%** | **24.3%** |

---

## Strategic Risk Mitigation & Policy Recommendations

### Top 3 Risk Factors Summary
1. **Low Credit Score (<640):** Drives default rates above 41% across Poor and Fair tiers.
2. **Critical DTI (>35% to >50%):** Overrides good credit status, raising default rates up to 42.4% even for "Good" score holders.
3. **Short Employment Tenure (<2 Years):** Increases default likelihood to 34.52% (+11.9% higher than experienced workers).

### Proposed Underwriting Policy Thresholds

| Rule / Metric | Proposed Policy Threshold | Impact & Business Rationale |
| :--- | :--- | :--- |
| **Minimum Credit Score** | **640 (Hard Floor)** | Auto-declines or flags applicants with scores below 640, eliminating segments with >41% defaults. Preferred rates apply to **700+**. |
| **Maximum DTI Cutoff** | **45% (Hard Cap)** | Hard cutoff across all tiers. For scores between **640–699**, reduce maximum allowable DTI to **35%**. |
| **Tenure Rule** | **<2 Years Scrutiny** | Requires proof of income stability or lower maximum loan caps for applicants with less than 2 years of work tenure (combating 34.5% default rate). |
| **Interaction Rule (Risk Trap)** | **Auto-Decline Combination** | Mandates immediate rejection for `Credit Score < 640` combined with `DTI > 35%` (prevents default hotspots reaching 57.1%). |
| **Purpose & Amount Caps** | **Tiered Principal Limits** | Imposes lower maximum loan limits and stricter Debt-Service Coverage Ratios (DSCR) for **Wedding**, **Home Improvement**, and **Education** loans. |

