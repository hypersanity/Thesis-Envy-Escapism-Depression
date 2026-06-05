################################################################################
#### Multiple Regression Model #################################################
rm(list = ls())
dev.off()


################################################################################
### libs #######################################################################
library(dplyr)
library(psych)


################################################################################
#### Data  #####################################################################
setwd("~/Desktop/Thesis Code/Data/cleaned_new_way")
df <- readRDS("lean_and_mean_final_df.rds")


################################################################################
#### Base Model ################################################################

base_mod <- lm(dep_sum ~ sup_esc_sum  + ses_woa_avg  + ses_subjective_num, df)
summary(base_mod)

### Assumptions

# visual check basic
par(mfrow = c(2,3))
plot(base_mod)
plot(base_mod, which = 4)

# normal
shapiro.test(base_mod$residuals)

# homo
car::ncvTest(base_mod) # basically bg test
skedastic::white(base_mod) # polynomial heteroskedasticity

# multicol
car::vif(base_mod)

# auto kinda unnecessary
par(mfrow = c(1,1))
acf(base_mod$residuals)
lmtest::dwtest(base_mod)


# outlier
par(mfrow= c(1,2))
plot(base_mod, which = c(4,5))


df[rownames(df) == '65',] # check outliers
df[rownames(df) == '44',]
df[rownames(df) == '181',]

#### remove worst outlier
df_r65 <- df[-c(65),]

################################################################################
#### Full Model ################################################################

base_mod_r65_full <- lm(dep_sum ~ sup_esc_sum + ses_subjective_num + ses_woa_avg + sm_frequency + age + gender + citi + immigration , df_r65)
summary(base_mod_r65_full)

par(mfrow = c(2,2))
plot(base_mod_r65_full)


################################################################################
#### Reverse Causality (Assumption Check)#######################################

reverse_mod_r65_full <- lm(sup_esc_sum ~ dep_sum + ses_subjective_num + ses_woa_avg + sm_frequency + age + gender + citi + urbanity , df_r65)
summary(reverse_mod_r65_full)

par(mfrow =c(2,2))
plot(reverse_base_mod_r65_full)

shapiro.test(reverse_base_mod_r65_full$residuals)

car::ncvTest(reverse_base_mod_r65_full)
skedastic::white(reverse_base_mod_r65_full)
lmtest::bptest(reverse_base_mod_r65_full)

car::vif(reverse_base_mod_r65_full)



################################################################################
#### Ordinal Logistic Regression (SES Paradox)##################################

# THIS PART WAS EXPLORATORY BUT I WAS NOT ABLE TO FIND ANYTHING SIGNIFICANT.

# MY IDEA WAS TO PREDICT SES SUBJECTIVE SCORES BASED ON INCOME AND MALICIOUS
# ENVY SELF-RATINGS


##### ordinal logistic regression
# https://www.youtube.com/watch?v=rrRrI9gElYA
# interpreting likelihood ratio test statistic https://pmc.ncbi.nlm.nih.gov/articles/PMC478236/

library(ordinal) #clm


df_missingness_adjustment <- df %>% filter(!is.na(personal_income_num))
df_missingness_adjustment <- df_missingness_adjustment %>% filter(!is.na(gender))
df_missingness_adjustment <- df_missingness_adjustment %>% filter(!is.na(urbanity))


# baseline
Null_model <- ordinal::clm(ses_subjective ~ 1, 
                           data = df_missingness_adjustment, 
                           link = "logit")
summary(Null_model)


# full model
ordinal_1 <- ordinal::clm(ses_subjective ~ personal_income_num + mal_env_sum + urbanity + age + gender, data = df_missingness_adjustment, Hess = T)
summary(ordinal_1)

# goodness of fit
anova(Null_model, ordinal_1)
#install.packages("performance")

# multicolinearity
performance::check_collinearity(ordinal_1) # moderate correlation comes from the interaction effect

# CIs
sjPlot::plot_model(ordinal_1) # personal income is not computed correctly

## exploding CIs at the higher end (l9, l10)

table(df_missingness_adjustment$ses_subjective)


## merge l9 and l10
df_missingness_adjustment<- df_missingness_adjustment %>% mutate(
  ses_sub_m = case_match(ses_subjective,
                         c("l10","l9", "l8") ~ "lmax",
                         c("l1","l2","l3","l4") ~  "lmin",
                         .default = ses_subjective)
)

table(df$ses_subjective)

df_missingness_adjustment <- df_missingness_adjustment %>% filter(personal_income_num < 7000)
df_missingness_adjustment$personal_income_num %>% unique

df_missingness_adjustment <- df_missingness_adjustment %>% mutate(personal_income_num_small = personal_income_num / 100)
View(df_missingness_adjustment)

# retest 
Null_model_2 <- ordinal::clm(as.factor(ses_sub_m) ~ 1,
                             data = df_missingness_adjustment,
                             link = "logit")

ordinal_2 <- ordinal::clm(as.factor(ses_sub_m) ~ personal_income_num_small + mal_env_sum + urbanity + age + gender, data = df_missingness_adjustment)
summary(ordinal_2)


anova(ordinal_2, Null_model_2)

# testing for multicolinearity
fake_ordinal_1 <- lm(ses_subjective ~ personal_income_num + mal_env_sum + age + gender, data = df_missingness_adjustment)
car::vif(fake_ordinal_1, type = "predictor")

