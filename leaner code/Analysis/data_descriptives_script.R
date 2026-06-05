################################################################################
### Libraries ##################################################################

rm(list = ls())
dev.off()

################################################################################
### Libraries ##################################################################
library(dplyr) # general pipeline features
library(psych) # describe
library(skimr) # nice descriptives


## bars and charts
library(ggplot2) # nicer plots
library(plotly) # interactive 
library(papaja) # apa formatting visual scatter plots

# correlations
library(corrplot) # visual matrix for correlations



################################################################################
### Call Data ##################################################################
setwd("~/Desktop/Thesis Code/Data/cleaned_new_way")
df <- readRDS("lean_and_mean_final_df.rds")
df<- cbind(id = c(1:nrow(df)), df)

# df_raw <- read.csv("~/Desktop/Thesis Code/Data/N257.csv")
# df_raw <- df_raw[-c(1,2),]
# glimpse(df_raw)
# as.numeric(df_raw$Duration..in.seconds.) %>% median / 60 # median questionnaire completion time

describe(df)
skim(df)



#plot( as.numeric(df$ses_woa_avg) ~ as.numeric(df$ses_subjective), col = "blue")
# is consistent


# # data adjustments: dropping na row entirely
# df_no_na <- df %>% na.omit() # general
# df_no_na %>% nrow

# id 116 is sus, no education, undisclosed, born abroad, and very low view of themselves ses wise and lives in an above avg neighb, might be real # very odd though
# id 190 is sus, 
# id 102 is sus, has 0 depression yet ses woa score is extremely low, and has a high income, seems like a real user but the depression score makes no sense
# id 123 is sus, has low depression lives in a wealthy neighbourhood yet has a subjective ses score of 3
# id 44 is us, 



# golden cage phenomenon? depression and ses

################################################################################
### Depression #################################################################


p1 <- ggplot(data = df, aes(x = ses_subjective_num, y = dep_sum, text = id)) + 
  geom_jitter(alpha = 0.6) +
  geom_smooth( method = 'lm', color = 'red', se = F) +
  labs(x = "ses subjective", y = 'depression') + 
  papaja::theme_apa()
ggplotly(p1)



