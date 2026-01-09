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
