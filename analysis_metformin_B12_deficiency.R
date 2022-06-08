library(tidyverse)
library(bigrquery)

### BEGIN Loading Data to Workspace ###

# This snippet assumes that you run setup first

# This code copies a file from your Google Bucket into a dataframe

# replace 'test.csv' with the name of the file in your google bucket (don't delete the quotation marks)
name_of_file_in_bucket <- 'people.csv'

########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
people  <- read_csv(name_of_file_in_bucket)
head(people)

# This snippet assumes that you run setup first

# This code copies a file from your Google Bucket into a dataframe

# replace 'test.csv' with the name of the file in your google bucket (don't delete the quotation marks)
name_of_file_in_bucket <- 'survey.csv'

########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
survey  <- read_csv(name_of_file_in_bucket)
head(survey)

# This snippet assumes that you run setup first

# This code copies a file from your Google Bucket into a dataframe

# replace 'test.csv' with the name of the file in your google bucket (don't delete the quotation marks)
name_of_file_in_bucket <- 'drug.csv'

########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
drug  <- read_csv(name_of_file_in_bucket)
head(drug)

# This snippet assumes that you run setup first

# This code copies a file from your Google Bucket into a dataframe

# replace 'test.csv' with the name of the file in your google bucket (don't delete the quotation marks)
name_of_file_in_bucket <- 'condition.csv'

########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
condition  <- read_csv(name_of_file_in_bucket)
head(condition)

# This snippet assumes that you run setup first

# This code copies a file from your Google Bucket into a dataframe

# replace 'test.csv' with the name of the file in your google bucket (don't delete the quotation marks)
name_of_file_in_bucket <- 'observation.csv'

########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
observation  <- read_csv(name_of_file_in_bucket)
head(observation)

# This snippet assumes that you run setup first

# This code copies a file from your Google Bucket into a dataframe

# replace 'test.csv' with the name of the file in your google bucket (don't delete the quotation marks)
name_of_file_in_bucket <- 'procedure.csv'

########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
procedure  <- read_csv(name_of_file_in_bucket)
head(procedure)

# This snippet assumes that you run setup first

# This code copies a file from your Google Bucket into a dataframe

# replace 'test.csv' with the name of the file in your google bucket (don't delete the quotation marks)
name_of_file_in_bucket <- 'measurement.csv'

########################################################################
##
################# DON'T CHANGE FROM HERE ###############################
##
########################################################################

# Get the bucket name
my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# Copy the file from current workspace to the bucket
system(paste0("gsutil cp ", my_bucket, "/data/", name_of_file_in_bucket, " ."), intern=T)

# Load the file into a dataframe
measurement  <- read_csv(name_of_file_in_bucket)
head(measurement)

### END Loading Data to Workspace ###

glimpse(people)
glimpse(survey)
glimpse(drug)
metformin <- drug %>%
 filter(str_detect(standard_concept_name, "metformin"))
glimpse(metformin)
PPIs <- drug %>%
    filter(str_detect(standard_concept_name, "prazole")) 
glimpse(PPIs)
B12_supplement <- drug %>%
    filter(!(standard_concept_name %in% metformin$standard_concept_name)) %>%
    filter(!(standard_concept_name %in% PPIs$standard_concept_name))
glimpse(B12_supplement)
glimpse(condition)
type2_diabetes <- condition %>%
    filter(str_detect(standard_concept_name, "type 2") |
           str_detect(standard_concept_name, "Type 2") ) %>% 
    filter(!str_detect(standard_concept_name, "due to")) %>% 
    filter(str_detect(standard_concept_name, "diabetes") |
           str_detect(standard_concept_name, "Diabetes")) 
glimpse(type2_diabetes)
glimpse(observation)
observation %>% count(source_concept_code)
glimpse(procedure)
procedure %>% count(source_concept_code)
glimpse(measurement)

#### BEGIN CODING FOR CHARLSON COMORBIDITIES ####
myocardial_infarction <- condition %>% 
    filter(str_detect(source_concept_code, "I21") |
           str_detect(source_concept_code, "I22") |
           str_detect(source_concept_code, "I25.2")) 
paste("myocardial_infarction: ", myocardial_infarction %>% nrow())

congestive_heart_failure <- condition %>% 
    filter(str_detect(source_concept_code, "I09.9") |
           str_detect(source_concept_code, "I11.0") |
           str_detect(source_concept_code, "I13.0") |
           str_detect(source_concept_code, "I13.2") |
           str_detect(source_concept_code, "I25.5") |
           str_detect(source_concept_code, "I42.0") |
           str_detect(source_concept_code, "I42.5") |
           str_detect(source_concept_code, "I42.6") |
           str_detect(source_concept_code, "I42.7") |
           str_detect(source_concept_code, "I42.8") |
           str_detect(source_concept_code, "I42.9") |
           str_detect(source_concept_code, "I43") |
           str_detect(source_concept_code, "I50") |
           str_detect(source_concept_code, "P29.0")) 
paste("congestive_heart_failure: ", congestive_heart_failure %>% nrow())

peripheral_vascular_disease <- condition %>% 
    filter(str_detect(source_concept_code, "I70") |
           str_detect(source_concept_code, "I71") |
           str_detect(source_concept_code, "I73.1") |
           str_detect(source_concept_code, "I73.8") |
           str_detect(source_concept_code, "I73.9") |
           str_detect(source_concept_code, "I77.1") |
           str_detect(source_concept_code, "I79.0") |
           str_detect(source_concept_code, "I79.2") |
           str_detect(source_concept_code, "K55.1") |
           str_detect(source_concept_code, "K55.8") |
           str_detect(source_concept_code, "K55.9") |
           str_detect(source_concept_code, "Z95.8") |
           str_detect(source_concept_code, "Z95.9")) 
paste("peripheral_vascular_disease: ", peripheral_vascular_disease %>% nrow())

peripheral_vascular_disease2 <- observation %>% 
    filter(str_detect(source_concept_code, "Z95.8") |
           str_detect(source_concept_code, "Z95.9")) 
paste("peripheral_vascular_disease_2: ", peripheral_vascular_disease2 %>% nrow())

cerebrovascular_disease <- condition %>% 
    filter(str_detect(source_concept_code, "G45") |
           str_detect(source_concept_code, "G46") |
           str_detect(source_concept_code, "H34.0") |
           str_detect(source_concept_code, "I60") |
           str_detect(source_concept_code, "I61") |
           str_detect(source_concept_code, "I62") |
           str_detect(source_concept_code, "I63") |
           str_detect(source_concept_code, "I64") |
           str_detect(source_concept_code, "I65") |
           str_detect(source_concept_code, "I66") |
           str_detect(source_concept_code, "I67") |
           str_detect(source_concept_code, "I68") |
           str_detect(source_concept_code, "I69")) 
paste("cerebrovascular_disease: ", cerebrovascular_disease %>% nrow())

dementia <- condition %>% 
    filter(str_detect(source_concept_code, "F00") |
           str_detect(source_concept_code, "F01") |
           str_detect(source_concept_code, "F02") |
           str_detect(source_concept_code, "F03") |
           str_detect(source_concept_code, "F05.1") |
           str_detect(source_concept_code, "G30") |
           str_detect(source_concept_code, "G31.1")) 
paste("dementia: ", dementia %>% nrow())

chronic_pulmonary_disease <- condition %>% 
    filter(str_detect(source_concept_code, "I27.8") |
           str_detect(source_concept_code, "I27.9") |
           str_detect(source_concept_code, "J40") |
           str_detect(source_concept_code, "J41") |
           str_detect(source_concept_code, "J42") |
           str_detect(source_concept_code, "J43") |
           str_detect(source_concept_code, "J44") |
           str_detect(source_concept_code, "J45") |
           str_detect(source_concept_code, "J46") |
           str_detect(source_concept_code, "J47") |
           str_detect(source_concept_code, "J60") |
           str_detect(source_concept_code, "J61") |
           str_detect(source_concept_code, "J62") |
           str_detect(source_concept_code, "J63") |
           str_detect(source_concept_code, "J64") |
           str_detect(source_concept_code, "J65") |
           str_detect(source_concept_code, "J66") |
           str_detect(source_concept_code, "J67") |
           str_detect(source_concept_code, "J68.4") |
           str_detect(source_concept_code, "J70.1") |
           str_detect(source_concept_code, "J70.3")) 
