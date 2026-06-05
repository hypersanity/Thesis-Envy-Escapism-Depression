rm(list = ls())
dev.off()

####
df_2 <- readRDS("~/insert directory/cronbachs_alpha_df.rds") # uses a dataset that includes individual item scores
df_2 %>% glimpse


attach(df_2) 
library(apaTables) # for table
library(rempsyc) # for table 
library(flextable) # rempsyc needs

df_2 %>% nrow

# dep

dep <- tibble(dep_q1, dep_q2, dep_q3, dep_q4, dep_q5, dep_q6, dep_q7)
glimpse(dep)
dep_alpha <- psych::alpha(dep) 

# sup esc
sup <- tibble(sup_esc_q1, sup_esc_q2, sup_esc_q3, sup_esc_q4)
glimpse(sup)
sup_alpha <- psych::alpha(sup)

# exp esc
exp <- tibble(exp_esc_q1, exp_esc_q2, exp_esc_q3, exp_esc_q4)
exp <- exp %>% mutate(
  across(everything(),as.numeric))
exp_alpha <- psych::alpha(exp)
glimpse(exp)

# mal
mal <- tibble(mal_env_q1, mal_env_q2, mal_env_q3, mal_env_q4, mal_env_q5)
mal <- mal %>%  mutate(across(everything(), as.numeric))
glimpse(mal)
mal_alpha <- psych::alpha(mal)

# ben
ben <- tibble(ben_env_q1, ben_env_q2, ben_env_q3, ben_env_q4, ben_env_q5)
ben <- ben %>% mutate(across(everything(), as.numeric))
glimpse(ben)
ben_alpha <- psych::alpha(ben)


### check
dep_alpha$total %>% round(2)

sup_alpha$total %>% round(2)
exp_alpha$total %>% round(2)

mal_alpha$total %>% round(2)
ben_alpha$total %>% round(2)


### merge
a_total_df <- rbind(dep_alpha$total, sup_alpha$total, exp_alpha$total, mal_alpha$total, ben_alpha$total) %>% 
  round(2)
a_total_df <- a_total_df %>% subset(select = c("mean","sd","raw_alpha"))

vars <- c("Depression", "Suppressive Escapism", "Expansive Escapism", "Malicious Envy", "Benign Envy")
item_no <- c(7,4,4,5,5) %>% as.integer

alpha_df <- cbind(vars, item_no, a_total_df)

View(alpha_df)


### table
nice_table(alpha_df)

## export
#flextable::save_as_docx(nice_table(alpha_df), path = "~/Desktop/Thesis Code/Tables.docx")