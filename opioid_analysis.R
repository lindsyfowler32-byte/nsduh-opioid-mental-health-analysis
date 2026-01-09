> # Load libraries
> library(tidyverse)
── Attaching core tidyverse packages ──────────────── tidyverse 2.0.0 ──
✔ dplyr     1.1.4     ✔ readr     2.1.6
✔ forcats   1.0.1     ✔ stringr   1.6.0
✔ ggplot2   4.0.1     ✔ tibble    3.3.0
✔ lubridate 1.9.4     ✔ tidyr     1.3.2
✔ purrr     1.2.0     
── Conflicts ────────────────────────────────── tidyverse_conflicts() ──
✖ dplyr::filter() masks stats::filter()
✖ dplyr::lag()    masks stats::lag()
ℹ Use the conflicted package to force all conflicts to become errors
> library(haven)   # For reading .RData or .sav files
> library(ggplot2)
> library(scales)  # For better plot labels

Attaching package: ‘scales’

The following object is masked from ‘package:purrr’:

    discard

The following object is masked from ‘package:readr’:

    col_factor
> 
> # Load the dataset
> load("NSDUH_2024.RData")
> 
> # Initial look at the data
> # Since the object name might vary, check your environment. 
> # Let's assume the dataframe is named 'ds'
> ds <- as_tibble(NSDUH_2024)
> # Create a focused dataframe for analysis
> project_data <- ds %>%
+     select(
+         # Demographics
+         age_group = CATAG6,      # 6-level age category
+         sex = IRSEX,             # Gender
+         race = NEWRACE2,         # Race/Ethnicity
+         income = INCOME,         # Income levels
+         employment = IRWRKSTAT,  # Employment status
+         
+         # Substance Use Indicators
+         vape_ever = NICVAPEVER,  # Ever vaped nicotine
+         alc_month = ALCMON,      # Alcohol use in past 30 days
+         mj_ever = MJEVER,        # Marijuana ever used
+         
+         # Health/Socioeconomic
+         health_gen = HEALTH,     # Overall health
+         poverty = POVERTY3       # Poverty threshold
+     ) %>%
+     # Recode variables into meaningful strings
+     mutate(
+         sex = factor(sex, levels = c(1, 2), labels = c("Male", "Female")),
+         vape_ever = ifelse(vape_ever == 1, "Yes", "No"),
+         employment = factor(employment, levels = c(1,2,3,4), 
+                             labels = c("Full-time", "Part-time", "Unemployed", "Other"))
+     ) %>%
+     drop_na() # Remove rows with missing values for these specific columns
> # Visualization: Vaping Prevalence by Age and Poverty Level
> project_data %>%
+     filter(vape_ever == "Yes") %>%
+     ggplot(aes(x = age_group, fill = factor(poverty))) +
+     geom_bar(position = "fill") +
+     scale_y_continuous(labels = percent) +
+     labs(
+         title = "Proportion of Nicotine Vapers by Age Group and Poverty Level",
+         x = "Age Category",
+         y = "Percentage of Users",
+         fill = "Poverty Status"
+     ) +
+     theme_minimal()
> # Binary Logistic Regression
> # Does Income and Health predict Alcohol use in the past month?
> model <- glm(ALCMON ~ INCOME + HEALTH + IRSEX + CATAG6, 
+              data = ds, 
+              family = binomial)
> 
> # View results
> summary(model)

Call:
glm(formula = ALCMON ~ INCOME + HEALTH + IRSEX + CATAG6, family = binomial, 
    data = ds)

Coefficients:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) -1.966846   0.041696 -47.171   <2e-16 ***
INCOME       0.267946   0.007765  34.508   <2e-16 ***
HEALTH      -0.007828   0.004073  -1.922   0.0546 .  
IRSEX       -0.042623   0.017510  -2.434   0.0149 *  
CATAG6       0.313067   0.005697  54.951   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 79916  on 58632  degrees of freedom
Residual deviance: 75273  on 58628  degrees of freedom
AIC: 75283

Number of Fisher Scoring iterations: 4

> 
> # Calculate Odds Ratios for easier interpretation
> exp(coef(model))
(Intercept)      INCOME      HEALTH       IRSEX      CATAG6 
  0.1398974   1.3072763   0.9922025   0.9582722   1.3676138 