paste("chronic_pulmonary_disease: ", chronic_pulmonary_disease %>% nrow())

chronic_pulmonary_disease2 <- observation %>% 
    filter(str_detect(source_concept_code, "J43.0")) 
paste("chronic_pulmonary_disease_2: ", chronic_pulmonary_disease2 %>% nrow())

rheumatic <- condition %>% 
    filter(str_detect(source_concept_code, "M05") |
           str_detect(source_concept_code, "M06") |
           str_detect(source_concept_code, "M31.5") |
           str_detect(source_concept_code, "M32") |
           str_detect(source_concept_code, "M33") |
           str_detect(source_concept_code, "M34") |
           str_detect(source_concept_code, "M35.1") |
           str_detect(source_concept_code, "M35.3") |
           str_detect(source_concept_code, "M36.0"))
paste("rheumatic: ", rheumatic %>% nrow())

peptic_ulcer_disease <- condition %>% 
    filter(str_detect(source_concept_code, "K25") |
           str_detect(source_concept_code, "K26") |
           str_detect(source_concept_code, "K27") |
           str_detect(source_concept_code, "K28"))
paste("peptic_ulcer_disease: ", peptic_ulcer_disease %>% nrow())

mild_liver_disease <- condition %>% 
    filter(str_detect(source_concept_code, "B18") |
           str_detect(source_concept_code, "K70.0") |
           str_detect(source_concept_code, "K70.1") |
           str_detect(source_concept_code, "K70.2") |
           str_detect(source_concept_code, "K70.3") |
           str_detect(source_concept_code, "K70.9") |
           str_detect(source_concept_code, "K71.3") |
           str_detect(source_concept_code, "K71.4") |
           str_detect(source_concept_code, "K71.5") |
           str_detect(source_concept_code, "K71.7") |
           str_detect(source_concept_code, "K73") |
           str_detect(source_concept_code, "K74") |
           str_detect(source_concept_code, "K76.0") |
           str_detect(source_concept_code, "K76.2") |
           str_detect(source_concept_code, "K76.3") |
           str_detect(source_concept_code, "K76.4") |
           str_detect(source_concept_code, "K76.8") |
           str_detect(source_concept_code, "K76.9") |
           str_detect(source_concept_code, "Z94.4")) 
paste("mild_liver_disease: ", mild_liver_disease %>% nrow())

mild_liver_disease2 <- observation %>% 
    filter(str_detect(source_concept_code, "Z94.4")) 
paste("mild_liver_disease_2: ", mild_liver_disease2 %>% nrow())

diabetes_without_chronic_complication <- condition %>% 
    filter(str_detect(source_concept_code, "E10.0") |
           str_detect(source_concept_code, "E10.1") |
           str_detect(source_concept_code, "E10.6") |
           str_detect(source_concept_code, "E10.8") |
           str_detect(source_concept_code, "E10.9") |
           str_detect(source_concept_code, "E11.0") |
           str_detect(source_concept_code, "E11.1") |
           str_detect(source_concept_code, "E11.6") |
           str_detect(source_concept_code, "E11.8") |
           str_detect(source_concept_code, "E11.9") |
           str_detect(source_concept_code, "E12.0") |
           str_detect(source_concept_code, "E12.1") |
           str_detect(source_concept_code, "E12.6") |
           str_detect(source_concept_code, "E12.8") |
           str_detect(source_concept_code, "E12.9") |
           str_detect(source_concept_code, "E13.0") |
           str_detect(source_concept_code, "E13.1") |
           str_detect(source_concept_code, "E13.6") |
           str_detect(source_concept_code, "E13.8") |
           str_detect(source_concept_code, "E13.9") |
           str_detect(source_concept_code, "E14.0") |
           str_detect(source_concept_code, "E14.1") |
           str_detect(source_concept_code, "E14.6") |
           str_detect(source_concept_code, "E14.8") |
           str_detect(source_concept_code, "E14.9"))
paste("diabetes_without_chronic_complication: ", diabetes_without_chronic_complication %>% nrow())

diabetes_with_chronic_complication <- condition %>% 
    filter(str_detect(source_concept_code, "E10.2") |
           str_detect(source_concept_code, "E10.3") |
           str_detect(source_concept_code, "E10.4") |
           str_detect(source_concept_code, "E10.5") |
           str_detect(source_concept_code, "E10.7") |
           str_detect(source_concept_code, "E11.2") |
           str_detect(source_concept_code, "E11.3") |
           str_detect(source_concept_code, "E11.4") |
           str_detect(source_concept_code, "E11.5") |
           str_detect(source_concept_code, "E11.7") |
           str_detect(source_concept_code, "E12.2") |
           str_detect(source_concept_code, "E12.3") |
           str_detect(source_concept_code, "E12.4") |
           str_detect(source_concept_code, "E12.5") |
           str_detect(source_concept_code, "E12.7") |
           str_detect(source_concept_code, "E13.2") |
           str_detect(source_concept_code, "E13.3") |
           str_detect(source_concept_code, "E13.4") |
           str_detect(source_concept_code, "E13.5") |
           str_detect(source_concept_code, "E13.7") |
           str_detect(source_concept_code, "E14.2") |
           str_detect(source_concept_code, "E14.3") |
           str_detect(source_concept_code, "E14.4") |
           str_detect(source_concept_code, "E14.5") |
           str_detect(source_concept_code, "E14.7")) 
paste("diabetes_with_chronic_complication: ", diabetes_with_chronic_complication %>% nrow())

hemiplegia_or_paraplegia <- condition %>% 
    filter(str_detect(source_concept_code, "G04.1") |
           str_detect(source_concept_code, "G11.4") |
           str_detect(source_concept_code, "G80.1") |
           str_detect(source_concept_code, "G80.2") |
           str_detect(source_concept_code, "G81") |
           str_detect(source_concept_code, "G82") |
           str_detect(source_concept_code, "G83.0") |
           str_detect(source_concept_code, "G83.1") |
           str_detect(source_concept_code, "G83.2") |
           str_detect(source_concept_code, "G83.3") |
           str_detect(source_concept_code, "G83.4") |
           str_detect(source_concept_code, "G83.9"))
paste("hemiplegia_or_paraplegia: ", hemiplegia_or_paraplegia %>% nrow())

renal_disease <- condition %>% 
    filter(str_detect(source_concept_code, "I12") |
           str_detect(source_concept_code, "I13.1") |
           str_detect(source_concept_code, "N03.2") |
           str_detect(source_concept_code, "N03.3") |
           str_detect(source_concept_code, "N03.4") |
           str_detect(source_concept_code, "N03.5") |
           str_detect(source_concept_code, "N03.6") |
           str_detect(source_concept_code, "N03.7") |
           str_detect(source_concept_code, "N05.2") |
           str_detect(source_concept_code, "N05.3") |
           str_detect(source_concept_code, "N05.4") |
           str_detect(source_concept_code, "N05.5") |
           str_detect(source_concept_code, "N05.6") |
           str_detect(source_concept_code, "N05.7") |
           str_detect(source_concept_code, "N18") |
           str_detect(source_concept_code, "N19") |
           str_detect(source_concept_code, "N25.0") |
           str_detect(source_concept_code, "Z49.0") |
           str_detect(source_concept_code, "Z49.1") |
           str_detect(source_concept_code, "Z49.2") |
           str_detect(source_concept_code, "Z94.0") |
           str_detect(source_concept_code, "Z99.2")) 
paste("renal_disease: ", renal_disease %>% nrow())

renal_disease2 <- observation %>% 
    filter(str_detect(source_concept_code, "Z49.0") |
           str_detect(source_concept_code, "Z94.0") |
           str_detect(source_concept_code, "Z99.2"))
paste("renal_disease_2: ", renal_disease2 %>% nrow())

renal_disease3 <- procedure %>% 
    filter(str_detect(source_concept_code, "Z49.0"))
paste("renal_disease_3: ", renal_disease3 %>% nrow())

