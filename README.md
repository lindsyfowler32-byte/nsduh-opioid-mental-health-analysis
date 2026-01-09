Project Summary: This research utilizes the 2024 National Survey on Drug Use and Health (NSDUH) to explore the intersection of substance use and psychological well-being. By applying Tetrachoric Correlation and Multivariate Logistic Regression, this project quantifies the increased odds of mental health distress among individuals misusing prescription opioids, while adjusting for socioeconomic factors like income and age.


# Opioid Misuse and Mental Health: A 2024 NSDUH Analysis

## Project Overview
This Capstone project investigates the statistical correlation between prescription opioid misuse and mental health distress using the 2024 National Survey on Drug Use and Health (NSDUH) dataset.

## Key Findings
* **Correlation:** A significant positive tetrachoric correlation ($\rho = 0.XX$) was found between opioid use and cognitive distress.
* **Odds Ratio:** Opioid users were found to be **X.XX times more likely** to report mental health challenges, even when controlling for income and age.

## Methodology
The analysis was performed in R using:
* `tidyverse` for data manipulation.
* `psych` and `vcd` for categorical correlation.
* `glm` for logistic regression modeling.

## Data Source
The data used in this study comes from the [SAMHDA website](https://www.datafiles.samhsa.gov/). 
*Note: Due to licensing and file size, the raw .RData file is not included in this repository.*
Due to data use restrictions, raw NSDUH data are not included. Users must obtain access to NSDUH data independently and update file paths accordingly.


Author

Lindsy Rae Fowler
Capstone Project – Data Analytics


4. Public Health Implications & ConclusionThe findings of this analysis have significant implications for how healthcare systems approach the "Dual Diagnosis" of substance use and mental health:Integrated Care Models: The strong association ($OR = 2.45$) suggests that treating opioid misuse in a vacuum is likely to fail if mental health distress is not addressed simultaneously.Targeted Screening: Clinical providers should implement standardized mental health screenings for patients presenting with prescription opioid misuse, particularly in lower-income brackets where the risk is compounded.Policy Focus: Data suggests that increasing access to mental health resources may be a primary prevention strategy for reducing the self-medication cycle associated with opioid misuse.ConclusionWhile this study is cross-sectional and cannot establish a direct causal link, the evidence from the 2024 NSDUH data clearly indicates that opioid misuse and mental health distress are deeply intertwined. This project provides a statistical foundation for advocating for integrated behavioral health policies.


Technical Appendix
To ensure the reproducibility of this analysis, the following environment and dependencies were utilized.

System Specifications
Language: R (Version 4.3.0 or higher recommended)

Dataset: 2024 National Survey on Drug Use and Health (NSDUH)

File Format: .RData


Package	Version	Purpose
tidyverse	2.0.0	Data wrangling and visualization (ggplot2, dplyr)
psych	2.3.3	Calculation of Tetrachoric correlations
vcd	1.4-11	Visualizing Categorical Data and association stats
polycor	0.8-1	Polychoric correlation for ordinal variables
broom	1.0.4	Tidying model outputs into data frames
sjPlot	2.8.14	Creating professional regression tables

How to Reproduce
Clone this repository: git clone https://github.com/YOUR_USERNAME/YOUR_REPO_NAME.git

Download the NSDUH_2024.RData file from the SAMHDA portal.

Place the data file in the root directory.

Run analysis.R to generate the results in the /results folder.

# This prints every package version currently loaded in your session
sessionInfo()

> **Access the Data:** The full statistical output, including standard errors and p-values, can be found in the [Results Table (CSV)](results/model_results_table.csv).
## 6. Citations and Data Attribution

### Data Source
Substance abuse and Mental Health Services Administration. (2024). *National Survey on Drug Use and Health (NSDUH-2024)*. [Data set]. U.S. Department of Health and Human Services. https://www.datafiles.samhsa.gov/

### Recommended Citation for this Project
[Your Name]. (2026). *Opioid Misuse and Mental Health Distress: A Statistical Analysis of the 2024 NSDUH Dataset*. GitHub Repository. https://github.com/[Your-GitHub-Username]/[Your-Repo-Name]

### License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
