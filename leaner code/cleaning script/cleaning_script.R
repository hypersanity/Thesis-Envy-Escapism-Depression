################################################################################
#### Flush #####################################################################
rm(list = ls(all.names = T))
#dev.off()

################################################################################
#### call Dataframe ############################################################

library(dplyr) #
library(here) # had some problems with my directory.
library(skimr) # honestly, better than the glimpse or head function (e.g. info such as coverage)
library(psych) # not only for cronbach's alpha but describe() is also more comprehensive than summary() 
library(janitor) # for the open questions

################################################################################
#### call Dataframe ############################################################

setwd("~/Desktop/Thesis Code/Data")
df <- read.csv("N257.csv")

glimpse(df)

df_trim <- df[-c(1,2,217),-c(1:13, 60:64)] # observation 217 is do not consent response
glimpse(df_trim)

#View(df_trim)

################################################################################
#### Renaming ##################################################################

df_rename <- df_trim %>% rename(
  age = Q5,
  gender = Q6,
  citi = Q7,
  immigration = Q25,
  education = Q8,
  personal_income = Q9,
  postcode = QID11,
  residency = QID15,
  ladder_1 = QID13_10, # qualtrics had it reverse.
  ladder_2 = QID13_9,
  ladder_3 = QID13_8,
  ladder_4 = QID13_7,
  ladder_5 = QID13_6,
  ladder_6 = QID13_5,
  ladder_7 = QID13_4,
  ladder_8 = QID13_3,
  ladder_9 = QID13_2,
  ladder_10 = QID13_1,
  sm_frequency = QID12,
  sm_types = QID44,
  ben_env_q1 = QID17_1,
  ben_env_q2 = QID17_2,
  ben_env_q3 = QID17_3,
  ben_env_q4 = QID17_4,
  ben_env_q5 = QID17_5,
  mal_env_q1 = QID31_1,
  mal_env_q2 = QID31_2,
  mal_env_q3 = QID31_3,
  mal_env_q4 = QID31_4,
  mal_env_q5 = QID31_5,
  sup_esc_q1 = QID22_1,
  sup_esc_q2 = QID22_2,
  sup_esc_q3 = QID22_3,
  sup_esc_q4 = QID22_4,
  exp_esc_q1 = QID37_1,
  exp_esc_q2 = QID37_2,
  exp_esc_q3 = QID37_3,
  exp_esc_q4 = QID37_4,
  reason_beyond_dp = QID29,
  dep_q1 = QID30_1,
  dep_q2 = QID30_2,
  dep_q3 = QID30_3,
  dep_q4 = QID30_4,
  dep_q5 = QID30_5,
  dep_q6 = QID30_6,
  dep_q7 = QID30_7
)
df_rename %>% glimpse

glimpse(df_rename)
skim(df_rename)

# checkpoint
saveRDS(df_rename, "cleaned_new_way/trimmed_renamed_data_207.rds")


################################################################################
#### Demographics ##############################################################


df <- readRDS("cleaned_new_way/trimmed_renamed_data_207.rds")
skim(df)

clean_df <- df %>% mutate( # gender dummies
  gender = factor(gender,
  levels = c(1,2,3),
  labels = c('male','female','non_binary')
  ),
  citi = factor(citi,
                levels = c(1,2),
                labels = c('eu_eea','non_eu_eea')
                ),
  immigration = factor(immigration,
                       levels = c(1,2,3,4),
                       labels = c('both_parent_nl','one_parent_nl','both_parent_abroad','born_abroad')
                       ),
  residency = factor(residency,
                     levels = c(1,2),
                     labels = c("6_months","under_6_months")
                     ),
  education = factor(education,
                     levels = c(1,2,3,4,5,6,7),
                     labels = c('no_edu_or_primary_edu','vmbo_mavo','havo_vwo','mbo','hbo','wo','edu_pns'),
                     ordered = TRUE
                     ),
  personal_income = factor(personal_income,
                           levels = c(1,2,3,4,5,6,7,8,9,10,11,12,13),
                           labels = c('decile_1','decile_2','decile_3','decile_4','decile_5','decile_6','decile_7','decile_8','decile_9','decile_10','decile_omega','income_pns','income_na'),
                           ordered = TRUE
                           ),
  age = as.numeric(age),
# consistent with Brown & Toyama's coding  
  sm_frequency = case_match(
    sm_frequency,
    '1' ~ 0,
    '2' ~ 0.5,
    '3' ~ 1.5,
    '4' ~ 2.5,
    '5' ~ 3.5,
    '6' ~ 4.5,
    '7' ~ 5.5,
    .default = NA_real_
  )
)