p1.1 <- ggplot(data = df, aes(x = ses_woa_avg, y = dep_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'ses-woa', y = 'depression') + 
  papaja::theme_apa()
ggplotly(p1.1)

p1.2.a <-  ggplot(data = df, aes(x = sup_esc_sum, y = dep_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'suppressive escapism', y = 'depression') +
  papaja::theme_apa()
ggplotly(p1.2.a)


p1.2.b <- ggplot(data = df, aes(x = as.numeric(exp_esc_sum), y = dep_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = "lm", color = "red", se = F) +
  labs(x = 'expansive escapism', y = 'depression') +
  papaja::theme_apa()
ggplotly(p1.2.b)

p1.3 <- ggplot(data = df, aes(x = as.numeric(mal_env_sum), y = dep_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color ="red", se = F ) +
  labs(x = 'malicious envy', y = 'depression') +
 papaja:: theme_apa()
ggplotly(p1.3)


p1.4 <- ggplot(data = df, aes(x = age, y = dep_sum, text = id)) +
  geom_jitter(alpha = 0.6, width = 0.3) +
  geom_smooth(method = 'lm', color = 'red', se =F) +
  labs(x = 'age', y = 'depression') +
  papaja::theme_apa()
ggplotly(p1.4)


p1.5 <- df %>% 
  filter(!personal_income %in% c("income_pns", 'income_na')
) %>%
  ggplot(aes(x = as.numeric(personal_income), y = dep_sum, text = id)) +
  geom_jitter(alpha = 0.6, width = 0.3) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'personal income', y = 'depression') +
  papaja::theme_apa()
ggplotly(p1.5)


subplot(p1, p1.1, p1.2.a, p1.2.b, p1.3, p1.4, p1.5, nrows = 3, margin = 0.05, titleX = T, titleY = T)

################################################################################
### Sup Escapism ###############################################################

p2 <- ggplot(data = df, aes(x = as.numeric(sm_frequency), y = sup_esc_sum, text = id)) +
  geom_jitter(alpha=0.6, width = 0.3) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'sm frequency', y = 'sup escapism') +
  papaja::theme_apa()
ggplotly(p2)


p2.1.a <- ggplot(data = df, aes(x = as.numeric(mal_env_sum), y = sup_esc_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'malicious envy', y = 'sup escapism') +
  papaja::theme_apa()
ggplotly(p2.1.a)


p2.1.b <- ggplot(data = df, aes(x = as.numeric(ben_env_sum), y = sup_esc_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'benign envy', y = 'sup escapism') +
  papaja::theme_apa()
ggplotly(p2.1.b)


p2.2.a <- ggplot(data = df, aes(x = ses_subjective_num, y = sup_esc_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'ses subjective', y = 'sup escapism')+
  papaja::theme_apa()
ggplotly(p2.2.a)


p2.2.b <- ggplot(data = df, aes(x = as.numeric(ses_woa_avg), y = sup_esc_sum, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'ses-woa', y = 'sup escapism') +
  papaja::theme_apa()
ggplotly(p2.2.b)


p2.3 <- ggplot(df, aes(as.numeric(age), sup_esc_sum, text = id))+
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'age', y = 'sup escapism' ) +
  papaja::theme_apa()
ggplotly(p2.3)
# are young people dishonest, unaware, or do they genuinely engage in a less escapist manner than their older counterparts?
cor.test(df$age, df$sup_esc_sum, method = 'pearson')



p2.4 <- df %>%
  filter(!education %in% c("no_edu_or_primary_edu","edu_pns")) %>%
  ggplot(aes(as.numeric(education), as.numeric(sup_esc_sum), text = id)) +
  geom_jitter(alpha = 0.6, width = 0.3) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'education (excl. na)', y = 'sup escapism') +
  papaja::theme_apa()
ggplotly(p2.4)



p2.5 <- df %>% 
  filter( !personal_income %in% c("income_pns", 'income_na')) %>%
  ggplot(aes(as.numeric(personal_income), as.numeric(sup_esc_sum), text = id)) +
  geom_jitter(alpha = 0.6, width = 0.3) +
  geom_smooth(method = 'lm', color = "red", se = F) +
  labs(x = 'personal income (excl. pns & na)', y = 'sup escapism') +
  papaja::theme_apa()
ggplotly(p2.5)


subplot(p2, p2.1.a, p2.1.b, p2.2.a, p2.2.b, p2.3, p2.4,p2.5, nrows = 3, margin = 0.05, titleX = T, titleY = T)


################################################################################
### SM Frequency ###############################################################

p3 <- ggplot(df, aes(as.numeric(age), as.numeric(sm_frequency), text = id)) +
  geom_jitter(alpha = 0.6, width = 0, height = 0.2) +
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x = 'age', y = 'sm frequecny') +
  papaja::theme_apa()
ggplotly(p3)

p3.1 <- ggplot(df, aes(as.numeric(ses_subjective), as.numeric(sm_frequency), text = id)) +
  geom_jitter(alpha = 0.6, width = 0.2, height = 0.2)+
  geom_smooth(method = 'lm', color = 'red', se = F) +
  labs(x ='ses subjective', y = 'sm frequency') +
  papaja::theme_apa()
ggplotly(p3.1)


p3.2 <- df %>%
  filter(!education %in% "edu_na") %>%
  ggplot(aes(education_num, as.numeric(sm_frequency), text = id)) +
  geom_jitter(alpha = 0.6, width = 0.2, height = 0.2) +
  geom_smooth(method = 'lm', col = 'red', se = F) +
  labs(x = 'education (excl. na)', y = 'sm frequency') +
  papaja::theme_apa()
ggplotly(p3.2)


p3.3 <- df %>%
  filter(!personal_income %in% c('income_na', 'income_pns') ) %>%
  ggplot(aes(personal_income_num, as.numeric(sm_frequency), text = id)) +
  geom_jitter(alpha = 0.6, width = 0.2, height = 0.3) +
  geom_smooth(method = 'lm', col = 'red', se = F) +
  labs(x = 'personal income (excl. pns & na)', y = 'sm frequency') +
  scale_x_continuous(labels = label_number(scale_cut = cut_short_scale())) +
  papaja::theme_apa()
ggplotly(p3.3)


subplot(p3,p3.1,p3.2,p3.3, nrows = 2, margin = 0.05, titleX =  T, titleY = T)

################################################################################
# ses subjective vs ses woa ####################################################

p4 <- df %>%
  ggplot(aes(x = ses_woa_avg, y = ses_subjective_num, text = id)) +
  geom_jitter(alpha = 0.6) +
  geom_smooth(method = "lm", se = F, color = "red") +
  labs(x = "ses-woa", y = "ses subjective") +
  papaja::theme_apa()
ggplotly(p4)


################################################################################
### Combined Supblot Panel #####################################################

subplot(p1, p1.1, p1.2.a, p1.2.b, p1.3, p1.4, p1.5,
        p2, p2.1.a, p2.1.b, p2.2.a, p2.2.b, p2.3, p2.4,p2.5,
        p3,p3.1,p3.2,p3.3,
        p4,
        nrows = 5,
        titleX = T, titleY = T,
        margin = 0.06
)









################################################################################
### General Descriptives ######################################################

df$mal_env_sum %>% describe
df$ben_env_sum %>% describe

df$ses_subjective_num %>% hist

 cor(df$ses_subjective_num, df$ses_woa_avg, method = "spearman", use = "pairwise.complete.obs")

################################################################################
### gender differences?! #######################################################

fem <- df %>% filter(gender == "female" )
mal <- df %>% filter(gender == "male")


fem$education_num %>% describe
mal$education_num %>% describe


fem$personal_income_num %>% describe
mal$personal_income_num %>% describe
fem$personal_income_num %>% summary
mal$personal_income_num %>% summary

fem$ses_subjective_num %>% describe
mal$ses_subjective_num %>% describe

fem$sm_frequency %>% describe
mal$sm_frequency %>% describe

fem$sup_esc_sum %>% describe
fem$exp_esc_sum %>% describe()

mal$sup_esc_sum %>% describe
mal$exp_esc_sum %>% describe

fem$dep_sum %>% describe
mal$dep_sum %>% describe()

head(sort(df$dep_sum ,decreasing = T, n=5))

df %>% slice_max(df$dep_sum, n =5) # are more men or more women depression outliers?

################################################################################
### GG boxplots (gender) #######################################################

g_df <- df

g_df <- g_df %>% mutate(
  Gender = case_match(gender,
                      "male" ~ "M",
                      "female" ~ "F",
                      "non_binary" ~ "NB",
                      NA ~ "NA",
                      .default = gender)
)

g_df <-  g_df  %>% filter(!Gender %in% c("NA","NB"))


b1 <- g_df %>% filter(!personal_income %in% c("income_pns", "income_na")) %>%
  ggplot(aes(x = Gender, y = as.numeric(personal_income))) +
  labs(y = 'Personal Income (excl. pns & na)') +
           geom_boxplot() +
  papaja::theme_apa()
b1


b2 <- g_df %>% filter(!education %in% 'edu_pns') %>%
  ggplot(aes(Gender, as.numeric(education))) +
  labs(y = 'Highest Education') +
  geom_violin() +
  geom_jitter(width = 0.3, height = 0.1, alpha = 0.2) +
  papaja::theme_apa()
b2

df %>% group_by(gender) %>% # the boxplot looked odd for female, the median was hidden withing the q75 range
  summarise( # given that we are dealing only 6 categories and most females are highly educated the b2 plot will use a violin visualisation instead
  count = n(),
  q25 = quantile(as.numeric(education), 0.25, rm.na = T),
  median = median(as.numeric(education), rm.na = T),
  q75 = quantile(as.numeric(education), 0.75, rm.na = T)
) + # look at median and q75 for female
  papaja::theme_apa()


b3 <- ggplot(g_df ,aes(Gender, sup_esc_sum, text = id)) +
  labs(y = 'Suppressive Escapism') +
  geom_boxplot() +
  papaja::theme_apa()
b3

b4 <- ggplot(g_df , aes(Gender, dep_sum)) +
  labs(y = 'Depression') +
  geom_boxplot() +
  papaja::theme_apa()
b4

b5 <- g_df %>% filter(!is.na(ses_woa_avg)) %>%
  ggplot(aes(Gender, as.numeric(ses_woa_avg))) +
  geom_boxplot() +
  labs(y = 'SES-WOA') +
  papaja::theme_apa()
b5

b5.1 <- g_df %>%
  ggplot(aes(Gender, ses_subjective_num)) +
geom_boxplot() +
  labs(y = "Ses Subjecitve") +
  papaja::theme_apa()
b5.1

b6 <- ggplot(g_df, aes(Gender, sm_frequency)) +
  geom_boxplot() +
  labs(y = 'SMU Frequency (between 0 & 5+ hours/d)') +
  papaja::theme_apa()

b7 <- ggplot(g_df, aes(Gender, mal_env_sum)) +
  geom_boxplot() +
  labs(y = 'Malicious Envy') +
  papaja::theme_apa()
b7


subplot(b4,b3,b7,b6,b5,b5.1,b1,b2, nrows = 2, titleX = T, titleY = T, margin = 0.05)



table(df$citi)
table(df$immigration)


################################################################################
#### SES PARADOX descriptives ##################################################

df <- df %>% mutate(
  
  personal_income_short = factor(personal_income,
                                 labels = c('d1','d2','d3','d4','d5','d6','d7','d8','d9','d10','dn','pns','na'),
  ),
  
  urbanity_short = factor(urbanity,
                          label = c("not", "hardly", "moderately", "strongly", "extremely")
  )
)


e <- df %>% filter(!(personal_income) %in% c("income_na","income_pns") & !is.na(urbanity)) %>%
  ggplot(aes(x = personal_income_short, y = ses_subjective_num)) +
  geom_boxplot() +
  labs(x = "personal income (excl. na & pns)", y = "ses subjective") +
  papaja::theme_apa()


z <- df %>% filter(!is.na(urbanity)) %>%
  ggplot(aes(x = urbanity_short, y = ses_subjective_num)) +
  labs(x = "urbanicity", y = "ses subjective") +
  geom_boxplot() + papaja::theme_apa()


p <- df %>% filter(!is.na(urbanity)) %>%
  ggplot(aes(x = urbanity_short, y = personal_income_num)) +
  labs(x = "urbanicity", y = "personal income (excl. na & pns)") +
  geom_boxplot() + papaja::theme_apa()


zz <- df %>% filter(!is.na(urbanity)) %>%
  ggplot(aes(x = urbanity_short, y = ses_woa_avg)) +
  labs(x = "urbanicity", y = "SES-WOA") +
  geom_boxplot() + papaja::theme_apa()

zzz <- df %>% filter(!is.na(urbanity)) %>%
  ggplot(aes(x = urbanity_short, y = sup_esc_sum)) +
  geom_boxplot() +
  labs(x = "urbanicity", y ="suppressive escapism")+
  papaja::theme_apa()

zzzzzz <- df %>% filter(!is.na(urbanity)) %>% 
  ggplot(aes(x = urbanity_short, y = mal_env_sum)) +
  geom_boxplot() +
  labs(x = "urbanicity", y = "malicious envy")+
  papaja::theme_apa()


plotly::subplot(e,z,p,zz,zzz, zzzzzz, nrows = 2, 
                titleX = T, titleY = T,
                margin = 0.05)





################################################################################
#### Spearman Correlational Matrix #############################################

df_cor <- df %>%
  rename(
    "Depression" = dep_sum,
    "Suppressive Escapism" = sup_esc_sum,
    "Expansive Escapism" = exp_esc_sum,
    "Malicious Envy" = mal_env_sum,
    "Benign Envy" = ben_env_sum,
    "SMU Frequency" = sm_frequency,
    "SES-WOA" = ses_woa_avg,
    "SES Subjective" = ses_subjective_num,
    "Education" = education_num,
    "Personal Income" = personal_income_num,
    "Age" = age
         )


cor_vars_df <- df_cor[, c("Depression", "Suppressive Escapism", "Expansive Escapism", "Malicious Envy", "Benign Envy", 
                      "SMU Frequency", "SES-WOA", "SES Subjective", "Education", "Personal Income", "Age","gender", 
                      "immigration","citi", "urbanity")]


cor_vars_df <- cor_vars_df %>% mutate(
#gender dummies
  "Male" = ifelse(gender == 'male',1,0),
  "Female" = ifelse(gender == 'female',1,0),
  "Non-Binary" = ifelse(gender == 'non_binary',1,0),
  "EU/EEA" = ifelse(citi == 'eu_eea',1,0),
  "Non-EU/EEA" = ifelse(citi == "eu_eea",1,0),
  "Both Parents NL" = ifelse(immigration == "both_parent_nl",1,0),
  "One Parent NL" = ifelse(immigration == "one_parent_nl",1,0),
  "Both Parents Abroad" = ifelse(immigration == "both_parent_abroad",1,0),
  "Born Abroad" = ifelse(immigration == "born_abroad",1,0)
  


  
#urbanicity
  # not_urbanised = ifelse(urbanity == 'not_urbanised',1,0),
  # hardly_urbanised = ifelse(urbanity == 'hardly_urbanised',1,0),
  # moderately_urbanised = ifelse(urbanity == 'moderaterly_urbanised', 1,0),
  # strongly_urbanised = ifelse(urbanity == 'strongly_urbanised', 1,0),
  # extremely_urbanised = ifelse(urbanity == "extremely_urbanised",1,0)
)

glimpse(cor_vars_df)
  
cor_vars_df_select <- cor_vars_df[, c("Depression", "Suppressive Escapism", "Expansive Escapism", "Malicious Envy", "Benign Envy", 
                      "SMU Frequency", "SES-WOA", "SES Subjective", "Education", "Personal Income", "Age",
                               "Male", "Female", "Non-Binary","EU/EEA", "Non-EU/EEA", 
                               "Both Parents NL","One Parent NL", "Both Parents Abroad","Born Abroad")] %>%
  mutate(across(everything(), as.numeric))

glimpse(cor_vars_df)

cor_matrix <- cor(cor_vars_df_select, method = "spearman", use = "pairwise.complete.obs")
significance_matrix <- cor.mtest(cor_vars_df_select, confint = 0.95)


#### Simple one sided

corrplot(cor_matrix, method = 'pie', type = 'lower', tl.col = "black", 
         p.mat = significance_matrix$p, insig = 'label_sig', sig.level = c(0.001, 0.01, 0.05), pch.cex = 1.7,
         title = "Spearman Pairwise Correlation Matrix (with significance)", tl.srt = 45,  mar = c(0,0,1,0))



##### Mixed Corrplot

par(mar = c(0,0,0,0))
corrplot(cor_matrix,
         title = "Digital Pathways: Spearman Rank Correlation Matrix (with significance)", 
         method = "shade",
         type = "upper",
         
         
         tl.srt = 45,
         tl.col = "black",
         tl.cex = 1,
         
         
         p.mat = significance_matrix$p,
         insig = "label_sig",
         sig.level = c(0.001, 0.01, 0.05),
         pch.cex = 1,
         pch.col = "black",
         
         
         diag = T, # Removes the 1.00 diagonal lines
         
         tl.pos = "tp",
         cl.pos = "r",
         mar = c(0,0,3,0),
         
         
)

corrplot(cor_matrix, 
         method = "number", 
         col = "black",
         number.cex = 0.8,
         
         type = "lower",

         add = T, # to add to the first plot
         
         diag = F,
         
         
         tl.pos = "n",
         cl.pos = "n",
         mar = c(0,0,3,0),
         
         
)


### APA output #################################################################

#apa.cor.table(cor_vars_df, show.sig.stars = TRUE, filename = "~/Desktop/Thesis Code/Table_Spearman.doc")

### to big

################################################################################
### network graph ##############################################################

# While searching for exploratory patterns I wanted to see whether a newtork graph would be more illustrative

library(dplyr) 
library(ggplot2)
library(igraph) #graph_from_adjacency_matrix() 
library(ggraph)
library(tidygraph) # as_tbl_graph()

#??ggraph

g <- graph_from_adjacency_matrix(cor_matrix, 
                                 mode = "undirected",
                                 weighted = T,
                                 diag = F) %>% 
  as_tbl_graph()

#??igraph::graph

filtered_graph <- g %>%
  activate(edges) %>%
  filter(abs(weight) > 0.17)

ggraph(filtered_graph, layout = 'stress') +
  geom_edge_link(aes(edge_width = abs(weight), edge_alpha = abs(weight)), color = "red4") +
geom_node_point(size = 4, color = "blue") +
  geom_node_text(aes(label = name), repel = TRUE, size = 3) +
  theme_void() +
  theme(legend.position = "none")


################################################################################
### Basic   distributions ######################################################

attach(df)

### Depression
par(mfrow = c(1,2))
hist(dep_sum)
qqnorm(dep_sum)
qqline(dep_sum, col = "red", lwd = 2)


#### Digital Pathways and SES

par(mfrow = c(2,4))
hist(dep_sum)
abline(v = mean(dep_sum), col = "red", lwd = 2)
abline(v = median(dep_sum), col = "blue", lwd = 2, lty = 2)

hist(mal_env_sum)
abline(v = mean(mal_env_sum), col= "red", lwd = 2)
abline(v = median(mal_env_sum), col= "blue", lwd = 2, lty = 2)

hist(ben_env_sum)
abline(v = mean(ben_env_sum), col = "red", lwd = 2)
abline(v = median(ben_env_sum), col = 'blue', lwd = 2, lty = 2)

hist(sup_esc_sum)
abline(v = mean(sup_esc_sum), col = "red", lwd = 2)
abline(v = median(sup_esc_sum), col = 'blue', lwd = 2, lty = 2)

hist(exp_esc_sum)
abline(v = mean(exp_esc_sum), col = "red", lwd = 2)
abline(v = mean(exp_esc_sum), col = "blue", lwd = 2, lty = 2)

hist(as.numeric(ses_woa_avg))
abline(v = mean(as.numeric(ses_woa_avg), na.rm = T), col = "red", lwd = 2)
abline(v = median(as.numeric(ses_woa_avg), na.rm = T), col = "blue", lwd = 2, lty = 2)

hist(as.numeric(ses_subjective))
abline(v = mean(as.numeric(ses_subjective)), col = "red", lwd = 2)
abline(v = median(as.numeric(ses_subjective)), col= "blue", lwd = 2, lty = 2)

hist(sm_frequency, breaks = 6)
abline(v = mean(sm_frequency), col = "red", lwd = 2)
abline(v = median(sm_frequency), col = "blue", lwd=2, lty = 2)




#### demographics
par(mfrow = c(1,3))
 
hist(age)
abline(v = mean(age), col = "red", lwd = 2)
abline(v = median(age), col = "blue", lwd = 2, lty = 2)
 
hist(education_num)
abline(v = mean(education_num, na.rm = T), col = "red", lwd = 2)
abline(v = mean(education_num, na.rm = T), col = "blue", lwd = 2, lty = 2)

hist(personal_income_num)
abline(v = mean(personal_income_num, na.rm = T), col = "red", lwd = 2)
abline(v = median(personal_income_num, na.rm = T), col = "blue", lwd = 2, lty = 2)