# Any malignancy, including lymphoma and leukemia, except malignant neoplasm of skin
any_malignancy <- condition %>% 
    filter(str_detect(source_concept_code, "C0") | #C00 - C09
           str_detect(source_concept_code, "C1") | #C10 - C19
           str_detect(source_concept_code, "C20") |
           str_detect(source_concept_code, "C21") |
           str_detect(source_concept_code, "C22") |
           str_detect(source_concept_code, "C23") |
           str_detect(source_concept_code, "C24") |
           str_detect(source_concept_code, "C25") |
           str_detect(source_concept_code, "C26") |
           str_detect(source_concept_code, "C30") |
           str_detect(source_concept_code, "C31") |
           str_detect(source_concept_code, "C32") |
           str_detect(source_concept_code, "C33") |
           str_detect(source_concept_code, "C34") |
           str_detect(source_concept_code, "C37") |
           str_detect(source_concept_code, "C38") |
           str_detect(source_concept_code, "C39") |
           str_detect(source_concept_code, "C40") |
           str_detect(source_concept_code, "C41") |
           str_detect(source_concept_code, "C43") |
           str_detect(source_concept_code, "C45") |
           str_detect(source_concept_code, "C46") |
           str_detect(source_concept_code, "C47") |
           str_detect(source_concept_code, "C48") |
           str_detect(source_concept_code, "C49") |
           str_detect(source_concept_code, "C50") |
           str_detect(source_concept_code, "C51") |
           str_detect(source_concept_code, "C52") |
           str_detect(source_concept_code, "C53") |
           str_detect(source_concept_code, "C54") |
           str_detect(source_concept_code, "C55") |
           str_detect(source_concept_code, "C56") |
           str_detect(source_concept_code, "C57") |
           str_detect(source_concept_code, "C58") |
           str_detect(source_concept_code, "C6") | # C60 - C69
           str_detect(source_concept_code, "C70") |
           str_detect(source_concept_code, "C71") |
           str_detect(source_concept_code, "C72") |
           str_detect(source_concept_code, "C73") |
           str_detect(source_concept_code, "C74") |
           str_detect(source_concept_code, "C75") |
           str_detect(source_concept_code, "C76") |
           str_detect(source_concept_code, "C81") |
           str_detect(source_concept_code, "C82") |
           str_detect(source_concept_code, "C83") |
           str_detect(source_concept_code, "C84") |
           str_detect(source_concept_code, "C85") |
           str_detect(source_concept_code, "C88") |
           str_detect(source_concept_code, "C90") |
           str_detect(source_concept_code, "C91") |
           str_detect(source_concept_code, "C92") |
           str_detect(source_concept_code, "C93") |
           str_detect(source_concept_code, "C94") |
           str_detect(source_concept_code, "C95") |
           str_detect(source_concept_code, "C96") |
           str_detect(source_concept_code, "C97"))  
paste("any_malignancy: ", any_malignancy %>% nrow())

moderate_or_severe_liver_disease <- condition %>% 
    filter(str_detect(source_concept_code, "I85.0") | 
           str_detect(source_concept_code, "I85.9") | 
           str_detect(source_concept_code, "I86.4") |
           str_detect(source_concept_code, "I98.2") |
           str_detect(source_concept_code, "K70.4") |
           str_detect(source_concept_code, "K71.1") |
           str_detect(source_concept_code, "K72.1") |
           str_detect(source_concept_code, "K72.9") |
           str_detect(source_concept_code, "K76.5") |
           str_detect(source_concept_code, "K76.6") |
           str_detect(source_concept_code, "K76.7"))
paste("moderate_or_severe_liver_disease: ", moderate_or_severe_liver_disease %>% nrow())

metastatic_solid_tumor <- condition %>% 
    filter(str_detect(source_concept_code, "C77") | 
           str_detect(source_concept_code, "C78") | 
           str_detect(source_concept_code, "C79") |
           str_detect(source_concept_code, "C80"))
paste("metastatic_solid_tumor: ", metastatic_solid_tumor %>% nrow())

metastatic_solid_tumor2 <- measurement %>% 
    filter(str_detect(source_concept_code, "C78") | 
           str_detect(source_concept_code, "C79")) 
paste("metastatic_solid_tumor_2: ", metastatic_solid_tumor2 %>% nrow())

AIDS_HIV <- condition %>% 
    filter(str_detect(source_concept_code, "B20") | 
           str_detect(source_concept_code, "B21") | 
           str_detect(source_concept_code, "B22") |
           str_detect(source_concept_code, "B24"))
paste("AIDS_HIV: ", AIDS_HIV %>% nrow())

type2_diabetes %>% 
    filter(!str_detect(source_concept_code, "E11.")) %>% nrow()
type2_diabetes %>% 
    filter(is.na(source_concept_code)) %>% nrow()
    
sum(228785,
    158766,
    myocardial_infarction %>% nrow(),
    congestive_heart_failure %>% nrow(),
    peripheral_vascular_disease %>% nrow(),
#     peripheral_vascular_disease2 %>% nrow(),
    cerebrovascular_disease %>% nrow(),
    dementia %>% nrow(),
    chronic_pulmonary_disease %>% nrow(),
#     chronic_pulmonary_disease2 %>% nrow(),
    rheumatic %>% nrow(),
    peptic_ulcer_disease %>% nrow(),
    mild_liver_disease %>% nrow(),
#     mild_liver_disease2 %>% nrow(), 
    diabetes_without_chronic_complication %>% nrow(),
    diabetes_with_chronic_complication %>% nrow(),
    hemiplegia_or_paraplegia %>% nrow(),
    renal_disease %>% nrow(),
#     renal_disease2 %>% nrow(),
#     renal_disease3 %>% nrow(),
    any_malignancy %>% nrow(),
    moderate_or_severe_liver_disease %>% nrow(),
    metastatic_solid_tumor %>% nrow(),
#     metastatic_solid_tumor2 %>% nrow(),
    AIDS_HIV %>% nrow())
    
condition %>%
    filter(!(source_concept_code %in% myocardial_infarction$source_concept_code)) %>%
    filter(!(source_concept_code %in% congestive_heart_failure$source_concept_code)) %>%
    filter(!(source_concept_code %in% peripheral_vascular_disease$source_concept_code)) %>%
    filter(!(source_concept_code %in% cerebrovascular_disease$source_concept_code)) %>%
    filter(!(source_concept_code %in% dementia$source_concept_code)) %>%
    filter(!(source_concept_code %in% chronic_pulmonary_disease$source_concept_code)) %>%
    filter(!(source_concept_code %in% rheumatic$source_concept_code)) %>%
    filter(!(source_concept_code %in% peptic_ulcer_disease$source_concept_code)) %>%
    filter(!(source_concept_code %in% mild_liver_disease$source_concept_code)) %>%
    filter(!(source_concept_code %in% diabetes_without_chronic_complication$source_concept_code)) %>%
    filter(!(source_concept_code %in% diabetes_with_chronic_complication$source_concept_code)) %>%
    filter(!(source_concept_code %in% hemiplegia_or_paraplegia$source_concept_code)) %>%
    filter(!(source_concept_code %in% renal_disease$source_concept_code)) %>%
    filter(!(source_concept_code %in% any_malignancy$source_concept_code)) %>%
    filter(!(source_concept_code %in% moderate_or_severe_liver_disease$source_concept_code)) %>%
    filter(!(source_concept_code %in% metastatic_solid_tumor$source_concept_code)) %>%
    filter(!(source_concept_code %in% AIDS_HIV$source_concept_code)) %>% nrow()   
#### END CODING FOR CHARLSON COMORBIDITIES ####

# Keep only vitamin B12 measurements
measurement <- measurement %>%
    filter(!(source_concept_code %in% metastatic_solid_tumor2$source_concept_code))
glimpse(measurement)

measurement_origin <- measurement
    
measurement_origin %>%
    filter(value_as_number <= 400) %>%
    count(unit_concept_name, unit_source_value)
    
# Keep correct units
measurement <- measurement %>% 
    filter(unit_source_value == "ng/L" | 
           unit_source_value == "pg/mL" | 
           unit_source_value == "258808001")
