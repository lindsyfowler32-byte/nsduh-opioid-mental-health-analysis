# nsduh-opioid-mental-health-analysis
Analysis of NSDUH 2024 data examining opioid misuse, health status, and cognitive/mental distress using R.
NSDUH Opioid Use and Mental Health Analysis (R)
Project Overview

This project analyzes data from the 2024 National Survey on Drug Use and Health (NSDUH) to examine the relationship between opioid misuse, self-reported health status, and cognitive or mental distress. The analysis applies categorical correlation techniques and logistic regression modeling using R.

Research Questions

Is opioid misuse associated with poorer self-reported health?

Are individuals who misuse opioids more likely to report cognitive or mental difficulties?

Do these relationships persist after controlling for age, income, and poverty indicators?

Methods

Data Source: NSDUH 2024 (restricted-use; not included in this repository)

Techniques:

Data cleaning and recoding

Polychoric and tetrachoric correlations

Logistic regression (binomial family)

Data visualization using ggplot2

Software: R, tidyverse, polycor

Key Variables

Opioid Use: Past-year misuse of prescription pain relievers or heroin

Health Status: Self-reported general health

Mental/Cognitive Distress: Memory or cognitive difficulty indicator

Controls: Age, income, poverty status

Repository Structure

scripts/: Modular R scripts for cleaning, analysis, visualization, and modeling

outputs/: Generated figures and tables

data/: Documentation only (no raw data included)

Data Ethics Notice

Due to data use restrictions, raw NSDUH data are not included. Users must obtain access to NSDUH data independently and update file paths accordingly.

Author

Lindsy Rae Fowler
Capstone Project – Data Analytics
