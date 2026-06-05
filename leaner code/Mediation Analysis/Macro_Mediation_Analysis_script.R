#### IN ORDER TO RUN THE MEDIATON MODEL YOU WILL NEED TO RUN
#### THE ENTIRE process.R SCRIPT FILE AT ONCE (find within folder called "PROCESS v4.3 for R")
#### STEP 1: OPEN THE process.R file
#### STEP 2: SELECT ALL, THEN RUN ALL AT ONCE
#### STEP 3: COME BACK TO THIS SCRIPT AND RUN THE MODELS BELOW


################################################################################
#### Mediation Analysis ########################################################
rm(list = ls())
dev.off()
### libs
library(dplyr)

setwd("~/Desktop/Thesis Code/Data/cleaned_new_way/")
df <- readRDS("lean_and_mean_final_df.rds")


################################################################################
#### Reconfiguring categories ##################################################

#### Hayes doesnt take factors, so we will need to code categories manually.

# dropping PNS row

df <- df[-c(65) ,] # outlier
df <- df %>% filter(!gender == is.na(gender))

df$citi_num <- as.numeric(df$citi) - 1

df <- df %>% mutate(
  female = ifelse(gender == "female",1,0),
  male = ifelse(gender == "male", 1,0),
  non_binary = ifelse(gender == "non_binary",1,0),
  
  both_parent_nl = ifelse(immigration == "both_parent_nl",1,0),
  one_parent_nl = ifelse(immigration == "one_parent_nl",1,0),
  both_parent_abroad = ifelse(immigration == "both_parent_abroad",1,0),
  born_abroad = ifelse(immigration == "born_abroad",1,0)
)


################################################################################
#### Run the models ############################################################

mal_sup_dep_med <- process(data = df, seed = 619998,
                           y = "dep_sum", x ="mal_env_sum", m = "sup_esc_sum",
                           cov = c("ses_subjective_num","ses_woa_avg","sm_frequency", 
                                   "age", "female", "male",
                                   "one_parent_nl","both_parent_abroad","born_abroad"),
                           hc = 4,
                           model = 4, 
                           total = 1, 
                           effsize = 1,
                           boot = 5000)





ben_exp_dep_med <- process(data = df, seed = 701817,
                           y = "dep_sum", x ="ben_env_sum", m = "exp_esc_sum",
                           cov = c("ses_subjective_num","ses_woa_avg","sm_frequency", 
                                   "age", "female", "male",
                                   "one_parent_nl","both_parent_abroad","born_abroad"),
                           hc = 4,
                           model = 4,
                           total = 1,
                           effsize = 1,
                           boot = 5000)



################################################################################
#### Cross Check  ##############################################################

# check a-path and indirect ab-path

mal_exp_dep_med <- process(data = df,
                           y = "dep_sum", x ="mal_env_sum", m = "exp_esc_sum",
                           cov = c("ses_subjective_num","ses_woa_avg","sm_frequency", 
                                   "age", "female", "male",
                                   "one_parent_nl","both_parent_abroad","born_abroad"),
                           hc = 4,
                           model = 4, 
                           total = 1, 
                           effsize = 1,
                           boot = 5000) 


ben_sup_dep_med <- process(data = df,
                           y = "dep_sum", x ="ben_env_sum", m = "sup_esc_sum",
                           cov = c("ses_subjective_num","ses_woa_avg","sm_frequency", 
                                   "age", "female", "male",
                                   "one_parent_nl","both_parent_abroad","born_abroad"),
                           hc = 4,
                           model = 4,
                           total = 1,
                           effsize = 1,
                           boot = 5000)