> library(tidyverse)
> library(polycor) # Excellent for correlations between categorical variables
> 
> # 1. Filter and Recode
> analysis_df <- ds %>%
+     select(
+         # Opioid Misuse (Pain Relievers)
+         opioid_misuse = PNRNMREC, 
+         # Health Indicators
+         gen_health = HEALTH2,
+         cog_difficulty = LVLDIFMEM2,
+         # Demographic Controls
+         age = CATAG6,
+         poverty = POVERTY3
+     ) %>%
+     mutate(
+         # Recode Opioid Use: 1 = Past Month, 2 = Past Year, 3 = Ever, 8/9/NA = Never/Missing
+         opioid_binary = ifelse(opioid_misuse %in% c(1, 2), 1, 0),
+         
+         # Recode Health: Higher values usually mean worse health in survey codes
+         health_score = as.numeric(gen_health),
+         
+         # Recode Cognitive Difficulty: 1 = Yes, 2 = No
+         mental_fog = ifelse(cog_difficulty == 1, 1, 0)
+     ) %>%
+     filter(!is.na(opioid_binary), !is.na(health_score))
> # Calculate Correlation Matrix for Categorical Data
> # This looks at the strength of the link between Opioid use and Health Status
> cor_matrix <- polychor(analysis_df$opioid_binary, analysis_df$health_score)
> print(paste("Polychoric Correlation:", round(cor_matrix, 3)))
[1] "Polychoric Correlation: 0.189"
> 
> # 3. Visualization: Health Status by Opioid Misuse
> ggplot(analysis_df, aes(x = factor(opioid_binary), fill = factor(gen_health))) +
+     geom_bar(position = "fill") +
+     scale_y_continuous(labels = scales::percent) +
+     scale_fill_brewer(palette = "RdYlGn", direction = -1) +
+     labs(
+         title = "Impact of Opioid Misuse on Self-Reported Health",
+         x = "Opioid Misuse in Past Year (0 = No, 1 = Yes)",
+         y = "Proportion of Population",
+         fill = "Health Rating"
+     ) +
+     theme_minimal()
> # Logistic Regression Model
> # Outcome: Mental/Cognitive Difficulty (mental_fog)
> # Predictor: Opioid Misuse (opioid_binary)
> capstone_model <- glm(mental_fog ~ opioid_binary + age + poverty, 
+                       data = analysis_df, 
+                       family = binomial)
> 
> # Summarize results
> model_summary <- summary(capstone_model)
> print(model_summary)

Call:
glm(formula = mental_fog ~ opioid_binary + age + poverty, family = binomial, 
    data = analysis_df)

Coefficients:
               Estimate Std. Error z value Pr(>|z|)    
(Intercept)   -0.103366   0.029544  -3.499 0.000468 ***
opioid_binary -0.509722   0.050746 -10.044  < 2e-16 ***
age            0.153312   0.005657  27.101  < 2e-16 ***
poverty        0.048030   0.010728   4.477 7.56e-06 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 78068  on 58462  degrees of freedom
Residual deviance: 77144  on 58459  degrees of freedom
  (136 observations deleted due to missingness)
AIC: 77152

Number of Fisher Scoring iterations: 4

> 
> # Calculate Odds Ratios (This is what you report in your project)
> # e.g., "Those misusing opioids are X times more likely to report cognitive distress"
> odds_ratios <- exp(coef(capstone_model))
> print(odds_ratios)
  (Intercept) opioid_binary           age       poverty 
    0.9017970     0.6006626     1.1656892     1.0492021 
> # Load necessary libraries
> library(tidyverse)
> library(polycor) # For categorical correlations
> 
> # Filter and Clean Data
> opioid_mh_data <- ds %>%
+     select(
+         # Opioid variables
+         PNRNMREC, HERREC, 
+         # Mental Health proxies
+         HEALTH2, LVLDIFMEM2,
+         # Contextual variables
+         AGE3, INCOME, ANYHLTI2
+     ) %>%
+     mutate(
+         # Create a binary "Opioid User" variable (1 = Used in past year, 0 = Not)
+         opioid_user = ifelse(PNRNMREC %in% c(1, 2) | HERREC %in% c(1, 2), 1, 0),
+         
+         # Create a binary "Mental Health Distress" variable (using memory/cog difficulty)
+         # 1 = Yes difficulty, 0 = No difficulty
+         mh_distress = ifelse(LVLDIFMEM2 == 1, 1, 0),
+         
+         # Clean General Health (1=Excellent to 5=Poor)
+         health_score = as.numeric(HEALTH2)
+     ) %>%
+     drop_na(opioid_user, mh_distress)
> # 1. Correlation between Opioid Use and Cognitive/Mental Distress
> binary_cor <- tetrachoric(table(opioid_mh_data$opioid_user, opioid_mh_data$mh_distress))
Error in tetrachoric(table(opioid_mh_data$opioid_user, opioid_mh_data$mh_distress)) : 
  could not find function "tetrachoric"

> install.packages("psych")
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding:

https://cran.rstudio.com/bin/windows/Rtools/
Installing package into ‘C:/Users/lrc07/AppData/Local/R/win-library/4.5’
(as ‘lib’ is unspecified)
trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.5/psych_2.5.6.zip'
Content type 'application/zip' length 3594404 bytes (3.4 MB)
downloaded 3.4 MB

package ‘psych’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
	C:\Users\lrc07\AppData\Local\Temp\Rtmp8CCOjh\downloaded_packages