clean_df <- clean_df %>% mutate(
   personal_income_num = case_match(
     personal_income,
    'decile_1' ~ 300/2,
    'decile_2' ~ (301+1100)/2,
    'decile_3' ~ (1101+1600)/2,
    'decile_4' ~ (1601+2100)/2,
    'decile_5' ~ (2101+2600)/2,
    'decile_6' ~ (2601+3200)/2,
    'decile_7' ~ (3201+3800)/2,
    'decile_8' ~ (3801+4600)/2,
    'decile_9' ~ (4601+5700)/2,
    'decile_10'~ (5701+8400)/2,
    'decile_omega' ~ 8400*1.5,
    'income_pns' ~ NA_real_,
    'income_na' ~ 0,
     .default = NA_real_
  )
) %>% relocate(personal_income_num, .before = personal_income)



clean_df <- clean_df %>% mutate(
  education_num = case_match(
   education,
   'no_edu_or_primary_edu' ~ 1,
   'vmbo_mavo' ~ 2,
   'havo_vwo' ~ 3,
   'mbo' ~ 4,
   'hbo' ~ 5,
   'wo' ~ 6,
   'edu_pns' ~ NA_real_,
   .default = NA_real_
  )
) %>% relocate(education_num, .before = education)


#View(clean_df)

################################################################################
#### Digital Pathways ##########################################################


# malicious envy
clean_df <- clean_df %>% mutate(
   mal_env_sum = rowSums(
  across(
  c(mal_env_q1,mal_env_q2,mal_env_q3,mal_env_q4,mal_env_q5), as.numeric
  )
   )
) %>% relocate(mal_env_sum, .before = sup_esc_q1)

# benign envy
clean_df <- clean_df %>% mutate(
  ben_env_sum = rowSums(
    across(
      c(ben_env_q1,ben_env_q2,ben_env_q3,ben_env_q4,ben_env_q5), as.numeric
    )
  )
) %>% relocate(ben_env_sum, .before = mal_env_q1)


clean_df <- clean_df %>% mutate(
  across(c(ben_env_q1,ben_env_q2,ben_env_q3,ben_env_q4,ben_env_q5), as.numeric),
  ben_env_q1 = 8 - ben_env_q1,
  ben_env_q2 = 8 - ben_env_q2,
  ben_env_q3 = 8 - ben_env_q3,
  ben_env_q4 = 8 - ben_env_q4,
  ben_env_q5 = 8 - ben_env_q5
) %>% mutate(
  ben_env_sum = rowSums(
    across(c(ben_env_q1,ben_env_q2,ben_env_q3,ben_env_q4,ben_env_q5))
  )
) %>% relocate(.before = mal_env_q1)


# suppressive escapism 
clean_df <- clean_df %>% mutate(
  across(c(sup_esc_q1,sup_esc_q2,sup_esc_q3,sup_esc_q4), as.numeric),
    sup_esc_q1 = 8 - sup_esc_q1,
    sup_esc_q2 = 8 - sup_esc_q2,
    sup_esc_q3 = 8 - sup_esc_q3,
    sup_esc_q4 = 8 - sup_esc_q4
  ) %>% mutate(
    sup_esc_sum = rowSums(
      across(c(sup_esc_q1, sup_esc_q2, sup_esc_q3, sup_esc_q4))
    )
  ) %>% relocate(sup_esc_sum, .before = exp_esc_q1)


### expansive escapism
clean_df <- clean_df %>% mutate(
  exp_esc_sum = rowSums(
    across(
      c(exp_esc_q1,exp_esc_q2,exp_esc_q3,exp_esc_q4), as.numeric
    )
  )
) %>% relocate(exp_esc_sum, .before = reason_beyond_dp)


par(mfrow = c(1,4))
as.numeric(clean_df$sup_esc_q1) %>% hist()
as.numeric(clean_df$sup_esc_q2) %>% hist()
as.numeric(clean_df$sup_esc_q3) %>% hist()
as.numeric(clean_df$sup_esc_q4) %>% hist()
# all the shapes look similar

as.numeric(clean_df$sup_esc_q1) %>% describe # check
as.numeric(clean_df$sup_esc_q2) %>% describe # check
as.numeric(clean_df$sup_esc_q3) %>% describe # check
as.numeric(clean_df$sup_esc_q4) %>% describe # check
# good to go

################################################################################
#### Depression ################################################################