glimpse(measurement)   

people %>% count(race)
people %>% count(ethnicity)
people %>% count(sex_at_birth)

library(lubridate)
today <- today()
data <- people %>%
    arrange(person_id) %>%
    mutate(index = 1:nrow(people), .after=person_id) %>%
    mutate(str_index = as.character(index), .after=index) %>%
    mutate(age = round(as.numeric(today - as_date(date_of_birth)) / 365.25, 0)) %>%
    select(person_id, index, str_index, age, race, ethnicity, sex_at_birth) %>%
    mutate(race = str_remove(race, "PMI: ")) %>%
    mutate(race = factor(race, levels = c("Asian", "Black or African American", "White",
                                          "Another single population", "More than one population", 
                                          "None of these", "None Indicated", "I prefer not to answer", "Skip"))) %>%  
    mutate(ethnicity = str_remove(ethnicity, "PMI: ")) %>%
    mutate(ethnicity = str_remove(ethnicity, "What Race Ethnicity: Race Ethnicity ")) %>%
    mutate(ethnicity = factor(ethnicity, levels = c("Hispanic or Latino", "Not Hispanic or Latino", "None Of These",
                                                    "Prefer Not To Answer", "Skip"))) %>%
    mutate(sex_at_birth = factor(sex_at_birth, levels = c("Female", "Male", "No matching concept", 
                                                          "Not male, not female, prefer not to answer, or skipped")))
glimpse(data)