> # 1. Correlation between Opioid Use and Cognitive/Mental Distress
> binary_cor <- tetrachoric(table(opioid_mh_data$opioid_user, opioid_mh_data$mh_distress))
Error in tetrachoric(table(opioid_mh_data$opioid_user, opioid_mh_data$mh_distress)) : 
  could not find function "tetrachoric"

> library(psych)

Attaching package: ‘psych’

The following object is masked from ‘package:polycor’:

    polyserial

The following objects are masked from ‘package:scales’:

    alpha, rescale

The following objects are masked from ‘package:ggplot2’:

    %+%, alpha
> # 1. Correlation between Opioid Use and Cognitive/Mental Distress
> binary_cor <- tetrachoric(table(opioid_mh_data$opioid_user, opioid_mh_data$mh_distress))
> print(paste("Tetrachoric Correlation:", round(binary_cor$rho, 3)))
[1] "Tetrachoric Correlation: -0.132"
> 
> # 2. Correlation between Opioid Use and General Health Score
> # A positive correlation here suggests opioid use is linked to lower health ratings
> health_cor <- polychor(opioid_mh_data$opioid_user, opioid_mh_data$health_score)
> print(paste("Polychoric Correlation (Health):", round(health_cor, 3)))
[1] "Polychoric Correlation (Health): 0.195"
> # Percentage of individuals with Mental/Cognitive Distress by Opioid Use
> opioid_mh_data %>%
+     group_by(opioid_user) %>%
+     summarize(pct_distress = mean(mh_distress) * 100) %>%
+     ggplot(aes(x = factor(opioid_user, labels = c("Non-User", "Opioid User")), 
+                y = pct_distress, fill = factor(opioid_user))) +
+     geom_col(width = 0.6) +
+     labs(
+         title = "Prevalence of Cognitive/Mental Distress by Opioid Use Status",
+         subtitle = "Data source: NSDUH 2024",
+         x = "User Group",
+         y = "Percentage Reporting Distress (%)",
+         fill = "Group"
+     ) +
+     theme_minimal() +
+     scale_fill_manual(values = c("gray70", "firebrick"))
> # Model: Does Opioid Use predict Mental Health Distress?
> # We control for INCOME and AGE3
> model <- glm(mh_distress ~ opioid_user + INCOME + AGE3, 
+              data = opioid_mh_data, 
+              family = binomial)
> 
> # 1. Get the summary
> summary(model)

Call:
glm(formula = mh_distress ~ opioid_user + INCOME + AGE3, family = binomial, 
    data = opioid_mh_data)

Coefficients:
             Estimate Std. Error z value Pr(>|z|)    
(Intercept) -0.324474   0.028594 -11.348   <2e-16 ***
opioid_user -0.528754   0.049958 -10.584   <2e-16 ***
INCOME       0.064350   0.007488   8.594   <2e-16 ***
AGE3         0.092764   0.002815  32.957   <2e-16 ***
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

(Dispersion parameter for binomial family taken to be 1)

    Null deviance: 78304  on 58632  degrees of freedom
Residual deviance: 76987  on 58629  degrees of freedom
AIC: 76995

Number of Fisher Scoring iterations: 4

> 
> # 2. Extract Odds Ratios (Crucial for your report)
> # This tells you: "Opioid users are X times more likely to have MH distress"
> exp(coef(model))
(Intercept) opioid_user      INCOME        AGE3 
  0.7229074   0.5893386   1.0664658   1.0972029 
> # Install necessary packages
> install.packages(c("broom", "sjPlot"))
WARNING: Rtools is required to build R packages but is not currently installed. Please download and install the appropriate version of Rtools before proceeding:

https://cran.rstudio.com/bin/windows/Rtools/
Installing packages into ‘C:/Users/lrc07/AppData/Local/R/win-library/4.5’
(as ‘lib’ is unspecified)
trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.5/broom_1.0.11.zip'
trying URL 'https://cran.rstudio.com/bin/windows/contrib/4.5/sjPlot_2.9.0.zip'
package ‘broom’ successfully unpacked and MD5 sums checked
package ‘sjPlot’ successfully unpacked and MD5 sums checked

The downloaded binary packages are in
	C:\Users\lrc07\AppData\Local\Temp\Rtmp8CCOjh\downloaded_packages
> library(broom)
> library(sjPlot)

Attaching package: ‘sjPlot’

The following object is masked from ‘package:ggplot2’:

    set_theme
> 
> # 1. Tidy the model results (calculating Odds Ratios and CIs)
> # 'model' is the glm object we created in the previous step
> results_tidy <- tidy(model, exponentiate = TRUE, conf.int = TRUE)
> 
> # 2. View a clean table in your RStudio viewer
> tab_model(model, 
+           show.re.var = FALSE, 
+           dv.labels = "Mental Health Distress",
+           string.pred = "Predictors",
+           string.est = "Odds Ratio (OR)")