clean_df <- clean_df %>% mutate(
  across(
    c(dep_q1,dep_q2,dep_q3,dep_q4,dep_q5,dep_q6,dep_q7), as.numeric
  ) %>% mutate(
    dep_q1_t = (dep_q1-1), # qualtrics did not apply my 0-3 coding so i have to subtract each score by -1
    dep_q2_t = (dep_q2-1),
    dep_q3_t = (dep_q3-1),
    dep_q4_t = (dep_q4-1),
    dep_q5_t = (dep_q5-1),
    dep_q6_t = (dep_q6-1),
    dep_q7_t = (dep_q7-1),
    dep_q1_x2 = (dep_q1-1) *2, # Lovibond & Lovibond 1995 insist to double each item score
    dep_q2_x2 = (dep_q2-1) *2, # Brown & Toyama 2025 have applied it as well
    dep_q3_x2 = (dep_q3-1) *2,
    dep_q4_x2 = (dep_q4-1) *2,
    dep_q5_x2 = (dep_q5-1) *2,
    dep_q6_x2 = (dep_q6-1) *2,
    dep_q7_x2 = (dep_q7-1) *2
  )
) %>% mutate( # the outcome variable for regression and mediation below
  dep_sum = rowSums(
    across(
      c(dep_q1_x2,dep_q2_x2,dep_q3_x2,dep_q4_x2,dep_q5_x2,dep_q6_x2,dep_q7_x2)
    )
  )
)



### checkpoint
saveRDS(clean_df, "cleaned_new_way/demographics_digital_pathways_depression.rds")
clean_df <- readRDS("cleaned_new_way/demographics_digital_pathways_depression.rds")


#View(clean_df)


################################################################################
#### SES subjective ############################################################

glimpse(clean_df)

clean_df <- clean_df %>%
  mutate(
    l1 = ifelse(ladder_1 == "On", 1,0),
    l2 = ifelse(ladder_2 == "On", 2,0),
    l3 = ifelse(ladder_3 == "On", 3,0),
    l4 = ifelse(ladder_4 == "On", 4,0),
    l5 = ifelse(ladder_5 == 'On', 5,0),
    l6 = ifelse(ladder_6 == 'On', 6,0),
    l7 = ifelse(ladder_7 == 'On', 7,0),
    l8 = ifelse(ladder_8 == 'On', 8,0),
    l9 = ifelse(ladder_9 == 'On', 9,0),
    l10 = ifelse(ladder_10 == 'On', 10,0),
  ) %>% mutate(
    ses_subjective_num = pmax(l1,l2,l3,l4,l5,l6,l7,l8,l9,l10)
  ) %>% mutate(
    ses_subjective = factor(ses_subjective_num,
      levels = c(1:10),
      labels = c("l1",'l2','l3','l4','l5','l6','l7','l8','l9','l10')
    )
  ) %>% select(-c(l1,l2,l3,l4,l5,l6,l7,l8,l9,l10, ladder_1, ladder_2, ladder_3, ladder_4, ladder_5, ladder_6, ladder_7, ladder_8, ladder_9, ladder_10))


# checkpoint
saveRDS(clean_df,"cleaned_new_way/demographics_digital_pathways_depression_sesssubj.rds")


################################################################################
#### SESWOA ####################################################################

clean_df <- readRDS("cleaned_new_way/demographics_digital_pathways_depression_sesssubj.rds")

library(readxl) #to read the excel file
ses_woa_df <- read_excel("SES_PC4_2022_2023_V1.xlsx", sheet = 4)
glimpse(ses_woa_df)

# reducing to important columns
ses_woa_df <- tibble(ses_woa_avg = ses_woa_df$...23, postcode = ses_woa_df$...2, ses_woa_year = ses_woa_df$`Tabel 1` )
ses_woa_df <- ses_woa_df[-c(1,2),]
#View(ses_woa_df)

ses_woa_df <- ses_woa_df %>%
  arrange(postcode, desc(ses_woa_year)) %>% # arrange by year from latest to oldest
  distinct(postcode, .keep_all = T) %>% mutate(
    ses_woa_avg = as.numeric(ses_woa_avg)
  ) # keep only the latest postcode

## merge SES-WOA with dataframe
clean_df <- clean_df %>%
  left_join(ses_woa_df, by = "postcode")

nrow(clean_df)
is.na(clean_df$ses_woa_avg) %>% sum
#View(clean_df)

# checkpoint
saveRDS(clean_df, "cleaned_new_way/demographics_digital_pathways_depression_sesssubj_seswoa.rds")

# fix vocab