education <- survey %>%
    filter(str_detect(question, "Education")) %>%
    mutate(answer = str_remove(answer, "Highest Grade: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(education)

education %>% count(answer)

data <- left_join(data, education, by = "person_id") %>%
    rename(education = answer) %>%
    mutate(education = factor(education, levels = c("Less than a high school degree or equivalent",
                                                    "Twelve Or GED",
                                                    "College One to Three",
                                                    "College graduate or advanced degree",                                                    
                                                    "Prefer Not To Answer",
                                                    "Skip")))
glimpse(data)

marital <- survey %>%
    filter(str_detect(question, "Marital")) %>%
    mutate(answer = str_remove(answer, "Current Marital Status: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(marital)

marital %>% count(answer)

data <- left_join(data, marital, by = "person_id") %>%
    rename(marital_status = answer) %>%
    mutate(marital_status = factor(marital_status, levels = c("Married", "Never Married", "Divorced", "Widowed", "Separated",
                                                              "Living With Partner", "Prefer Not To Answer", "Skip")))
glimpse(data)

# Health Insurance: Are you covered by health insurance or some other kind of health care plan?
insurance <- survey %>%
    filter(str_detect(question, "^Insurance: Health Insurance$")) %>%
    mutate(answer = str_remove(answer, "Health Insurance: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(insurance)

insurance %>% count(answer)

data <- left_join(data, insurance, by = "person_id") %>%
    rename(insurance_status = answer) %>%
    mutate(insurance_status = factor(insurance_status, levels = c("Yes", "No", "Dont Know", "Prefer Not To Answer", "Skip")))
glimpse(data)

income <- survey %>%
    filter(str_detect(question, "Income")) %>%
    mutate(answer = str_remove(answer, "Annual Income: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(income)

income %>% count(answer)

data <- left_join(data, income, by = "person_id") %>%
    rename(annual_income = answer) %>%
    mutate(annual_income = factor(annual_income, levels = c("less 10k", "10k 25k", "25k 35k", "35k 50k", "50k 75k", 
                                                            "75k 100k", "100k 150k", "150k 200k", "more 200k",                                                              
                                                            "Prefer Not To Answer", "Skip")))
glimpse(data)

# 100 Cigs Lifetime: Have you smoked at least 100 cigarettes in your entire life? (There are 20 cigarettes in a pack.)?
cigarettes_100 <- survey %>%
    filter(str_detect(question, "100 Cigs Lifetime")) %>%
    mutate(answer = str_remove(answer, "100 Cigs Lifetime: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(cigarettes_100)

cigarettes_100 %>% count(answer)

data <- left_join(data, cigarettes_100, by = "person_id") %>%
    rename(cigarettes_100 = answer) %>%
    mutate(cigarettes_100 = factor(cigarettes_100, levels = c("Yes", "No", "Dont Know", "Prefer Not To Answer", "Skip")))
glimpse(data)

# Average Daily Cigarette Number: On average, over the entire time that you smoked, how many cigarettes did you smoke each day? (There are 20 cigarettes in a pack.)?
average_daily_cigarettes <- survey %>%
    filter(str_detect(question, "Average Daily Cigarette Number")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
average_daily_cigarettes["answer"][average_daily_cigarettes["answer"] == "Dont Know"] <- NA
average_daily_cigarettes["answer"][average_daily_cigarettes["answer"] == "Skip"] <- NA
average_daily_cigarettes <- average_daily_cigarettes %>%
    mutate(answer = as.numeric(answer))
glimpse(average_daily_cigarettes)

average_daily_cigarettes %>% count(answer)

data <- left_join(data, average_daily_cigarettes, by = "person_id") %>%
    rename(average_daily_cigarettes = answer)
glimpse(data)

# Current Daily Cigarette Number: On average, how many cigarettes do you smoke per day now? (There are 20 cigarettes in a pack.)
current_daily_cigarettes <- survey %>%
    filter(str_detect(question, "Current Daily Cigarette Number")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
current_daily_cigarettes["answer"][current_daily_cigarettes["answer"] == "Dont Know"] <- NA
current_daily_cigarettes["answer"][current_daily_cigarettes["answer"] == "Skip"] <- NA
current_daily_cigarettes <- current_daily_cigarettes %>%
    mutate(answer = as.numeric(answer))
glimpse(current_daily_cigarettes)

current_daily_cigarettes %>% count(answer)

data <- left_join(data, current_daily_cigarettes, by = "person_id") %>%
    rename(current_daily_cigarettes = answer)
glimpse(data)

# Number Of Years: How many years have you or did you smoke cigarettes?
smoking_years <- survey %>%
    filter(str_detect(question, "Number Of Years")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
smoking_years["answer"][smoking_years["answer"] == "Prefer Not To Answer"] <- NA
smoking_years["answer"][smoking_years["answer"] == "Dont Know"] <- NA
smoking_years["answer"][smoking_years["answer"] == "Skip"] <- NA
smoking_years <- smoking_years %>%
    mutate(answer = as.numeric(answer))
glimpse(smoking_years)

smoking_years %>% count(answer)

data <- left_join(data, smoking_years, by = "person_id") %>%
    rename(smoking_years = answer)
glimpse(data)

# Smoke Frequency: Do you now smoke cigarettes every day, some days, or not at all?
smoking_frequency <- survey %>%
    filter(str_detect(question, "Smoking: Smoke Frequency")) %>%
    mutate(answer = str_remove(answer, "Smoke Frequency: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(smoking_frequency)

smoking_frequency %>% count(answer)

data <- left_join(data, smoking_frequency, by = "person_id") %>%
    rename(smoking_frequency = answer) %>%
    mutate(smoking_frequency = factor(smoking_frequency, levels = c("Not At All", "Some Days", "Every Day",
                                                                    "Dont Know", "Prefer Not To Answer", "Skip")))
glimpse(data)

# 6 or More Drinks Occurrence: How often did you have six or more drinks on one occasion in the past year?
drink_6_more_occurrence <- survey %>%
    filter(str_detect(question, "Alcohol: 6 or More Drinks Occurrence")) %>%
    mutate(answer = str_remove(answer, "6 or More Drinks Occurrence: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(drink_6_more_occurrence)

drink_6_more_occurrence %>% count(answer)

data <- left_join(data, drink_6_more_occurrence, by = "person_id") %>%
    rename(drink_6_more_occurrence = answer) %>%
    mutate(drink_6_more_occurrence = factor(drink_6_more_occurrence, levels = c("Never In Last Year", "Less Than Monthly", 
                                                                                "Monthly", "Weekly", "Daily", 
                                                                                "Prefer Not To Answer", "Skip")))
glimpse(data)

# Average Daily Drink Count: On a typical day when you drink, how many drinks do you have?
average_daily_drink <- survey %>%
    filter(str_detect(question, "Alcohol: Average Daily Drink Count")) %>%
    mutate(answer = str_remove(answer, "Average Daily Drink Count: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(average_daily_drink)

average_daily_drink %>% count(answer)

data <- left_join(data, average_daily_drink, by = "person_id") %>%
    rename(average_daily_drink = answer) %>%
    mutate(average_daily_drink = factor(average_daily_drink, levels = c("1 or 2", "3 or 4", "5 or 6", "7 to 9",
                                                                        "10 or More", "Prefer Not To Answer", "Skip")))
glimpse(data)

# In general, would you say your quality of life is?
overall_health <- survey %>%
    filter(str_detect(question, "Overall Health: General Quality")) %>%
    mutate(answer = str_remove(answer, "General Quality: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(overall_health)

overall_health %>% count(answer)

data <- left_join(data, overall_health, by = "person_id") %>%
    rename(overall_health = answer) %>%
    mutate(overall_health = factor(overall_health, levels = c("Poor", "Fair", "Good", "Very Good", "Excellent", "Skip")))
glimpse(data)

# In general, how would you rate your physical health?
physical_health <- survey %>%
    filter(str_detect(question, "Overall Health: General Physical Health")) %>%
    mutate(answer = str_remove(answer, "General Physical Health: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    select(person_id, answer)
glimpse(physical_health)

physical_health %>% count(answer)

data <- left_join(data, physical_health, by = "person_id") %>%
    rename(physical_health = answer) %>%
    mutate(physical_health = factor(physical_health, levels = c("Poor", "Fair", "Good", "Very Good", "Excellent", "Skip")))
glimpse(data)

# In general, how would you rate your mental health?
mental_health <- survey %>%
    filter(str_detect(question, "Overall Health: General Mental Health")) %>%
    mutate(answer = str_remove(answer, "General Mental Health: ")) %>%
    mutate(answer = str_remove(answer, "PMI: ")) %>%
    mutate(answer = str_replace(answer, "Excllent", "Excellent")) %>%
    select(person_id, answer)
glimpse(mental_health)

mental_health %>% count(answer)

data <- left_join(data, mental_health, by = "person_id") %>%
    rename(mental_health = answer) %>%
    mutate(mental_health = factor(mental_health, levels = c("Poor", "Fair", "Good", "Very Good", "Excellent", "Skip")))
glimpse(data)

num_metformin <- metformin %>% count(person_id)
glimpse(num_metformin)

data <- left_join(data, num_metformin, by = "person_id") %>%
    rename(num_metformin = n)
data['num_metformin'][is.na(data['num_metformin'])] <- 0
glimpse(data)

metformin_temp <- metformin %>%
    select(person_id, drug_exposure_start_datetime, drug_exposure_end_datetime) %>%
    mutate(drug_exposure_start_year = year(drug_exposure_start_datetime)) %>%
    mutate(drug_exposure_end_year = year(drug_exposure_end_datetime))
metformin_temp$drug_exposure_end_datetime[is.na(metformin_temp$drug_exposure_end_datetime)] <- metformin_temp$drug_exposure_start_datetime[is.na(metformin_temp$drug_exposure_end_datetime)]
metformin_temp$drug_exposure_end_year[is.na(metformin_temp$drug_exposure_end_year)] <- metformin_temp$drug_exposure_start_year[is.na(metformin_temp$drug_exposure_end_year)]
glimpse(metformin_temp)

metformin_year <- metformin_temp %>%
    count(person_id, drug_exposure_start_year) %>%
    count(person_id) %>%
    rename(metformin_year = n)
glimpse(metformin_year)

data <- left_join(data, metformin_year, by = "person_id")
data['metformin_year'][is.na(data['metformin_year'])] <- 0
glimpse(data)

B12_supplement_temp <- B12_supplement %>%
    select(person_id, drug_exposure_start_datetime, drug_exposure_end_datetime) %>%
    mutate(drug_exposure_start_year = year(drug_exposure_start_datetime)) %>%
    mutate(drug_exposure_end_year = year(drug_exposure_end_datetime))
B12_supplement_temp$drug_exposure_end_datetime[is.na(B12_supplement_temp$drug_exposure_end_datetime)] <- B12_supplement_temp$drug_exposure_start_datetime[is.na(B12_supplement_temp$drug_exposure_end_datetime)]
B12_supplement_temp$drug_exposure_end_year[is.na(B12_supplement_temp$drug_exposure_end_year)] <- B12_supplement_temp$drug_exposure_start_year[is.na(B12_supplement_temp$drug_exposure_end_year)]
glimpse(B12_supplement_temp)

num_B12_supplement <- B12_supplement_temp %>% 
    count(person_id) %>%
    rename(num_B12_supplement = n)
glimpse(num_B12_supplement)

data <- left_join(data, num_B12_supplement, by = "person_id")
data['num_B12_supplement'][is.na(data['num_B12_supplement'])] <- 0
data <- data %>%
    mutate(B12_supplement = case_when(data$num_B12_supplement > 0 ~ "Yes",
                                      data$num_B12_supplement == 0 ~ "No")) %>%
    mutate(B12_supplement = factor(B12_supplement, levels = c("Yes", "No")))
glimpse(data)

B12_supplement_year <- B12_supplement_temp %>%
    count(person_id, drug_exposure_start_year) %>%
    count(person_id) %>%
    rename(B12_supplement_year = n)
glimpse(B12_supplement_year)

data <- left_join(data, B12_supplement_year, by = "person_id")
data['B12_supplement_year'][is.na(data['B12_supplement_year'])] <- 0
glimpse(data)

PPIs_temp <- PPIs %>%
    select(person_id, drug_exposure_start_datetime, drug_exposure_end_datetime) %>%
    mutate(drug_exposure_start_year = year(drug_exposure_start_datetime)) %>%
    mutate(drug_exposure_end_year = year(drug_exposure_end_datetime))
PPIs_temp$drug_exposure_end_datetime[is.na(PPIs_temp$drug_exposure_end_datetime)] <- PPIs_temp$drug_exposure_start_datetime[is.na(PPIs_temp$drug_exposure_end_datetime)]
PPIs_temp$drug_exposure_end_year[is.na(PPIs_temp$drug_exposure_end_year)] <- PPIs_temp$drug_exposure_start_year[is.na(PPIs_temp$drug_exposure_end_year)]
glimpse(PPIs_temp)

num_PPIs <- PPIs_temp %>% 
    count(person_id) %>%
    rename(num_PPIs = n)
glimpse(num_PPIs)

data <- left_join(data, num_PPIs, by = "person_id")
data['num_PPIs'][is.na(data['num_PPIs'])] <- 0
data <- data %>%
    mutate(PPIs_usage = case_when(data$num_PPIs > 0 ~ "Yes",
                                  data$num_PPIs == 0 ~ "No")) %>%
    mutate(PPIs_usage = factor(PPIs_usage, levels = c("Yes", "No")))
glimpse(data)

PPIs_year <- PPIs_temp %>%
    count(person_id, drug_exposure_start_year) %>%
    count(person_id) %>%
    rename(PPIs_year = n)
glimpse(PPIs_year)

data <- left_join(data, PPIs_year, by = "person_id")
data['PPIs_year'][is.na(data['PPIs_year'])] <- 0
glimpse(data)

B12_info <- measurement %>% 
    select(person_id, measurement_datetime, value_as_number) %>%
    mutate(B12_category = case_when(value_as_number < 200 ~ "Deficiency",
                                    value_as_number >= 200 & value_as_number <= 400 ~ "Borderline", 
                                    value_as_number > 400 & value_as_number <= 1000 ~ "Normal",
                                    value_as_number > 1000 & value_as_number <= 2000 ~ "High",
                                    value_as_number > 2000 ~ "Extreme")) %>%
    mutate(B12_category = factor(B12_category, levels = c("Deficiency", "Borderline", "Normal", "High", "Extreme")))
glimpse(B12_info)

measurement_origin %>% distinct(person_id) %>% nrow()

B12_info %>% distinct(person_id) %>% nrow()

correct_units <- B12_info %>% distinct(person_id)
glimpse(correct_units)

# Remove 11108 patients with unknown units, keep pg/mL, ng/L
data <- data %>%
    filter(person_id %in% correct_units$person_id)
glimpse(data)

num_B12_deficiency <- B12_info %>%
    filter(B12_category == "Deficiency") %>%
    count(person_id) %>%
    rename(num_B12_deficiency = n)
glimpse(num_B12_deficiency)

data <- left_join(data, num_B12_deficiency, by = "person_id")
data['num_B12_deficiency'][is.na(data['num_B12_deficiency'])] <- 0
glimpse(data)

num_B12_borderline <- B12_info %>%
    filter(B12_category == "Borderline") %>%
    count(person_id) %>%
    rename(num_B12_borderline = n)
glimpse(num_B12_borderline)

data <- left_join(data, num_B12_borderline, by = "person_id")
data['num_B12_borderline'][is.na(data['num_B12_borderline'])] <- 0
glimpse(data)

num_B12_normal <- B12_info %>%
    filter(B12_category == "Normal") %>%
    count(person_id) %>%
    rename(num_B12_normal = n)
glimpse(num_B12_normal)

data <- left_join(data, num_B12_normal, by = "person_id")
data['num_B12_normal'][is.na(data['num_B12_normal'])] <- 0
glimpse(data)

num_B12_high <- B12_info %>%
    filter(B12_category == "High") %>%
    count(person_id) %>%
    rename(num_B12_high = n)
glimpse(num_B12_high)

data <- left_join(data, num_B12_high, by = "person_id")
data['num_B12_high'][is.na(data['num_B12_high'])] <- 0
glimpse(data)

num_B12_extreme <- B12_info %>%
    filter(B12_category == "Extreme") %>%
    count(person_id) %>%
    rename(num_B12_extreme = n)
glimpse(num_B12_extreme)

data <- left_join(data, num_B12_extreme, by = "person_id")
data['num_B12_extreme'][is.na(data['num_B12_extreme'])] <- 0
glimpse(data)

num_B12_measurement <- B12_info %>% count(person_id) %>%
    rename(num_B12_measurement = n)
glimpse(num_B12_measurement)

data <- left_join(data, num_B12_measurement, by = "person_id")
glimpse(data)

data <- data %>%
    mutate(B12_category = case_when(num_B12_deficiency >= 1 ~ "Deficiency", 
                                    num_B12_deficiency == 0 & num_B12_borderline >= 1 ~ "Borderline", 
                                    num_B12_deficiency == 0 & num_B12_borderline == 0 & num_B12_extreme >= 1 ~ "Extreme",
                                    num_B12_deficiency == 0 & num_B12_borderline == 0 & num_B12_extreme == 0 & num_B12_high >= 1 ~ "High",
                                    TRUE ~ "Normal")) %>%
    mutate(B12_category = factor(B12_category, levels = c("Deficiency", "Borderline", "Normal", "High", "Extreme")))
glimpse(data)

data <- data %>%
    mutate(have_B12_deficiency = case_when(num_B12_deficiency + num_B12_borderline > 0 ~ "Yes", 
                                           num_B12_deficiency + num_B12_borderline == 0 ~ "No")) %>%
    mutate(have_B12_deficiency = factor(have_B12_deficiency, levels = c("Yes", "No")))
glimpse(data)

data <- data %>% mutate(cohort = case_when(person_id %in% type2_diabetes$person_id & person_id %in% metformin$person_id ~ "Metformin",
                                           !(person_id %in% type2_diabetes$person_id & person_id %in% metformin$person_id) ~ "Non-Metformin"),
                        cohort = factor(cohort, levels = c("Metformin", "Non-Metformin")))
glimpse(data)

data %>% count(cohort)

table(data$cohort, data$B12_category)

#### BEGIN CODING FOR CHARLSON COMORBIDITIES ####
data <- data %>%
    mutate(myocardial_infarction = case_when(person_id %in% myocardial_infarction$person_id ~ 1, TRUE ~ 0),
           congestive_heart_failure = case_when(person_id %in% congestive_heart_failure$person_id ~ 1, TRUE ~ 0),
           peripheral_vascular_disease = case_when(person_id %in% peripheral_vascular_disease$person_id |
                                                   person_id %in% peripheral_vascular_disease2$person_id ~ 1, TRUE ~ 0),
           cerebrovascular_disease = case_when(person_id %in% cerebrovascular_disease$person_id ~ 1, TRUE ~ 0),
           dementia = case_when(person_id %in% dementia$person_id ~ 1, TRUE ~ 0),
           chronic_pulmonary_disease = case_when(person_id %in% chronic_pulmonary_disease$person_id |
                                                 person_id %in% chronic_pulmonary_disease2$person_id ~ 1, TRUE ~ 0),
           rheumatic = case_when(person_id %in% rheumatic$person_id ~ 1, TRUE ~ 0),
           peptic_ulcer_disease = case_when(person_id %in% peptic_ulcer_disease$person_id ~ 1, TRUE ~ 0),
           mild_liver_disease = case_when(person_id %in% mild_liver_disease$person_id |
                                          person_id %in% mild_liver_disease2$person_id ~ 1, TRUE ~ 0),
           diabetes_without_chronic_complication = case_when(person_id %in% diabetes_without_chronic_complication$person_id ~ 1, TRUE ~ 0),
           diabetes_with_chronic_complication = case_when(person_id %in% diabetes_with_chronic_complication$person_id ~ 1, TRUE ~ 0),
           hemiplegia_or_paraplegia = case_when(person_id %in% hemiplegia_or_paraplegia$person_id ~ 1, TRUE ~ 0),
           renal_disease = case_when(person_id %in% renal_disease$person_id |
                                     person_id %in% renal_disease2$person_id |
                                     person_id %in% renal_disease3$person_id ~ 1, TRUE ~ 0),
           any_malignancy = case_when(person_id %in% any_malignancy$person_id ~ 1, TRUE ~ 0),
           moderate_or_severe_liver_disease = case_when(person_id %in% moderate_or_severe_liver_disease$person_id ~ 1, TRUE ~ 0),
           metastatic_solid_tumor = case_when(person_id %in% metastatic_solid_tumor$person_id |
                                              person_id %in% metastatic_solid_tumor2$person_id ~ 1, TRUE ~ 0),
           AIDS_HIV = case_when(person_id %in% AIDS_HIV$person_id ~ 1, TRUE ~ 0))
glimpse(data)

# Calculate Charlson Comorbidity Index (CCI)
data <- data %>% 
    mutate(CCI = myocardial_infarction +
                 congestive_heart_failure + 
                 peripheral_vascular_disease +
                 cerebrovascular_disease +
                 dementia + 
                 chronic_pulmonary_disease +
                 rheumatic +
                 peptic_ulcer_disease + 
                 mild_liver_disease +
                 diabetes_without_chronic_complication +
                 2 * diabetes_with_chronic_complication + 
                 2 * hemiplegia_or_paraplegia +
                 2 * renal_disease +
                 2 * any_malignancy + 
                 3 * moderate_or_severe_liver_disease +
                 6 * metastatic_solid_tumor +
                 6 * AIDS_HIV) %>%
    mutate(CCI = case_when(age < 50 ~ CCI,
                           age >= 50 & age <= 59 ~ CCI + 1,
                           age >= 60 & age <= 69 ~ CCI + 2,
                           age >= 70 & age <= 79 ~ CCI + 3,
                           age >= 80 ~ CCI + 4))
glimpse(data)

data %>% ggplot(aes(x = CCI)) +
    geom_bar(color = "white", fill = "brown")
#### END CODING FOR CHARLSON COMORBIDITIES ####    
    
data_non_metformin <- data %>%
    filter(cohort == "Non-Metformin")
glimpse(data_non_metformin)   

data_metformin <- data %>%
    filter(cohort == "Metformin")
glimpse(data_metformin)

first_metformin <- metformin %>%
    filter(person_id %in% data_metformin$person_id) %>%
    group_by(person_id) %>%
    filter(drug_exposure_start_datetime == min(drug_exposure_start_datetime)) %>%
    distinct(person_id, drug_exposure_start_datetime) %>%
    ungroup()
glimpse(first_metformin)

first_B12_deficiency <- measurement %>%
    filter(person_id %in% data_metformin$person_id) %>%
    filter(value_as_number < 200) %>%
    group_by(person_id) %>%
    filter(measurement_datetime == min(measurement_datetime)) %>%
    distinct(person_id, measurement_datetime) %>%
    ungroup()
glimpse(first_B12_deficiency)

first_B12_borderline <- measurement %>%
    filter(person_id %in% data_metformin$person_id) %>%
    filter(value_as_number >= 200 & value_as_number <= 400) %>%
    group_by(person_id) %>%
    filter(measurement_datetime == min(measurement_datetime)) %>%
    distinct(person_id, measurement_datetime) %>%
    ungroup()
glimpse(first_B12_borderline)

duration_B12_deficiency_before <- inner_join(first_metformin, first_B12_deficiency, by = "person_id") %>%
    filter(measurement_datetime <= drug_exposure_start_datetime) %>%
    mutate(interval_B12_deficiency_before = as.numeric(as_date(drug_exposure_start_datetime) - as_date(measurement_datetime)))
glimpse(duration_B12_deficiency_before)

duration_B12_deficiency_after <- inner_join(first_metformin, first_B12_deficiency, by = "person_id") %>%
    filter(measurement_datetime > drug_exposure_start_datetime) %>%
    mutate(interval_B12_deficiency_after = as.numeric(as_date(measurement_datetime) - as_date(drug_exposure_start_datetime)))
glimpse(duration_B12_deficiency_after)

duration_B12_borderline_before <- inner_join(first_metformin, first_B12_borderline, by = "person_id") %>%
    filter(measurement_datetime <= drug_exposure_start_datetime) %>%
    mutate(interval_B12_borderline_before = as.numeric(as_date(drug_exposure_start_datetime) - as_date(measurement_datetime)))
glimpse(duration_B12_borderline_before)

duration_B12_borderline_after <- inner_join(first_metformin, first_B12_borderline, by = "person_id") %>%
    filter(measurement_datetime > drug_exposure_start_datetime) %>%
    mutate(interval_B12_borderline_after = as.numeric(as_date(measurement_datetime) - as_date(drug_exposure_start_datetime)))
glimpse(duration_B12_borderline_after)

data_metformin <- left_join(data_metformin, duration_B12_deficiency_before, by = "person_id") %>%
    select(-drug_exposure_start_datetime, -measurement_datetime)
data_metformin["interval_B12_deficiency_before"][is.na(data_metformin["interval_B12_deficiency_before"])] <- 0
data_metformin <- data_metformin %>% relocate(interval_B12_deficiency_before, .after = num_B12_measurement)
glimpse(data_metformin)

data_metformin <- left_join(data_metformin, duration_B12_deficiency_after, by = "person_id") %>%
    select(-drug_exposure_start_datetime, -measurement_datetime)
data_metformin["interval_B12_deficiency_after"][is.na(data_metformin["interval_B12_deficiency_after"])] <- 0
data_metformin <- data_metformin %>% relocate(interval_B12_deficiency_after, .after = interval_B12_deficiency_before)
glimpse(data_metformin)

data_metformin <- left_join(data_metformin, duration_B12_borderline_before, by = "person_id") %>%
    select(-drug_exposure_start_datetime, -measurement_datetime)
data_metformin["interval_B12_borderline_before"][is.na(data_metformin["interval_B12_borderline_before"])] <- 0
data_metformin <- data_metformin %>% relocate(interval_B12_borderline_before, .after = interval_B12_deficiency_after)
glimpse(data_metformin)

data_metformin <- left_join(data_metformin, duration_B12_borderline_after, by = "person_id") %>%
    select(-drug_exposure_start_datetime, -measurement_datetime)
data_metformin["interval_B12_borderline_after"][is.na(data_metformin["interval_B12_borderline_after"])] <- 0
data_metformin <- data_metformin %>% relocate(interval_B12_borderline_after, .after = interval_B12_borderline_before)
glimpse(data_metformin)

first_B12_supplement <- B12_supplement %>%
    filter(person_id %in% data_metformin$person_id) %>%
    group_by(person_id) %>%
    filter(drug_exposure_start_datetime == min(drug_exposure_start_datetime)) %>%
    distinct(person_id, drug_exposure_start_datetime) %>%
    ungroup()
glimpse(first_B12_supplement)

B12_supplement_temp <- left_join(first_metformin, first_B12_supplement, by = "person_id") %>%
    mutate(B12_supplement_before = drug_exposure_start_datetime.x > drug_exposure_start_datetime.y) %>%
    mutate(B12_supplement_before = case_when(B12_supplement_before == TRUE ~ "Yes",
                                             B12_supplement_before == FALSE ~ "No",
                                             is.na(B12_supplement_before) ~ "No")) %>%
    mutate(B12_supplement_after = drug_exposure_start_datetime.x <= drug_exposure_start_datetime.y) %>%
    mutate(B12_supplement_after = case_when(B12_supplement_after == TRUE ~ "Yes",
                                            B12_supplement_after == FALSE ~ "No",
                                            is.na(B12_supplement_after) ~ "No")) %>%
    mutate(B12_supplement_before = factor(B12_supplement_before, levels = c("Yes", "No")),
           B12_supplement_after = factor(B12_supplement_after, levels = c("Yes", "No"))) %>%
    select(person_id, B12_supplement_before, B12_supplement_after)
glimpse(B12_supplement_temp)

data_metformin <- left_join(data_metformin, B12_supplement_temp, by = "person_id")
data_metformin <- data_metformin %>% 
    relocate(B12_supplement_before, .after = B12_supplement) %>%
    relocate(B12_supplement_after, .after = B12_supplement_before)
glimpse(data_metformin)

first_PPI <- PPIs %>%
    filter(person_id %in% data_metformin$person_id) %>%
    group_by(person_id) %>%
    filter(drug_exposure_start_datetime == min(drug_exposure_start_datetime)) %>%
    distinct(person_id, drug_exposure_start_datetime) %>%
    ungroup()
glimpse(first_PPI)

last_metformin <- metformin %>%
    filter(person_id %in% data_metformin$person_id) %>%
    group_by(person_id) %>%
    filter(drug_exposure_start_datetime == max(drug_exposure_start_datetime)) %>%
    distinct(person_id, drug_exposure_start_datetime) %>%
    ungroup()
glimpse(last_metformin)

PPIs_temp <- left_join(last_metformin, first_PPI, by = "person_id") %>%
    mutate(PPIs_usage_before = drug_exposure_start_datetime.x > drug_exposure_start_datetime.y) %>%
    mutate(PPIs_usage_before = case_when(PPIs_usage_before == TRUE ~ "Yes",
                                         PPIs_usage_before == FALSE ~ "No",
                                         is.na(PPIs_usage_before) ~ "No")) %>%
    mutate(PPIs_usage_before = factor(PPIs_usage_before, levels = c("Yes", "No"))) %>%
    select(person_id, PPIs_usage_before)
glimpse(PPIs_temp)

data_metformin <- left_join(data_metformin, PPIs_temp, by = "person_id")
data_metformin <- data_metformin %>% 
    relocate(PPIs_usage_before, .after = PPIs_usage) 
glimpse(data_metformin)

data_metformin2 <- data_metformin %>%
    filter(!(person_id %in% duration_B12_deficiency_before$person_id))
glimpse(data_metformin2)

data2 <- data %>%
    filter(!(person_id %in% duration_B12_deficiency_before$person_id))
glimpse(data2)

metformin_3_orders <- metformin %>%
    mutate(drug_exposure_start_date = as.Date(drug_exposure_start_datetime), .before = drug_exposure_start_datetime) %>%
    count(person_id, drug_exposure_start_date) %>%
    count(person_id) %>%
    filter(n >= 3)
glimpse(metformin_3_orders)

metformin_non_diabetes <- metformin %>%
    count(person_id) %>%
    filter(!(person_id %in% type2_diabetes$person_id))
glimpse(metformin_non_diabetes)

# Remove 1,353 participants who use metformin but do not have type 2 diabetes.
data2 <- data2 %>% 
    filter(!(person_id %in% metformin_non_diabetes$person_id))
glimpse(data2)

# Remove 1,538 participants who have less than 3 metformin orders.
data2 <- data2 %>%
    filter(cohort == "Non-Metformin" |
           person_id %in% metformin_3_orders$person_id) 
glimpse(data2)

# Remove 1,538 participants who have less than 3 metformin orders.
data_metformin2 <- data_metformin2 %>%
    filter(person_id %in% metformin_3_orders$person_id) 
glimpse(data_metformin2)

data2 %>% count(cohort)

data2 %>% filter(num_B12_deficiency > 0) %>%
    count(cohort)
    
data2 %>% filter(num_B12_borderline > 0) %>%
    count(cohort)
    
data2 %>% filter(cohort == "Metformin") %>%
    select(age) %>% 
    summary()
    
data2 %>% filter(cohort == "Non-Metformin") %>%
    select(age) %>% 
    summary()
    
data2 %>% filter(cohort == "Metformin") %>%
    select(metformin_year) %>% 
    summary()
    
data2 <- data2 %>%
    mutate(B12_def = case_when(have_B12_deficiency == "Yes" ~ 1,
                               have_B12_deficiency == "No" ~ 0),
           group_metformin = case_when(cohort == "Metformin" ~ 1,
                                       cohort == "Non-Metformin" ~ 0),
           long_term_metformin = case_when(metformin_year >= 6 ~ 1,
                                           metformin_year < 6 ~ 0))
glimpse(data2)

data_metformin_temp <- data2 %>% filter(cohort == "Metformin")
glimpse(data_metformin_temp)

data_metformin_temp %>% count(long_term_metformin)

summary(data2)

data_metformin2 %>% ggplot(aes(x = CCI)) +
    geom_bar(color = "white", fill = "brown")
    
data_non_metformin %>% ggplot(aes(x = CCI)) +
    geom_bar(color = "white", fill = "brown")
    
data_metformin2 %>%
    mutate(myocardial_infarction = as.factor(myocardial_infarction),
           congestive_heart_failure = as.factor(congestive_heart_failure),
           peripheral_vascular_disease = as.factor(peripheral_vascular_disease),
           cerebrovascular_disease = as.factor(cerebrovascular_disease),
           dementia = as.factor(dementia),
           chronic_pulmonary_disease = as.factor(chronic_pulmonary_disease),
           rheumatic = as.factor(rheumatic),
           peptic_ulcer_disease = as.factor(peptic_ulcer_disease),
           mild_liver_disease = as.factor(mild_liver_disease),
           diabetes_without_chronic_complication = as.factor(diabetes_without_chronic_complication),
           diabetes_with_chronic_complication = as.factor(diabetes_with_chronic_complication),
           hemiplegia_or_paraplegia = as.factor(hemiplegia_or_paraplegia),
           renal_disease = as.factor(renal_disease),
           any_malignancy = as.factor(any_malignancy),
           moderate_or_severe_liver_disease = as.factor(moderate_or_severe_liver_disease),
           metastatic_solid_tumor = as.factor(metastatic_solid_tumor),
           AIDS_HIV = as.factor(AIDS_HIV)) %>%
summary()

data_metformin2 %>% count(CCI)

data_non_metformin %>%
    mutate(myocardial_infarction = as.factor(myocardial_infarction),
           congestive_heart_failure = as.factor(congestive_heart_failure),
           peripheral_vascular_disease = as.factor(peripheral_vascular_disease),
           cerebrovascular_disease = as.factor(cerebrovascular_disease),
           dementia = as.factor(dementia),
           chronic_pulmonary_disease = as.factor(chronic_pulmonary_disease),
           rheumatic = as.factor(rheumatic),
           peptic_ulcer_disease = as.factor(peptic_ulcer_disease),
           mild_liver_disease = as.factor(mild_liver_disease),
           diabetes_without_chronic_complication = as.factor(diabetes_without_chronic_complication),
           diabetes_with_chronic_complication = as.factor(diabetes_with_chronic_complication),
           hemiplegia_or_paraplegia = as.factor(hemiplegia_or_paraplegia),
           renal_disease = as.factor(renal_disease),
           any_malignancy = as.factor(any_malignancy),
           moderate_or_severe_liver_disease = as.factor(moderate_or_severe_liver_disease),
           metastatic_solid_tumor = as.factor(metastatic_solid_tumor),
           AIDS_HIV = as.factor(AIDS_HIV)) %>%
summary()

data_non_metformin %>% count(CCI)

summary(data_metformin2$annual_income)
summary(data_non_metformin$annual_income)
summary(data_metformin2$drink_6_more_occurrence)
summary(data_non_metformin$drink_6_more_occurrence)
summary(data_metformin2$average_daily_drink)
summary(data_non_metformin$average_daily_drink)

sd(data_non_metformin$age)
sd(data_non_metformin$average_daily_cigarettes, na.rm=TRUE)
sd(data_non_metformin$current_daily_cigarettes, na.rm=TRUE)
sd(data_non_metformin$smoking_years, na.rm=TRUE)
sd(data_non_metformin$num_metformin)
sd(data_non_metformin$metformin_year)
sd(data_non_metformin$num_B12_supplement)
sd(data_non_metformin$num_PPIs)
sd(data_non_metformin$num_B12_deficiency)
sd(data_non_metformin$num_B12_borderline)
sd(data_non_metformin$num_B12_normal)
sd(data_non_metformin$num_B12_measurement)

sd(data_metformin2$age)
sd(data_metformin2$average_daily_cigarettes, na.rm=TRUE)
sd(data_metformin2$current_daily_cigarettes, na.rm=TRUE)
sd(data_metformin2$smoking_years, na.rm=TRUE)
sd(data_metformin2$num_metformin)
sd(data_metformin2$metformin_year)
sd(data_metformin2$num_B12_supplement)
sd(data_metformin2$num_PPIs)
sd(data_metformin2$num_B12_deficiency)
sd(data_metformin2$num_B12_borderline)
sd(data_metformin2$num_B12_normal)
sd(data_metformin2$num_B12_measurement)

sd(data_metformin2$interval_B12_deficiency_before)
sd(data_metformin2$interval_B12_deficiency_after)
sd(data_metformin2$interval_B12_borderline_before)
sd(data_metformin2$interval_B12_borderline_after)

chisq.test(data2$race, data2$cohort)
chisq.test(data2$ethnicity, data2$cohort)
chisq.test(data2$sex_at_birth, data2$cohort)
chisq.test(data2$education, data2$cohort)
chisq.test(data2$marital_status, data2$cohort)
chisq.test(data2$insurance_status, data2$cohort)
chisq.test(data2$annual_income, data2$cohort)
chisq.test(data2$cigarettes_100, data2$cohort)
chisq.test(data2$smoking_frequency, data2$cohort)
chisq.test(data2$drink_6_more_occurrence, data2$cohort)
chisq.test(data2$average_daily_drink, data2$cohort)
chisq.test(data2$overall_health, data2$cohort)
chisq.test(data2$physical_health, data2$cohort)
chisq.test(data2$mental_health, data2$cohort)
chisq.test(data2$B12_supplement, data2$cohort)
chisq.test(data2$PPIs_usage, data2$cohort)
chisq.test(data2$B12_category, data2$cohort)
wilcox.test(age~cohort, data2)
wilcox.test(average_daily_cigarettes~cohort, data2)
wilcox.test(current_daily_cigarettes~cohort, data2)
wilcox.test(smoking_years~cohort, data2)
wilcox.test(num_metformin~cohort, data2)
wilcox.test(metformin_year~cohort, data2)
wilcox.test(num_B12_supplement~cohort, data2)
wilcox.test(num_PPIs~cohort, data2)
wilcox.test(num_B12_deficiency~cohort, data2)
wilcox.test(num_B12_borderline~cohort, data2)
wilcox.test(num_B12_normal~cohort, data2)
wilcox.test(num_B12_measurement~cohort, data2)
wilcox.test(CCI~cohort, data2)
    