# library(janitor) # lower case
# library(stringr) # for str_detect
# 
# clean_df <- clean_df %>% mutate(
#   sm_types = tolower(sm_types), # lower case
#   sm_types = str_trim(sm_types), # remove white spaces
# # dummies  
#   tiktok = as.integer(str_detect(sm_types, "tiktok|tictok")),
#   instragram_and_threads = as.integer(str_detect(sm_types, "instragram|insta|threads")),
#   facebook = as.integer(str_detect(sm_types, "facebook")),
#   twitter_x = as.integer(str_detect(sm_types, "twitter|x|twitter/x|x twitter")),
#   linkedin = as.integer(str_detect(sm_types, "linkedin")),
#   youtube = as.integer(str_detect(sm_types, "youtube|yyoutube")),
#   reddit = as.integer(str_detect(sm_types, "reddit")),
#   snapchat = as.integer(str_detect(sm_types, "snapchat")),
#   tumblr = as.integer(str_detect(sm_types, "tumblr")),
#   pinterest = as.integer(str_detect(sm_types, "pinterest")),
#   strava = as.integer(str_detect(sm_types, "strava")),
#   bluesky = as.integer(str_detect(sm_types, "bluesky")),
#   rednotes = as.integer(str_detect(sm_types, "rednotes")),
# # for undefined
#   sm_na = as.integer(is.na(sm_types))
# ) %>% mutate(
#   tiktok = ifelse(tiktok == 1,1,0),
#   instagram_and_threads = ifelse(instragram_and_threads == 1,2,0),
#   facebook = ifelse(facebook == 1,3,0),
#   twitter_x = ifelse(twitter_x == 1,4,0),
#   linkedin = ifelse(linkedin == 1,5,0),
#   youtube = ifelse(youtube == 1,6,0),
#   reddit = ifelse(reddit == 1,7,0),
#   snapchat = ifelse(snapchat == 1,8,0),
#   tumblr = ifelse(tumblr == 1,9,0),
#   pinterest = ifelse(pinterest == 1,10,0),
#   strava = ifelse(strava == 1,11,0),
#   bluesky = ifelse(bluesky == 1,12,0),
#   rednotes = ifelse(rednotes == 1,13,0),
#   # default if missing
#   .default = NA_real_
# )%>% mutate(sm_type = pmax(tiktok,instragram_and_threads,facebook,twitter_x,linkedin,youtube,reddit,snapchat,tumblr,pinterest,strava,bluesky,rednotes)
# ) %>% mutate( 
#   factor(sm_types,
#          levels = c(1:13),
#          labels = c("tiktok","insta_and_threads",'facebook','twitter_x', 'linkedin','youtube','reddit','snapchat', 'tumblr','pinterest','stava','bluesky','rednotes'),
#          )
#   ) %>% select(-c(tiktok,instragram_and_threads,facebook,twitter_x,linkedin,youtube,reddit,snapchat,tumblr,pinterest,strava,bluesky,rednotes)) # remove unique columns



################################################################################
#### urbanity ##################################################################
library(readxl) # did not find the online table so im using the offline one
library(dplyr)
clean_df <- readRDS("~/Desktop/Thesis Code/Data/cleaned_new_way/demographics_digital_pathways_depression_sesssubj_seswoa.rds")
cbs_cijfers_pc4 <- read_xlsx("~/Desktop/Thesis Code/Data/CBS Key Figures by Postal Code 2024/pc4_2024_v1.xlsx")
#View(cbs_cijfers_pc4)


cbs_clean <- cbs_cijfers_pc4 %>% 
  rename(  
    urbanity = ...37,
    social_assistance = ...35,
    addresses_per_km2 = ...36,
    postcode = `Inwoner, huishouden en woninggegevens voor numeriek deel van de postcode, peildatum 1 januari 2024`
    ) %>% select(urbanity, addresses_per_km2, social_assistance, postcode)

clean_df <- clean_df %>%
  left_join(cbs_clean, by = "postcode")


clean_df <- clean_df %>% mutate(
   urbanity = factor(urbanity,
    levels = c(1:5),
    labels = c("not urbanised", "hardly urbanised", "moderately urbanised", "strongly urbanised", "extremely urbanised"), # degree described here https://www.cbs.nl/en-gb/our-services/methods/definitions/degree-of-urbanisation
    ordered = TRUE
    ),
  
  addresses_per_km2 = as.integer(addresses_per_km2), 
  
  social_assistance = as.integer(social_assistance),
  
  social_assistance = case_match(social_assistance,
                        -99997 ~ NA_real_,
                        .default = social_assistance)
)


#View(clean_df)


nrow(clean_df)

saveRDS(clean_df, "~/Desktop/Thesis Code/Data/cleaned_new_way/demographics_dp_dep_sess_seswoa_urb.rds")

################################################################################
#### final #####################################################################
clean_df <- readRDS("~/Desktop/Thesis Code/Data/cleaned_new_way/demographics_dp_dep_sess_seswoa_urb.rds") #adjust filename later
clean_df <- clean_df %>% select(-starts_with('dep_q'), -starts_with('mal_env_q'), -starts_with('ben_env_q'), -starts_with('sup_esc_q'), -starts_with('exp_esc_q'))
saveRDS(clean_df,"~/Desktop/Thesis Code/Data/cleaned_new_way/lean_and_mean_final_df.rds")
write.csv(clean_df,"~/Desktop/Thesis Code/Data/cleaned_new_way/lean_and_mean_final_df.csv")

df <- readRDS("~/Desktop/Thesis Code/Data/cleaned_new_way/lean_and_mean_final_df.rds")
View(df)






