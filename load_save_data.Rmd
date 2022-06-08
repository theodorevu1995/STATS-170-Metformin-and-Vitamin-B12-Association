library(tidyverse)
library(bigrquery)

# # This query represents dataset "Whole AoU Cohort" for domain "person" and was generated for All of Us Registered Tier Dataset v5
# dataset_28433690_person_sql <- paste("
#     SELECT
#         person.person_id,
#         person.gender_concept_id,
#         p_gender_concept.concept_name as gender,
#         person.birth_datetime as date_of_birth,
#         person.race_concept_id,
#         p_race_concept.concept_name as race,
#         person.ethnicity_concept_id,
#         p_ethnicity_concept.concept_name as ethnicity,
#         person.sex_at_birth_concept_id,
#         p_sex_at_birth_concept.concept_name as sex_at_birth 
#     FROM
#         `person` person 
#     LEFT JOIN
#         `concept` p_gender_concept 
#             ON person.gender_concept_id = p_gender_concept.concept_id 
#     LEFT JOIN
#         `concept` p_race_concept 
#             ON person.race_concept_id = p_race_concept.concept_id 
#     LEFT JOIN
#         `concept` p_ethnicity_concept 
#             ON person.ethnicity_concept_id = p_ethnicity_concept.concept_id 
#     LEFT JOIN
#         `concept` p_sex_at_birth_concept 
#             ON person.sex_at_birth_concept_id = p_sex_at_birth_concept.concept_id  
#     WHERE
#         person.PERSON_ID IN (
#             SELECT
#                 distinct person_id  
#             FROM
#                 `cb_search_person` cb_search_person  
#             WHERE
#                 cb_search_person.person_id IN (
#                     SELECT
#                         person_id 
#                     FROM
#                         `cb_search_person` p 
#                     WHERE
#                         DATE_DIFF(CURRENT_DATE,dob, YEAR) - IF(EXTRACT(MONTH 
#                     FROM
#                         dob)*100 + EXTRACT(DAY 
#                     FROM
#                         dob) > EXTRACT(MONTH 
#                     FROM
#                         CURRENT_DATE)*100 + EXTRACT(DAY 
#                     FROM
#                         CURRENT_DATE),
#                         1,
#                         0) BETWEEN 18 AND 90 
#                         AND NOT EXISTS ( SELECT
#                             'x' 
#                         FROM
#                             `death` d 
#                         WHERE
#                             d.person_id = p.person_id) ) 
#                         AND cb_search_person.person_id IN (SELECT
#                             criteria.person_id 
#                         FROM
#                             (SELECT
#                                 DISTINCT person_id,
#                                 entry_date,
#                                 concept_id 
#                             FROM
#                                 `cb_search_all_events` 
#                             WHERE
#                                 (
#                                     concept_id IN (3011152, 4032173, 3009035, 3000593) 
#                                     AND is_standard = 1 
#                                 )) criteria ) )", sep="")

# # Formulate a Cloud Storage destination path for the data exported from BigQuery.
# # NOTE: By default data exported multiple times on the same day will overwrite older copies.
# #       But data exported on a different days will write to a new location so that historical
# #       copies can be kept as the dataset definition is changed.
# person_28433690_path <- file.path(
#   Sys.getenv("WORKSPACE_BUCKET"),
#   "bq_exports",
#   Sys.getenv("OWNER_EMAIL"),
#   strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
#   "person_28433690",
#   "person_28433690_*.csv")
# message(str_glue('The data will be written to {person_28433690_path}. Use this path when reading ',
#                  'the data into your notebooks in the future.'))

# # Perform the query and export the dataset to Cloud Storage as CSV files.
# # NOTE: You only need to run `bq_table_save` once. After that, you can
# #       just read data from the CSVs in Cloud Storage.
# bq_table_save(
#   bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_28433690_person_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
#   person_28433690_path,
#   destination_format = "CSV")

# # Read the data directly from Cloud Storage into memory.
# # NOTE: Alternatively you can `gsutil -m cp {person_28433690_path}` to copy these files
# #       to the Jupyter disk.
# read_bq_export_from_workspace_bucket <- function(export_path) {
#   col_types <- NULL
#   bind_rows(
#     map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
#         function(csv) {
#           message(str_glue('Loading {csv}.'))
#           chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
#           if (is.null(col_types)) {
#             col_types <- spec(chunk)
#           }
#           chunk
#         }))
# }
# dataset_28433690_person_df <- read_bq_export_from_workspace_bucket(person_28433690_path)

# dim(dataset_28433690_person_df)

# head(dataset_28433690_person_df, 5)

# # This query represents dataset "Whole AoU Cohort" for domain "survey" and was generated for All of Us Registered Tier Dataset v5
# dataset_28433690_survey_sql <- paste("
#     SELECT
#         answer.person_id,
#         answer.survey_datetime,
#         answer.survey,
#         answer.question_concept_id,
#         answer.question,
#         answer.answer_concept_id,
#         answer.answer,
#         answer.survey_version_concept_id,
#         answer.survey_version_name  
#     FROM
#         `ds_survey` answer   
#     WHERE
#         (
#             question_concept_id IN (
#                 SELECT
#                     DISTINCT(question_concept_id) as concept_id  
#                 FROM
#                     `ds_survey` 
#             )
#         )  
#         AND (
#             answer.PERSON_ID IN (
#                 SELECT
#                     distinct person_id  
#                 FROM
#                     `cb_search_person` cb_search_person  
#                 WHERE
#                     cb_search_person.person_id IN (
#                         SELECT
#                             person_id 
#                         FROM
#                             `cb_search_person` p 
#                         WHERE
#                             DATE_DIFF(CURRENT_DATE,dob, YEAR) - IF(EXTRACT(MONTH 
#                         FROM
#                             dob)*100 + EXTRACT(DAY 
#                         FROM
#                             dob) > EXTRACT(MONTH 
#                         FROM
#                             CURRENT_DATE)*100 + EXTRACT(DAY 
#                         FROM
#                             CURRENT_DATE),
#                             1,
#                             0) BETWEEN 18 AND 90 
#                             AND NOT EXISTS ( SELECT
#                                 'x' 
#                             FROM
#                                 `death` d 
#                             WHERE
#                                 d.person_id = p.person_id) ) 
#                             AND cb_search_person.person_id IN (SELECT
#                                 criteria.person_id 
#                             FROM
#                                 (SELECT
#                                     DISTINCT person_id,
#                                     entry_date,
#                                     concept_id 
#                                 FROM
#                                     `cb_search_all_events` 
#                                 WHERE
#                                     (
#                                         concept_id IN (3011152, 4032173, 3009035, 3000593) 
#                                         AND is_standard = 1 
#                                     )) criteria ) ))", sep="")

# # Formulate a Cloud Storage destination path for the data exported from BigQuery.
# # NOTE: By default data exported multiple times on the same day will overwrite older copies.
# #       But data exported on a different days will write to a new location so that historical
# #       copies can be kept as the dataset definition is changed.
# survey_28433690_path <- file.path(
#   Sys.getenv("WORKSPACE_BUCKET"),
#   "bq_exports",
#   Sys.getenv("OWNER_EMAIL"),
#   strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
#   "survey_28433690",
#   "survey_28433690_*.csv")
# message(str_glue('The data will be written to {survey_28433690_path}. Use this path when reading ',
#                  'the data into your notebooks in the future.'))

# # Perform the query and export the dataset to Cloud Storage as CSV files.
# # NOTE: You only need to run `bq_table_save` once. After that, you can
# #       just read data from the CSVs in Cloud Storage.
# bq_table_save(
#   bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_28433690_survey_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
#   survey_28433690_path,
#   destination_format = "CSV")

# # Read the data directly from Cloud Storage into memory.
# # NOTE: Alternatively you can `gsutil -m cp {survey_28433690_path}` to copy these files
# #       to the Jupyter disk.
# read_bq_export_from_workspace_bucket <- function(export_path) {
#   col_types <- NULL
#   bind_rows(
#     map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
#         function(csv) {
#           message(str_glue('Loading {csv}.'))
#           chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
#           if (is.null(col_types)) {
#             col_types <- spec(chunk)
#           }
#           chunk
#         }))
# }
# dataset_28433690_survey_df <- read_bq_export_from_workspace_bucket(survey_28433690_path)

# dim(dataset_28433690_survey_df)

# head(dataset_28433690_survey_df, 5)

# # This query represents dataset "Whole AoU Cohort" for domain "drug" and was generated for All of Us Registered Tier Dataset v5
# dataset_28433690_drug_sql <- paste("
#     SELECT
#         d_exposure.person_id,
#         d_exposure.drug_concept_id,
#         d_standard_concept.concept_name as standard_concept_name,
#         d_standard_concept.concept_code as standard_concept_code,
#         d_standard_concept.vocabulary_id as standard_vocabulary,
#         d_exposure.drug_exposure_start_datetime,
#         d_exposure.drug_exposure_end_datetime,
#         d_exposure.verbatim_end_date,
#         d_exposure.drug_type_concept_id,
#         d_type.concept_name as drug_type_concept_name,
#         d_exposure.stop_reason,
#         d_exposure.refills,
#         d_exposure.quantity,
#         d_exposure.days_supply,
#         d_exposure.sig,
#         d_exposure.route_concept_id,
#         d_route.concept_name as route_concept_name,
#         d_exposure.lot_number,
#         d_exposure.visit_occurrence_id,
#         d_visit.concept_name as visit_occurrence_concept_name,
#         d_exposure.drug_source_value,
#         d_exposure.drug_source_concept_id,
#         d_source_concept.concept_name as source_concept_name,
#         d_source_concept.concept_code as source_concept_code,
#         d_source_concept.vocabulary_id as source_vocabulary,
#         d_exposure.route_source_value,
#         d_exposure.dose_unit_source_value 
#     FROM
#         ( SELECT
#             * 
#         FROM
#             `drug_exposure` d_exposure 
#         WHERE
#             (
#                 drug_concept_id IN  (
#                     SELECT
#                         DISTINCT ca.descendant_id 
#                     FROM
#                         `cb_criteria_ancestor` ca 
#                     JOIN
#                         (
#                             select
#                                 distinct c.concept_id 
#                             FROM
#                                 `cb_criteria` c 
#                             JOIN
#                                 (
#                                     select
#                                         cast(cr.id as string) as id 
#                                     FROM
#                                         `cb_criteria` cr 
#                                     WHERE
#                                         concept_id IN (
#                                             1503297, 21601120, 904453, 948078, 19039926, 911735, 929887, 923645
#                                         ) 
#                                         AND full_text LIKE '%_rank1]%'
#                                 ) a 
#                                     ON (
#                                         c.path LIKE CONCAT('%.',
#                                     a.id,
#                                     '.%') 
#                                     OR c.path LIKE CONCAT('%.',
#                                     a.id) 
#                                     OR c.path LIKE CONCAT(a.id,
#                                     '.%') 
#                                     OR c.path = a.id) 
#                                 WHERE
#                                     is_standard = 1 
#                                     AND is_selectable = 1
#                                 ) b 
#                                     ON (
#                                         ca.ancestor_id = b.concept_id
#                                     )
#                             )
#                         )  
#                         AND (
#                             d_exposure.PERSON_ID IN (
#                                 SELECT
#                                     distinct person_id  
#                             FROM
#                                 `cb_search_person` cb_search_person  
#                             WHERE
#                                 cb_search_person.person_id IN (
#                                     SELECT
#                                         person_id 
#                                     FROM
#                                         `cb_search_person` p 
#                                     WHERE
#                                         DATE_DIFF(CURRENT_DATE,dob, YEAR) - IF(EXTRACT(MONTH 
#                                     FROM
#                                         dob)*100 + EXTRACT(DAY 
#                                     FROM
#                                         dob) > EXTRACT(MONTH 
#                                     FROM
#                                         CURRENT_DATE)*100 + EXTRACT(DAY 
#                                     FROM
#                                         CURRENT_DATE),
#                                         1,
#                                         0) BETWEEN 18 AND 90 
#                                         AND NOT EXISTS ( SELECT
#                                             'x' 
#                                         FROM
#                                             `death` d 
#                                         WHERE
#                                             d.person_id = p.person_id) ) 
#                                         AND cb_search_person.person_id IN (SELECT
#                                             criteria.person_id 
#                                         FROM
#                                             (SELECT
#                                                 DISTINCT person_id,
#                                                 entry_date,
#                                                 concept_id 
#                                             FROM
#                                                 `cb_search_all_events` 
#                                             WHERE
#                                                 (
#                                                     concept_id IN (3011152, 4032173, 3009035, 3000593) 
#                                                     AND is_standard = 1 
#                                                 )) criteria ) ))
#                                 ) d_exposure 
#                             LEFT JOIN
#                                 `concept` d_standard_concept 
#                                     ON d_exposure.drug_concept_id = d_standard_concept.concept_id 
#                             LEFT JOIN
#                                 `concept` d_type 
#                                     ON d_exposure.drug_type_concept_id = d_type.concept_id 
#                             LEFT JOIN
#                                 `concept` d_route 
#                                     ON d_exposure.route_concept_id = d_route.concept_id 
#                             LEFT JOIN
#                                 `visit_occurrence` v 
#                                     ON d_exposure.visit_occurrence_id = v.visit_occurrence_id 
#                             LEFT JOIN
#                                 `concept` d_visit 
#                                     ON v.visit_concept_id = d_visit.concept_id 
#                             LEFT JOIN
#                                 `concept` d_source_concept 
#                                     ON d_exposure.drug_source_concept_id = d_source_concept.concept_id", sep="")

# # Formulate a Cloud Storage destination path for the data exported from BigQuery.
# # NOTE: By default data exported multiple times on the same day will overwrite older copies.
# #       But data exported on a different days will write to a new location so that historical
# #       copies can be kept as the dataset definition is changed.
# drug_28433690_path <- file.path(
#   Sys.getenv("WORKSPACE_BUCKET"),
#   "bq_exports",
#   Sys.getenv("OWNER_EMAIL"),
#   strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
#   "drug_28433690",
#   "drug_28433690_*.csv")
# message(str_glue('The data will be written to {drug_28433690_path}. Use this path when reading ',
#                  'the data into your notebooks in the future.'))

# # Perform the query and export the dataset to Cloud Storage as CSV files.
# # NOTE: You only need to run `bq_table_save` once. After that, you can
# #       just read data from the CSVs in Cloud Storage.
# bq_table_save(
#   bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_28433690_drug_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
#   drug_28433690_path,
#   destination_format = "CSV")

# # Read the data directly from Cloud Storage into memory.
# # NOTE: Alternatively you can `gsutil -m cp {drug_28433690_path}` to copy these files
# #       to the Jupyter disk.
# read_bq_export_from_workspace_bucket <- function(export_path) {
#   col_types <- NULL
#   bind_rows(
#     map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
#         function(csv) {
#           message(str_glue('Loading {csv}.'))
#           chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
#           if (is.null(col_types)) {
#             col_types <- spec(chunk)
#           }
#           chunk
#         }))
# }
# dataset_28433690_drug_df <- read_bq_export_from_workspace_bucket(drug_28433690_path)

# dim(dataset_28433690_drug_df)

# head(dataset_28433690_drug_df, 5)

# # This query represents dataset "Whole AoU Cohort" for domain "condition" and was generated for All of Us Registered Tier Dataset v5
# dataset_28433690_condition_sql <- paste("
#     SELECT
#         c_occurrence.person_id,
#         c_occurrence.condition_concept_id,
#         c_standard_concept.concept_name as standard_concept_name,
#         c_standard_concept.concept_code as standard_concept_code,
#         c_standard_concept.vocabulary_id as standard_vocabulary,
#         c_occurrence.condition_start_datetime,
#         c_occurrence.condition_end_datetime,
#         c_occurrence.condition_type_concept_id,
#         c_type.concept_name as condition_type_concept_name,
#         c_occurrence.stop_reason,
#         c_occurrence.visit_occurrence_id,
#         visit.concept_name as visit_occurrence_concept_name,
#         c_occurrence.condition_source_value,
#         c_occurrence.condition_source_concept_id,
#         c_source_concept.concept_name as source_concept_name,
#         c_source_concept.concept_code as source_concept_code,
#         c_source_concept.vocabulary_id as source_vocabulary,
#         c_occurrence.condition_status_source_value,
#         c_occurrence.condition_status_concept_id,
#         c_status.concept_name as condition_status_concept_name 
#     FROM
#         ( SELECT
#             * 
#         FROM
#             `condition_occurrence` c_occurrence 
#         WHERE
#             (
#                 condition_concept_id IN  (
#                     SELECT
#                         DISTINCT c.concept_id 
#                     FROM
#                         `cb_criteria` c 
#                     JOIN
#                         (
#                             select
#                                 cast(cr.id as string) as id 
#                             FROM
#                                 `cb_criteria` cr 
#                             WHERE
#                                 concept_id IN (
#                                     201826, 4193704
#                                 ) 
#                                 AND full_text LIKE '%_rank1]%'
#                         ) a 
#                             ON (
#                                 c.path LIKE CONCAT('%.',
#                             a.id,
#                             '.%') 
#                             OR c.path LIKE CONCAT('%.',
#                             a.id) 
#                             OR c.path LIKE CONCAT(a.id,
#                             '.%') 
#                             OR c.path = a.id) 
#                         WHERE
#                             is_standard = 1 
#                             AND is_selectable = 1
#                         ) 
#                         OR  condition_source_concept_id IN  (
#                             SELECT
#                                 DISTINCT c.concept_id 
#                             FROM
#                                 `cb_criteria` c 
#                             JOIN
#                                 (
#                                     select
#                                         cast(cr.id as string) as id 
#                                     FROM
#                                         `cb_criteria` cr 
#                                     WHERE
#                                         concept_id IN (
#                                             1326706, 1567641, 37200304, 45586011, 45586144, 45572112, 45572332, 45581352, 45533491, 45567202, 45547504, 45547489, 35208278, 1595598, 37200176, 45542617, 35206201, 35206133, 45572226, 45533459, 45562395, 45562363, 45576999, 45556995, 35208209, 1567491, 37200208, 37200524, 35206212, 35206332, 45571530, 45581246, 45562396, 45562591, 45561845, 45581807, 45566596, 45566651, 35207710, 35208276, 35208040, 35208225, 45601069, 35207671, 45557585, 35207360, 35207408, 1567960, 1595600, 37200170, 37200233, 35209199, 35206071, 45600558, 45581224, 45586598, 45566582, 45566649, 35207792, 35208041, 35208230, 45601279, 45557760, 45557581, 37200217, 37200218, 37200227, 35206160, 35206172, 35206176, 45586064, 45567545, 45557043, 45552824, 45595663, 45601080, 37200251, 35206083, 35206134, 45581350, 45533022, 45581808, 45590932, 45601042, 45605832, 35209279, 35206184, 35206117, 35208368, 45538639, 45561877, 45576364, 45576446, 45557024, 45566628, 45595680, 45601280, 45557567, 35207487, 37200560, 35206064, 45586145, 45581354, 45538635, 45576439, 45605398, 45547539, 35208227, 35208210, 45605830, 45605822, 1569401, 35206234, 35206284, 35206078, 45581230, 45576437, 45557046, 45605302, 35207828, 45601064, 37200261, 45542593, 45542591, 35206128, 45586012, 45600556, 45538138, 45538463, 45576341, 45556973, 45566632, 45605301, 1326607, 37200527, 35206152, 35206190, 35206197, 45572448, 45533017, 45538405, 45586588, 45552805, 35208022, 35207406, 37200232, 35206279, 35206077, 45586031, 45586050, 45572327, 45538411, 45548653, 45606063, 920123, 37200142, 37200521, 37200278, 35206145, 35206223, 35206055, 45600550, 45581359, 45557011, 45566731, 45590956, 45552830, 45605809, 725442, 1326590, 1326705, 37200507, 45542645, 35206088, 45581231, 45552818, 45596426, 35208028, 45557754, 35207399, 35207404, 37200224, 37200538, 35206246, 35206057, 45586033, 45571562, 45581239, 45533475, 45561955, 45577109, 45577119, 45581811, 45586604, 45557116, 45552833, 45595720, 35207833, 35207839, 45548060, 45601043, 920115, 1567676, 1569490, 35207667, 37200180, 37200009, 45542647, 45542635, 35206188, 45581240, 45581243, 45532915, 45538388, 45562371, 45576899, 45595694, 45595805, 45605310, 45606053, 725369, 37200195, 37200539, 37200284, 35206329, 45566636, 45566600, 45591073, 45552281, 35207806, 35207821, 35208228, 45600684, 1568413, 37200157, 37200187, 35206196, 45533466, 45538403, 45562362, 45566595, 45552314, 45596439, 45547623, 45557559, 45561783, 725367, 1567481, 37200188, 45537846, 45591492, 35206186, 35208344, 45581241, 45577095, 45590944, 45595710, 35208063, 920126, 1326492, 35206277, 45572331, 45571567, 45538625, 45576443, 35207803, 35207849, 45547552, 37200143, 35206174, 35205776, 35206054, 45572346, 45533462, 45576348, 45582130, 35208223, 45606047, 35206879, 35206266, 35206061, 45572124, 45600544, 45581257, 45538139, 45566736, 45590940, 45596244, 35207673, 725368, 1567688, 37200189, 45571830, 45581209, 45533483, 45576371, 45586730, 45566630, 45605292, 35207702, 35207755, 45547537, 45606043, 45557554, 1568088, 45591702, 35206224, 35208366, 45571494, 45600540, 45533698, 45538626, 45561850, 45562367, 45576342, 45576365, 45576907, 45595700, 35208207, 37200220, 45537874, 35206165, 35206067, 35206138, 45585993, 45571519, 45600523, 45561838, 45562355, 45576310, 45576904, 45576905, 45543434, 45552819, 35207356, 1567707, 37200168, 35206324, 35206130, 45586070, 45561864, 45576334, 45548036, 45601060, 35205770, 37200501, 37200513, 45542660, 45591471, 35206179, 35206056, 45586037, 45532923, 45538435, 45566643, 45595724, 45547534, 35208024, 37200237, 45591701, 45591496, 35206180, 35206299, 35206084, 35206113, 35206121, 35208343, 45581253, 45533477, 45562459, 45552305, 45605304, 45605306, 35207704, 35207832, 45601071, 37200209, 35206283, 35206094, 35206111, 45571658, 45571552, 45562507, 45576886, 45576895, 45557020, 45543190, 45552809, 45596446, 45595721, 45605807, 1567971, 1567640, 1568293, 37200175, 37200553, 37200306, 35206182, 45571831, 45600508, 45557002, 45590954, 45552304, 45601187, 45605404, 35207393, 1569680, 37200255, 45542668, 35206163, 35206173, 35206191, 35206330, 45586038, 45538444, 45561840, 45567547, 45557001, 45566599, 45590884, 45590949, 35208827, 45601281, 1567633, 35207114, 37200141, 35209275, 35206256, 35206268, 35206275, 35208351, 45577098, 45576896, 45581912, 45581798, 45543443, 45553044, 45552302, 45548116, 45605833, 37200158, 37200214, 37200542, 37200546, 35209197, 45591688, 35206237, 35206063, 35206090, 45586139, 45532944, 45561956, 45562598, 45567417, 45590938, 45590942, 45596442, 45605403, 35208834, 35207823, 45557563, 45537850, 35206227, 35206255, 35206264, 35206265, 35206051, 45600641, 45562709, 45567424, 45605842, 37200147, 37200222, 45537863, 35206428, 35206293, 45586046, 45533478, 45537963, 45576447, 45566642, 45591026, 45553037, 45596214, 45595799, 45605276, 45601285, 1570612, 37200206, 37200545, 35206100, 35206143, 45586068, 45572169, 45572339, 45600535, 45538629, 45566584, 45552285, 45552317, 45552835, 45547554, 35208219, 35207687, 35208015, 37200203, 45591476, 45572079, 45572338, 45600539, 45600554, 45532943, 45561842, 45566735, 45590914, 45595704, 45595716, 45548252, 35207407, 35206081, 35206123, 45561873, 45561817, 37200257, 45542652, 35206328, 35206116, 45585992, 45600517, 45600542, 45581225, 45532951, 45562458, 45590911, 45552385, 35207816, 35207850, 45547486, 45605957, 1571486, 45537877, 45542665, 35206334, 45586053, 45543442, 45543339, 45552823, 45552382, 45596223, 35207827, 45547487, 1567961, 37200199, 37200005, 45562382, 45562393, 45562357, 45576347, 45591030, 45543202, 45596444, 45605268, 45601288, 45605800, 1595486, 45542655, 45542619, 35206243, 45586069, 45571521, 45533436, 45562388, 45576865, 45566729, 45590941, 45543270, 45553171, 45595661, 45595797, 45605288, 35208051, 45605781, 35207674, 37200235, 37200497, 45542629, 45591478, 35206104, 45586047, 45596564, 45533457, 45562600, 45557028, 45590904, 45595795, 35208750, 45548058, 35208212, 35208029, 45605825, 45557762, 45557549, 45561795, 37200229, 37200258, 37200301, 35206170, 35206095, 35206882, 45571523, 45581266, 45533490, 45561841, 45567416, 45547624, 45548027, 35208065, 45557569, 1326603, 37200181, 37200198, 37200216, 37200530, 37200558, 35206122, 45572150, 45533020, 45576909, 45605331, 35208202, 45557572, 35207869, 35208023, 45586014, 45572119, 45566905, 45567181, 45567201, 45581794, 45556994, 45552297, 45605814, 1326601, 37200496, 37200263, 37200548, 45537821, 45537851, 35206244, 35206270, 35206314, 35206059, 45586027, 45586034, 45600637, 45533481, 45576357, 45581810, 45552262, 45553052, 45595842, 45601056, 45557561, 37200262, 37200556, 45542599, 45561819, 45567198, 45557003, 45557016, 45557035, 45552276, 45547550, 45605831, 45557558, 45591501, 35206185, 35206047, 35206320, 45572342, 45600526, 45600639, 45581255, 45538412, 45582127, 45582014, 45590888, 45596221, 45605334, 45605326, 45547633, 45601283, 45605779, 725370, 1567714, 1567944, 37200508, 37200544, 45537834, 45542669, 35206079, 35206141, 45585987, 45600515, 45600567, 45532911, 45567206, 45567208, 45590943, 45543164, 35208235, 35208027, 35208043, 35208016, 37200201, 35209221, 35206203, 35206239, 45571662, 45561859, 45561822, 45566635, 45590929, 45552256, 45595677, 45547621, 45606048, 35208017, 37200190, 35206881, 45572111, 45572116, 45562457, 45576354, 45567210, 45590933, 45552379, 45548269, 35208226, 35208042, 45605405, 1567672, 37200243, 37200502, 45591499, 45581238, 45576358, 45586843, 45543201, 45605269, 45547490, 35207688, 1326591, 37200146, 45542737, 35206217, 35206319, 35206065, 35206327, 45586013, 45571525, 45586836, 45596235, 35207840, 45547626, 45548022, 45548051, 45547535, 35208277, 35209201, 45542738, 45591503, 35206310, 35206331, 35206112, 35206884, 45572097, 45600537, 45543438, 45596432, 45595705, 45605305, 35207843, 35207859, 1595597, 37200160, 37200528, 45542644, 35206192, 35206118, 45572080, 45562105, 45567221, 45543203, 45543208, 35207841, 35208236, 35208050, 35208037, 1595484, 37200247, 45542910, 35206281, 45561860, 45561826, 45557110, 45553168, 45595794, 45601048, 45605834, 45557576, 45557579, 37200561, 45542598, 35206263, 35206099, 45581204, 45581234, 45532959, 45562597, 45577116, 45605802, 1569271, 37200509, 37200302, 37200305, 35206878, 35206286, 45571659, 45571546, 45533700, 45576346, 45567409, 45566593, 45552252, 45605271, 45605320, 45548047, 45548271, 35208204, 45606054, 35207402, 37200159, 35206228, 35206070, 35206086, 35206102, 45532947, 45586838, 45566624, 45590928, 45595717, 35207765, 45548057, 45548270, 725372, 35206216, 35206295, 35206321, 45571537, 45600548, 45581233, 45562384, 45576349, 45586593, 45557021, 45552290, 45596236, 45548030, 35208205, 35207689, 37200171, 37200191, 37200230, 37200291, 45542630, 45542653, 35206109, 45586048, 45572168, 45581235, 45576448, 45577114, 45586731, 45590913, 45543439, 45543196, 45595962, 35207846, 45601286, 37200210, 35206241, 45596565, 45581248, 45538397, 45538000, 45576951, 45566616, 45548259, 1569967, 1567958, 37200269, 37200274, 37200555, 35206236, 35206288, 35208362, 45572114, 45571574, 45567207, 45586611, 45552274, 45595713, 35208213, 35208234, 37200228, 45542615, 35208332, 45532919, 45561853, 45586315, 45586610, 45566607, 45590917, 45553045, 45595712, 45605289, 45605298, 35208753, 45605823, 35207481, 37200200, 35209219, 35209222, 45591559, 45591700, 35206287, 45586066, 45532955, 45561824, 45576343, 45586845, 45586675, 45566733, 45543198, 45595804, 45605317, 35208820, 35208044, 45557548, 35206157, 35208330, 45538419, 45586596, 45566639, 45553051, 35207761, 35207834, 45600806, 35207901, 35207400, 1567966, 1567563, 35206075, 35206142, 45572129, 45571536, 45533493, 45532926, 45538633, 45561825, 45581783, 45547521, 35208224, 45605573, 45605829, 37200225, 37200514, 35206162, 35206193, 45586017, 45581809, 45595719, 45601061, 920127, 35206050, 35206125, 35208349, 35208359, 45600541, 45581229, 45581251, 45532961, 45562365, 45577107, 45557010, 45552806, 45606214, 45557566, 45557672, 1569488, 1567964, 35205769, 35206167, 35206298, 35206306, 35206135, 35208338, 45586055, 45586140, 45572126, 45600640, 45562385, 45552267, 45552286, 45596188, 35207793, 35208232, 45601063, 45605840, 45561794, 45537843, 35206231, 45600507, 45538438, 45576908, 45586842, 45586617, 45557018, 45557040, 45566592, 45552296, 45552308, 35208229, 1567653, 37200156, 37200213, 37200249, 37200265, 37200523, 45537960, 45591822, 35206430, 35206194, 35206195, 35206219, 35206233, 45532963, 45576890, 45567415, 45557257, 45557036, 45548055, 35208215, 37200004, 45542650, 35206053, 45561820, 45576898, 45567211, 45557019, 45547549, 35208231, 45601045, 45605828, 45605816, 1569563, 37200519, 37200526, 45537867, 45542595, 35206259, 35206058, 35206097, 35206139, 35208345, 45586143, 45571547, 45533488, 45561865, 45576366, 45566644, 45591027, 45547625, 35208032, 35205773, 37200006, 45591703, 35206301, 35206098, 45586041, 45586042, 45576369, 45557260, 45595659, 45595793, 45548249, 37200279, 35206198, 45571513, 45600555, 45581222, 45532945, 45576351, 45596232, 1569127, 37200163, 37200164, 37200177, 37200219, 37200532, 45537859, 45591823, 35206066, 45586142, 45600522, 45532937, 45532920, 45538545, 45576356, 45567419, 45581358, 45553046, 35207848, 45601289, 35207686, 37200500, 37200246, 37200510, 35206296, 45586052, 45533441, 45561823, 45582017, 45605270, 35207826, 45547557, 45601029, 1567620, 1567959, 1567675, 37200311, 45537961, 45537962, 45595723, 45605330, 1326493, 35206154, 35206183, 35208350, 45586058, 45571541, 45533472, 45533019, 45576323, 45576325, 45591029, 45553170, 45552301, 45552813, 45596437, 45596247, 35207842, 45601044, 45601072, 45561799, 1569670, 37200192, 35206425, 35206456, 35206250, 45572170, 45572171, 45533024, 45538425, 45576885, 35207812, 35207398, 35206150, 35206290, 35206093, 45586022, 45571497, 45571577, 45600636, 45561844, 45576352, 45576891, 45586597, 45557113, 45590955, 45543269, 45605327, 45548048, 45547488, 45557568, 35207394, 37200239, 45591474, 35206242, 45533479, 45562381, 45595843, 45548039, 45606056, 1567656, 37200155, 37200172, 45542658, 35206161, 35206230, 45571548, 45600510, 45581349, 45533697, 45561947, 45561953, 45567203, 45596215, 45548262, 45547513, 920124, 1567694, 35206144, 35206258, 45572341, 45600547, 45533460, 45581812, 45543204, 45605401, 35207844, 35207851, 45548260, 45605839, 45542736, 35206213, 45532927, 45538636, 45567209, 45557015, 45590908, 45605313, 45606062, 37200166, 35209202, 45537833, 35206148, 35206103, 35206137, 45586063, 45572105, 45600559, 45581247, 45562387, 45561833, 45561849, 45581787, 45590946, 45543187, 45557626, 37200149, 37200152, 37200207, 35209220, 35206253, 35208361, 45571828, 45533456, 45576892, 45567189, 45596440, 1567567, 1568414, 35206451, 45572340, 45581267, 45562108, 45577102, 45595703, 35207809, 45548170, 45547533, 35208218, 35208220, 35225408, 45591497, 45591504, 35206278, 35206294, 45571557, 45571568, 45532939, 45561854, 45576952, 45590967, 45552303, 35208026, 1326602, 1569193, 37200204, 45586045, 45586057, 45600488, 45533169, 45562383, 45561848, 45561852, 45566623, 45595707, 45596222, 45547538, 45548056, 45601287, 37200145, 37200529, 45537868, 45591498, 35206221, 45562373, 45577115, 45567413, 45590931, 45595668, 45595689, 45548034, 45548266, 45601041, 45601052, 45557564, 45561813, 37200202, 45542639, 45591469, 35206189, 35206240, 35206282, 35206062, 35206333, 45566734, 45590916, 45590966, 45548045, 45601047, 45561797, 35207486, 1567969, 35209217, 45542613, 35206153, 35206274, 35206292, 45571569, 45561836, 45567187, 45586833, 45543188, 35207817, 45548261, 45548265, 45557864, 35206453, 35206073, 45533463, 45532912, 45538416, 45567265, 45566903, 45566621, 45595697, 45548059, 45601065, 45557552, 45557865, 45557675, 35207881, 1569178, 45542640, 35206291, 35206305, 35206074, 35206129, 45600543, 45538422, 45538395, 45566629, 45552300, 45548117, 1595601, 45537872, 35206048, 35206120, 45586026, 45572113, 45600642, 45581261, 45533703, 45561866, 45561843, 45582016, 45586839, 45566603, 45596226, 45600807, 45606057, 35207306, 35206276, 45586065, 45561818, 45581801, 45552294, 45596225, 35208832, 35208214, 45606050, 1569671, 1569180, 37200144, 37200186, 35209291, 45591477, 35206164, 35206267, 45533701, 35207804, 35208025, 45606051, 45605838, 37200154, 37200223, 37200504, 35206181, 35206252, 35206096, 45572102, 45572121, 45581211, 45533702, 45561837, 45552801, 45605311, 35207764, 45548076, 45601134, 35207669, 45557557, 1567654, 37200520, 35209274, 45537842, 45542634, 35206156, 35206169, 35206307, 45571550, 45533696, 45576889, 45567418, 45567192, 45566633, 45543199, 45552549, 45595666, 35207810, 45605821, 45557584, 37200007, 45537820, 35206248, 35206106, 35208363, 45586043, 45571579, 45538420, 45561949, 45562340, 45576901, 45567205, 45566637, 45591076, 45552832, 35208751, 45547548, 35208201, 45601066, 45557555, 45557556, 37200260, 35206304, 45572109, 45600511, 45533464, 45561868, 45586316, 45586605, 45586674, 45566614, 45553040, 45605309, 35207831, 35207847, 45557536, 45557562, 35207357, 35206147, 35206202, 35206315, 35206140, 35208347, 45561875, 45576327, 45567216, 45582126, 45566602, 45552825, 35207811, 35207845, 45605806, 45557588, 35208021, 37200554, 35206313, 35206091, 45572172, 45600525, 45561851, 45567204, 35207838, 45548263, 920125, 35209277, 35206214, 35206232, 35206238, 45572098, 45571493, 45571565, 45567266, 35207819, 37200245, 37200512, 37200522, 35206225, 45581236, 45532950, 45538418, 45543189, 45601433, 45605316, 45547544, 35207319, 45542628, 35206218, 35206119, 45586019, 45572344, 45600527, 45557009, 35208825, 35208222, 35208211, 35208033, 45557575, 1569562, 37200499, 35206187, 35206089, 45586021, 45532942, 45586619, 45557039, 45590885, 45595672, 45596068, 45605397, 45548026, 35208020, 35207480, 1326604, 37200165, 35206257, 35206303, 45586035, 45571502, 45533467, 45533468, 45581785, 45557027, 45552827, 35207830, 35207397, 35205772, 45537865, 35206289, 35206309, 45571829, 45581223, 45561847, 45581800, 45552948, 35207813, 45606055, 37200253, 37200559, 37200310, 45537862, 45600638, 45533023, 45562364, 45557026, 45552313, 45548061, 45561807, 1326588, 37200150, 45537852, 45537869, 35206087, 45571654, 45581208, 45552804, 35207358, 1326608, 37200221, 45537847, 45537858, 35208348, 45586060, 45586138, 45600524, 45600528, 45576728, 45577092, 45581795, 45552386, 45552388, 45552260, 45605308, 35207822, 45547551, 45548053, 37200205, 35206300, 35206323, 35206115, 45586039, 45600560, 45567191, 45566594, 45552802, 45552381, 45596234, 45605402, 45605286, 35207762, 35207818, 45548050, 45601073, 37200511, 35209200, 45542594, 45591691, 35206159, 35206209, 45538396, 45561957, 45566645, 45566627, 45553049, 35207824, 35208013, 35207359, 1569492, 45542907, 45591494, 35206211, 45572447, 35206885, 45532960, 45538413, 45586601, 45590964, 45553043, 35208829, 45547503, 1567564, 45542623, 35206297, 35206308, 45586010, 45586018, 45581245, 45562599, 45557045, 45596217, 45596240, 35207405, 1326598, 37200161, 37200531, 45537857, 45542909, 35206072, 35206124, 45567223, 45586623, 45543182, 45595667, 45596438, 35208216, 1326486, 37200234, 35206076, 45561861, 45561863, 45561879, 45557038, 45590890, 45590948, 45543335, 45595701, 45548028, 45557763, 35206251, 45586049, 45532899, 45538390, 45562593, 45567423, 45552259, 45552283, 45552807, 45596212, 45596213, 45547518, 45601058, 45605952, 35209218, 45591699, 35206208, 35208341, 45572329, 45581206, 45538394, 45577105, 45576906, 45567199, 45581797, 35207808, 1569486, 37200506, 45561839, 45577093, 45576336, 45576878, 45586594, 45591033, 45552316, 45548070, 45561798, 37200252, 37200540, 45537840, 35206178, 35206226, 35206316, 35208365, 45572345, 45532952, 45576350, 45548402, 45548046, 45557565, 725440, 37200240, 45591686, 35206151, 35206177, 35206260, 35206085, 35206114, 45533699, 45532932, 45562592, 45561834, 45576363, 45566647, 45552803, 35208831, 35207807, 45547540, 45601284, 45557578, 35208014, 35205771, 37200212, 37200248, 37200543, 35206105, 35206132, 45538431, 45576894, 45567195, 45557034, 45590959, 45590968, 45552947, 35208826, 35208828, 35208206, 35208203, 35208233, 45601038, 37200167, 35209278, 45537870, 45542662, 35206247, 45581353, 45532928, 45561872, 45577104, 45576340, 45567196, 45591031, 35207760, 35207825, 35208036, 37200151, 37200254, 37200549, 35209280, 45591705, 35206229, 35206235, 45571832, 45600545, 45533018, 45538427, 45538408, 45576440, 45552298, 45595684, 37200238, 37200003, 45542637, 35206222, 35206101, 45572117, 45572336, 45600563, 45581205, 45533480, 45538259, 45576368, 45567197, 45596428, 45557553, 45557570, 35207395, 1326484, 45537849, 45537958, 35206158, 35206280, 35206312, 35208331, 45586040, 45600553, 45561948, 45562359, 45566634, 45590930, 45591034, 45543185, 45596436, 35207814, 35207860, 45605819, 45557551, 45542906, 35206175, 45600538, 45532965, 45577108, 45576887, 45556996, 45595681, 45605325, 35208034, 45601133, 37200552, 35206200, 45562379, 45561871, 45577094, 45576438, 45567180, 45581515, 45590960, 45595803, 45605267, 35207837, 45547622, 45601049, 35207685, 45561815, 1326605, 37200211, 37200281, 37200547, 35206171, 35206245, 35206249, 35206326, 35208364, 45567420, 45567426, 45581782, 45553048, 45596233, 37200242, 35225404, 35206049, 35208346, 45571554, 45562370, 45562377, 45576888, 45567422, 45567200, 45581784, 45557022, 45552822, 45552831, 45595798, 35207763, 45600809, 45605805, 35207403, 1569187, 37200185, 37200244, 37200503, 37200275, 37200280, 37200536, 37200551, 45538624, 45562386, 45567188, 45566638, 45590951, 45552946, 35207820, 45601050, 1567988, 45537856, 45542741, 45591820, 35206166, 35206318, 45571551, 45577118, 45576903, 45567406, 45586677, 45543436, 45547627, 35208208, 45601282, 35207684, 35208019, 37200162, 37200541, 45537828, 35206199, 35206068, 45562710, 45581781, 45557033, 45552799, 45596239, 45601434, 45548029, 1569179, 45537832, 45537866, 45537790, 35206146, 35206168, 35206131, 35206136, 45571661, 45576319, 45577117, 45567425, 45552273, 45552383, 45596224, 35207805, 45547514, 45548268, 45601046, 35207488, 1326609, 37200215, 35206155, 35206262, 35206060, 35206325, 35206126, 45581228, 45581355, 45586956, 45586595, 45591198, 45543197, 45552311, 45605284, 45547635, 45547555, 35208217, 35208056, 35209198, 35206069, 35206107, 35206110, 45572446, 45572115, 45581860, 45590909, 45590910, 45595702, 45606064, 725441, 1326606, 37200550, 45542609, 45591319, 35206092, 45572099, 45600644, 45533442, 45576900, 45557112, 45571559, 45566902, 45581516, 45586587, 45590889, 45543435, 45595679, 45595726, 35207815, 35207829, 35207835, 45547760, 45557571, 35207396, 37200148, 35209276, 45537853, 45542664, 45591489, 35206080, 45586054, 45572118, 45572337, 45532958, 45576884, 45576897, 45557023, 45557025, 45590963, 45605329, 45548049, 45561812, 37200153, 37200303, 45542648, 35206322, 45532953, 45533021, 45538392, 45538140, 45561954, 45577100, 45582015, 45586614, 45552826, 45595673, 35208752, 45547543
#                                         ) 
#                                         AND full_text LIKE '%_rank1]%'
#                                 ) a 
#                                     ON (
#                                         c.path LIKE CONCAT('%.',
#                                     a.id,
#                                     '.%') 
#                                     OR c.path LIKE CONCAT('%.',
#                                     a.id) 
#                                     OR c.path LIKE CONCAT(a.id,
#                                     '.%') 
#                                     OR c.path = a.id) 
#                                 WHERE
#                                     is_standard = 0 
#                                     AND is_selectable = 1
#                                 )
#                         )  
#                         AND (
#                             c_occurrence.PERSON_ID IN (
#                                 SELECT
#                                     distinct person_id  
#                                 FROM
#                                     `cb_search_person` cb_search_person  
#                                 WHERE
#                                     cb_search_person.person_id IN (
#                                         SELECT
#                                             person_id 
#                                         FROM
#                                             `cb_search_person` p 
#                                         WHERE
#                                             DATE_DIFF(CURRENT_DATE,dob, YEAR) - IF(EXTRACT(MONTH 
#                                         FROM
#                                             dob)*100 + EXTRACT(DAY 
#                                         FROM
#                                             dob) > EXTRACT(MONTH 
#                                         FROM
#                                             CURRENT_DATE)*100 + EXTRACT(DAY 
#                                         FROM
#                                             CURRENT_DATE),
#                                             1,
#                                             0) BETWEEN 18 AND 90 
#                                             AND NOT EXISTS ( SELECT
#                                                 'x' 
#                                             FROM
#                                                 `death` d 
#                                             WHERE
#                                                 d.person_id = p.person_id) ) 
#                                             AND cb_search_person.person_id IN (SELECT
#                                                 criteria.person_id 
#                                             FROM
#                                                 (SELECT
#                                                     DISTINCT person_id,
#                                                     entry_date,
#                                                     concept_id 
#                                                 FROM
#                                                     `cb_search_all_events` 
#                                                 WHERE
#                                                     (
#                                                         concept_id IN (3011152, 4032173, 3009035, 3000593) 
#                                                         AND is_standard = 1 
#                                                     )) criteria ) ))
#                                     ) c_occurrence 
#                                 LEFT JOIN
#                                     `concept` c_standard_concept 
#                                         ON c_occurrence.condition_concept_id = c_standard_concept.concept_id 
#                                 LEFT JOIN
#                                     `concept` c_type 
#                                         ON c_occurrence.condition_type_concept_id = c_type.concept_id 
#                                 LEFT JOIN
#                                     `visit_occurrence` v 
#                                         ON c_occurrence.visit_occurrence_id = v.visit_occurrence_id 
#                                 LEFT JOIN
#                                     `concept` visit 
#                                         ON v.visit_concept_id = visit.concept_id 
#                                 LEFT JOIN
#                                     `concept` c_source_concept 
#                                         ON c_occurrence.condition_source_concept_id = c_source_concept.concept_id 
#                                 LEFT JOIN
#                                     `concept` c_status 
#                                         ON c_occurrence.condition_status_concept_id = c_status.concept_id", sep="")

# # Formulate a Cloud Storage destination path for the data exported from BigQuery.
# # NOTE: By default data exported multiple times on the same day will overwrite older copies.
# #       But data exported on a different days will write to a new location so that historical
# #       copies can be kept as the dataset definition is changed.
# condition_28433690_path <- file.path(
#   Sys.getenv("WORKSPACE_BUCKET"),
#   "bq_exports",
#   Sys.getenv("OWNER_EMAIL"),
#   strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
#   "condition_28433690",
#   "condition_28433690_*.csv")
# message(str_glue('The data will be written to {condition_28433690_path}. Use this path when reading ',
#                  'the data into your notebooks in the future.'))

# # Perform the query and export the dataset to Cloud Storage as CSV files.
# # NOTE: You only need to run `bq_table_save` once. After that, you can
# #       just read data from the CSVs in Cloud Storage.
# bq_table_save(
#   bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_28433690_condition_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
#   condition_28433690_path,
#   destination_format = "CSV")

# # Read the data directly from Cloud Storage into memory.
# # NOTE: Alternatively you can `gsutil -m cp {condition_28433690_path}` to copy these files
# #       to the Jupyter disk.
# read_bq_export_from_workspace_bucket <- function(export_path) {
#   col_types <- NULL
#   bind_rows(
#     map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
#         function(csv) {
#           message(str_glue('Loading {csv}.'))
#           chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
#           if (is.null(col_types)) {
#             col_types <- spec(chunk)
#           }
#           chunk
#         }))
# }
# dataset_28433690_condition_df <- read_bq_export_from_workspace_bucket(condition_28433690_path)

# dim(dataset_28433690_condition_df)

# head(dataset_28433690_condition_df, 5)

# library(tidyverse)
# library(bigrquery)

# # This query represents dataset "Whole AoU Cohort" for domain "measurement" and was generated for All of Us Registered Tier Dataset v5
# dataset_28433690_measurement_sql <- paste("
#     SELECT
#         measurement.person_id,
#         measurement.measurement_concept_id,
#         m_standard_concept.concept_name as standard_concept_name,
#         m_standard_concept.concept_code as standard_concept_code,
#         m_standard_concept.vocabulary_id as standard_vocabulary,
#         measurement.measurement_datetime,
#         measurement.measurement_type_concept_id,
#         m_type.concept_name as measurement_type_concept_name,
#         measurement.operator_concept_id,
#         m_operator.concept_name as operator_concept_name,
#         measurement.value_as_number,
#         measurement.value_as_concept_id,
#         m_value.concept_name as value_as_concept_name,
#         measurement.unit_concept_id,
#         m_unit.concept_name as unit_concept_name,
#         measurement.range_low,
#         measurement.range_high,
#         measurement.visit_occurrence_id,
#         m_visit.concept_name as visit_occurrence_concept_name,
#         measurement.measurement_source_value,
#         measurement.measurement_source_concept_id,
#         m_source_concept.concept_name as source_concept_name,
#         m_source_concept.concept_code as source_concept_code,
#         m_source_concept.vocabulary_id as source_vocabulary,
#         measurement.unit_source_value,
#         measurement.value_source_value 
#     FROM
#         ( SELECT
#             * 
#         FROM
#             `measurement` measurement 
#         WHERE
#             (
#                 measurement_concept_id IN  (
#                     SELECT
#                         DISTINCT c.concept_id 
#                     FROM
#                         `cb_criteria` c 
#                     JOIN
#                         (
#                             select
#                                 cast(cr.id as string) as id 
#                             FROM
#                                 `cb_criteria` cr 
#                             WHERE
#                                 concept_id IN (
#                                     3011152, 4032173, 3000593, 3009035
#                                 ) 
#                                 AND full_text LIKE '%_rank1]%'
#                         ) a 
#                             ON (
#                                 c.path LIKE CONCAT('%.',
#                             a.id,
#                             '.%') 
#                             OR c.path LIKE CONCAT('%.',
#                             a.id) 
#                             OR c.path LIKE CONCAT(a.id,
#                             '.%') 
#                             OR c.path = a.id) 
#                         WHERE
#                             is_standard = 1 
#                             AND is_selectable = 1
#                         ) 
#                         OR  measurement_source_concept_id IN  (
#                             SELECT
#                                 DISTINCT c.concept_id 
#                             FROM
#                                 `cb_criteria` c 
#                             JOIN
#                                 (
#                                     select
#                                         cast(cr.id as string) as id 
#                                     FROM
#                                         `cb_criteria` cr 
#                                     WHERE
#                                         concept_id IN (
#                                             45600526, 35206332, 35206327, 45552281, 35206328, 45557015, 35206333, 45542630, 45537843, 45552283, 45600528, 35206330
#                                         ) 
#                                         AND full_text LIKE '%_rank1]%'
#                                 ) a 
#                                     ON (
#                                         c.path LIKE CONCAT('%.',
#                                     a.id,
#                                     '.%') 
#                                     OR c.path LIKE CONCAT('%.',
#                                     a.id) 
#                                     OR c.path LIKE CONCAT(a.id,
#                                     '.%') 
#                                     OR c.path = a.id) 
#                                 WHERE
#                                     is_standard = 0 
#                                     AND is_selectable = 1
#                                 )
#                         )  
#                         AND (
#                             measurement.PERSON_ID IN (
#                                 SELECT
#                                     distinct person_id  
#                                 FROM
#                                     `cb_search_person` cb_search_person  
#                                 WHERE
#                                     cb_search_person.person_id IN (
#                                         SELECT
#                                             person_id 
#                                         FROM
#                                             `cb_search_person` p 
#                                         WHERE
#                                             DATE_DIFF(CURRENT_DATE,dob, YEAR) - IF(EXTRACT(MONTH 
#                                         FROM
#                                             dob)*100 + EXTRACT(DAY 
#                                         FROM
#                                             dob) > EXTRACT(MONTH 
#                                         FROM
#                                             CURRENT_DATE)*100 + EXTRACT(DAY 
#                                         FROM
#                                             CURRENT_DATE),
#                                             1,
#                                             0) BETWEEN 18 AND 90 
#                                             AND NOT EXISTS ( SELECT
#                                                 'x' 
#                                             FROM
#                                                 `death` d 
#                                             WHERE
#                                                 d.person_id = p.person_id) ) 
#                                             AND cb_search_person.person_id IN (SELECT
#                                                 criteria.person_id 
#                                             FROM
#                                                 (SELECT
#                                                     DISTINCT person_id,
#                                                     entry_date,
#                                                     concept_id 
#                                                 FROM
#                                                     `cb_search_all_events` 
#                                                 WHERE
#                                                     (
#                                                         concept_id IN (3011152, 4032173, 3009035, 3000593) 
#                                                         AND is_standard = 1 
#                                                     )) criteria ) ))
#                                     ) measurement 
#                                 LEFT JOIN
#                                     `concept` m_standard_concept 
#                                         ON measurement.measurement_concept_id = m_standard_concept.concept_id 
#                                 LEFT JOIN
#                                     `concept` m_type 
#                                         ON measurement.measurement_type_concept_id = m_type.concept_id 
#                                 LEFT JOIN
#                                     `concept` m_operator 
#                                         ON measurement.operator_concept_id = m_operator.concept_id 
#                                 LEFT JOIN
#                                     `concept` m_value 
#                                         ON measurement.value_as_concept_id = m_value.concept_id 
#                                 LEFT JOIN
#                                     `concept` m_unit 
#                                         ON measurement.unit_concept_id = m_unit.concept_id 
#                                 LEFT JOIn
#                                     `visit_occurrence` v 
#                                         ON measurement.visit_occurrence_id = v.visit_occurrence_id 
#                                 LEFT JOIN
#                                     `concept` m_visit 
#                                         ON v.visit_concept_id = m_visit.concept_id 
#                                 LEFT JOIN
#                                     `concept` m_source_concept 
#                                         ON measurement.measurement_source_concept_id = m_source_concept.concept_id", sep="")

# # Formulate a Cloud Storage destination path for the data exported from BigQuery.
# # NOTE: By default data exported multiple times on the same day will overwrite older copies.
# #       But data exported on a different days will write to a new location so that historical
# #       copies can be kept as the dataset definition is changed.
# measurement_28433690_path <- file.path(
#   Sys.getenv("WORKSPACE_BUCKET"),
#   "bq_exports",
#   Sys.getenv("OWNER_EMAIL"),
#   strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
#   "measurement_28433690",
#   "measurement_28433690_*.csv")
# message(str_glue('The data will be written to {measurement_28433690_path}. Use this path when reading ',
#                  'the data into your notebooks in the future.'))

# # Perform the query and export the dataset to Cloud Storage as CSV files.
# # NOTE: You only need to run `bq_table_save` once. After that, you can
# #       just read data from the CSVs in Cloud Storage.
# bq_table_save(
#   bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_28433690_measurement_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
#   measurement_28433690_path,
#   destination_format = "CSV")

# # Read the data directly from Cloud Storage into memory.
# # NOTE: Alternatively you can `gsutil -m cp {measurement_28433690_path}` to copy these files
# #       to the Jupyter disk.
# read_bq_export_from_workspace_bucket <- function(export_path) {
#   col_types <- NULL
#   bind_rows(
#     map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
#         function(csv) {
#           message(str_glue('Loading {csv}.'))
#           chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
#           if (is.null(col_types)) {
#             col_types <- spec(chunk)
#           }
#           chunk
#         }))
# }
# dataset_28433690_measurement_df <- read_bq_export_from_workspace_bucket(measurement_28433690_path)

# dim(dataset_28433690_measurement_df)

# head(dataset_28433690_measurement_df, 5)

# # This query represents dataset "Whole AoU Cohort" for domain "observation" and was generated for All of Us Registered Tier Dataset v5
# dataset_28433690_observation_sql <- paste("
#     SELECT
#         observation.person_id,
#         observation.observation_concept_id,
#         o_standard_concept.concept_name as standard_concept_name,
#         o_standard_concept.concept_code as standard_concept_code,
#         o_standard_concept.vocabulary_id as standard_vocabulary,
#         observation.observation_datetime,
#         observation.observation_type_concept_id,
#         o_type.concept_name as observation_type_concept_name,
#         observation.value_as_number,
#         observation.value_as_string,
#         observation.value_as_concept_id,
#         o_value.concept_name as value_as_concept_name,
#         observation.qualifier_concept_id,
#         o_qualifier.concept_name as qualifier_concept_name,
#         observation.unit_concept_id,
#         o_unit.concept_name as unit_concept_name,
#         observation.visit_occurrence_id,
#         o_visit.concept_name as visit_occurrence_concept_name,
#         observation.observation_source_value,
#         observation.observation_source_concept_id,
#         o_source_concept.concept_name as source_concept_name,
#         o_source_concept.concept_code as source_concept_code,
#         o_source_concept.vocabulary_id as source_vocabulary,
#         observation.unit_source_value,
#         observation.qualifier_source_value,
#         observation.value_source_concept_id,
#         observation.value_source_value,
#         observation.questionnaire_response_id 
#     FROM
#         ( SELECT
#             * 
#         FROM
#             `observation` observation 
#         WHERE
#             (
#                 observation_source_concept_id IN (
#                     45576218, 45605178, 45585835, 35225436, 35225404, 45576217, 35208018, 45609945, 45576220, 35225419, 45595565, 45576219, 35225408
#                 )
#             )  
#             AND (
#                 observation.PERSON_ID IN (
#                     SELECT
#                         distinct person_id  
#                     FROM
#                         `cb_search_person` cb_search_person  
#                     WHERE
#                         cb_search_person.person_id IN (
#                             SELECT
#                                 person_id 
#                             FROM
#                                 `cb_search_person` p 
#                             WHERE
#                                 DATE_DIFF(CURRENT_DATE,dob, YEAR) - IF(EXTRACT(MONTH 
#                             FROM
#                                 dob)*100 + EXTRACT(DAY 
#                             FROM
#                                 dob) > EXTRACT(MONTH 
#                             FROM
#                                 CURRENT_DATE)*100 + EXTRACT(DAY 
#                             FROM
#                                 CURRENT_DATE),
#                                 1,
#                                 0) BETWEEN 18 AND 90 
#                                 AND NOT EXISTS ( SELECT
#                                     'x' 
#                                 FROM
#                                     `death` d 
#                                 WHERE
#                                     d.person_id = p.person_id) ) 
#                                 AND cb_search_person.person_id IN (SELECT
#                                     criteria.person_id 
#                                 FROM
#                                     (SELECT
#                                         DISTINCT person_id,
#                                         entry_date,
#                                         concept_id 
#                                     FROM
#                                         `cb_search_all_events` 
#                                     WHERE
#                                         (
#                                             concept_id IN (3011152, 4032173, 3009035, 3000593) 
#                                             AND is_standard = 1 
#                                         )) criteria ) ))
#                         ) observation 
#                     LEFT JOIN
#                         `concept` o_standard_concept 
#                             ON observation.observation_concept_id = o_standard_concept.concept_id 
#                     LEFT JOIN
#                         `concept` o_type 
#                             ON observation.observation_type_concept_id = o_type.concept_id 
#                     LEFT JOIN
#                         `concept` o_value 
#                             ON observation.value_as_concept_id = o_value.concept_id 
#                     LEFT JOIN
#                         `concept` o_qualifier 
#                             ON observation.qualifier_concept_id = o_qualifier.concept_id 
#                     LEFT JOIN
#                         `concept` o_unit 
#                             ON observation.unit_concept_id = o_unit.concept_id 
#                     LEFT JOIN
#                         `visit_occurrence` v 
#                             ON observation.visit_occurrence_id = v.visit_occurrence_id 
#                     LEFT JOIN
#                         `concept` o_visit 
#                             ON v.visit_concept_id = o_visit.concept_id 
#                     LEFT JOIN
#                         `concept` o_source_concept 
#                             ON observation.observation_source_concept_id = o_source_concept.concept_id", sep="")

# # Formulate a Cloud Storage destination path for the data exported from BigQuery.
# # NOTE: By default data exported multiple times on the same day will overwrite older copies.
# #       But data exported on a different days will write to a new location so that historical
# #       copies can be kept as the dataset definition is changed.
# observation_28433690_path <- file.path(
#   Sys.getenv("WORKSPACE_BUCKET"),
#   "bq_exports",
#   Sys.getenv("OWNER_EMAIL"),
#   strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
#   "observation_28433690",
#   "observation_28433690_*.csv")
# message(str_glue('The data will be written to {observation_28433690_path}. Use this path when reading ',
#                  'the data into your notebooks in the future.'))

# # Perform the query and export the dataset to Cloud Storage as CSV files.
# # NOTE: You only need to run `bq_table_save` once. After that, you can
# #       just read data from the CSVs in Cloud Storage.
# bq_table_save(
#   bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_28433690_observation_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
#   observation_28433690_path,
#   destination_format = "CSV")

# # Read the data directly from Cloud Storage into memory.
# # NOTE: Alternatively you can `gsutil -m cp {observation_28433690_path}` to copy these files
# #       to the Jupyter disk.
# read_bq_export_from_workspace_bucket <- function(export_path) {
#   col_types <- NULL
#   bind_rows(
#     map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
#         function(csv) {
#           message(str_glue('Loading {csv}.'))
#           chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
#           if (is.null(col_types)) {
#             col_types <- spec(chunk)
#           }
#           chunk
#         }))
# }
# dataset_28433690_observation_df <- read_bq_export_from_workspace_bucket(observation_28433690_path)

# dim(dataset_28433690_observation_df)

# head(dataset_28433690_observation_df, 5)

# # This query represents dataset "Whole AoU Cohort" for domain "procedure" and was generated for All of Us Registered Tier Dataset v5
# dataset_28433690_procedure_sql <- paste("
#     SELECT
#         procedure.person_id,
#         procedure.procedure_concept_id,
#         p_standard_concept.concept_name as standard_concept_name,
#         p_standard_concept.concept_code as standard_concept_code,
#         p_standard_concept.vocabulary_id as standard_vocabulary,
#         procedure.procedure_datetime,
#         procedure.procedure_type_concept_id,
#         p_type.concept_name as procedure_type_concept_name,
#         procedure.modifier_concept_id,
#         p_modifier.concept_name as modifier_concept_name,
#         procedure.quantity,
#         procedure.visit_occurrence_id,
#         p_visit.concept_name as visit_occurrence_concept_name,
#         procedure.procedure_source_value,
#         procedure.procedure_source_concept_id,
#         p_source_concept.concept_name as source_concept_name,
#         p_source_concept.concept_code as source_concept_code,
#         p_source_concept.vocabulary_id as source_vocabulary,
#         procedure.qualifier_source_value 
#     FROM
#         ( SELECT
#             * 
#         FROM
#             `procedure_occurrence` procedure 
#         WHERE
#             (
#                 procedure_source_concept_id IN  (
#                     SELECT
#                         DISTINCT c.concept_id 
#                     FROM
#                         `cb_criteria` c 
#                     JOIN
#                         (
#                             select
#                                 cast(cr.id as string) as id 
#                             FROM
#                                 `cb_criteria` cr 
#                             WHERE
#                                 concept_id IN (
#                                     45585835, 45609945
#                                 ) 
#                                 AND full_text LIKE '%_rank1]%'
#                         ) a 
#                             ON (
#                                 c.path LIKE CONCAT('%.',
#                             a.id,
#                             '.%') 
#                             OR c.path LIKE CONCAT('%.',
#                             a.id) 
#                             OR c.path LIKE CONCAT(a.id,
#                             '.%') 
#                             OR c.path = a.id) 
#                         WHERE
#                             is_standard = 0 
#                             AND is_selectable = 1
#                         )
#                 )  
#                 AND (
#                     procedure.PERSON_ID IN (
#                         SELECT
#                             distinct person_id  
#                         FROM
#                             `cb_search_person` cb_search_person  
#                         WHERE
#                             cb_search_person.person_id IN (
#                                 SELECT
#                                     person_id 
#                                 FROM
#                                     `cb_search_person` p 
#                                 WHERE
#                                     DATE_DIFF(CURRENT_DATE,dob, YEAR) - IF(EXTRACT(MONTH 
#                                 FROM
#                                     dob)*100 + EXTRACT(DAY 
#                                 FROM
#                                     dob) > EXTRACT(MONTH 
#                                 FROM
#                                     CURRENT_DATE)*100 + EXTRACT(DAY 
#                                 FROM
#                                     CURRENT_DATE),
#                                     1,
#                                     0) BETWEEN 18 AND 90 
#                                     AND NOT EXISTS ( SELECT
#                                         'x' 
#                                     FROM
#                                         `death` d 
#                                     WHERE
#                                         d.person_id = p.person_id) ) 
#                                     AND cb_search_person.person_id IN (SELECT
#                                         criteria.person_id 
#                                     FROM
#                                         (SELECT
#                                             DISTINCT person_id,
#                                             entry_date,
#                                             concept_id 
#                                         FROM
#                                             `cb_search_all_events` 
#                                         WHERE
#                                             (
#                                                 concept_id IN (3011152, 4032173, 3009035, 3000593) 
#                                                 AND is_standard = 1 
#                                             )) criteria ) ))
#                             ) procedure 
#                         LEFT JOIN
#                             `concept` p_standard_concept 
#                                 ON procedure.procedure_concept_id = p_standard_concept.concept_id 
#                         LEFT JOIN
#                             `concept` p_type 
#                                 ON procedure.procedure_type_concept_id = p_type.concept_id 
#                         LEFT JOIN
#                             `concept` p_modifier 
#                                 ON procedure.modifier_concept_id = p_modifier.concept_id 
#                         LEFT JOIN
#                             `visit_occurrence` v 
#                                 ON procedure.visit_occurrence_id = v.visit_occurrence_id 
#                         LEFT JOIN
#                             `concept` p_visit 
#                                 ON v.visit_concept_id = p_visit.concept_id 
#                         LEFT JOIN
#                             `concept` p_source_concept 
#                                 ON procedure.procedure_source_concept_id = p_source_concept.concept_id", sep="")

# # Formulate a Cloud Storage destination path for the data exported from BigQuery.
# # NOTE: By default data exported multiple times on the same day will overwrite older copies.
# #       But data exported on a different days will write to a new location so that historical
# #       copies can be kept as the dataset definition is changed.
# procedure_28433690_path <- file.path(
#   Sys.getenv("WORKSPACE_BUCKET"),
#   "bq_exports",
#   Sys.getenv("OWNER_EMAIL"),
#   strftime(lubridate::now(), "%Y%m%d"),  # Comment out this line if you want the export to always overwrite.
#   "procedure_28433690",
#   "procedure_28433690_*.csv")
# message(str_glue('The data will be written to {procedure_28433690_path}. Use this path when reading ',
#                  'the data into your notebooks in the future.'))

# # Perform the query and export the dataset to Cloud Storage as CSV files.
# # NOTE: You only need to run `bq_table_save` once. After that, you can
# #       just read data from the CSVs in Cloud Storage.
# bq_table_save(
#   bq_dataset_query(Sys.getenv("WORKSPACE_CDR"), dataset_28433690_procedure_sql, billing = Sys.getenv("GOOGLE_PROJECT")),
#   procedure_28433690_path,
#   destination_format = "CSV")

# # Read the data directly from Cloud Storage into memory.
# # NOTE: Alternatively you can `gsutil -m cp {procedure_28433690_path}` to copy these files
# #       to the Jupyter disk.
# read_bq_export_from_workspace_bucket <- function(export_path) {
#   col_types <- NULL
#   bind_rows(
#     map(system2('gsutil', args = c('ls', export_path), stdout = TRUE, stderr = TRUE),
#         function(csv) {
#           message(str_glue('Loading {csv}.'))
#           chunk <- read_csv(pipe(str_glue('gsutil cat {csv}')), col_types = col_types, show_col_types = FALSE)
#           if (is.null(col_types)) {
#             col_types <- spec(chunk)
#           }
#           chunk
#         }))
# }
# dataset_28433690_procedure_df <- read_bq_export_from_workspace_bucket(procedure_28433690_path)

# dim(dataset_28433690_procedure_df)

# head(dataset_28433690_procedure_df, 5)

### BEGIN Saving Data to Workspace

# # This snippet assumes that you run setup first

# # This code saves your dataframe into a csv file in a "data" folder in Google Bucket

# # Replace df with THE NAME OF YOUR DATAFRAME
# my_dataframe <- dataset_28433690_person_df

# # Replace 'test.csv' with THE NAME of the file you're going to store in the bucket (don't delete the quotation marks)
# destination_filename <- 'people.csv'

# ########################################################################
# ##
# ################# DON'T CHANGE FROM HERE ###############################
# ##
# ########################################################################

# # store the dataframe in current workspace
# write_excel_csv(my_dataframe, destination_filename)

# # Get the bucket name
# my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# # Copy the file from current workspace to the bucket
# system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

# # Check if file is in the bucket
# system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)

# # This snippet assumes that you run setup first

# # This code saves your dataframe into a csv file in a "data" folder in Google Bucket

# # Replace df with THE NAME OF YOUR DATAFRAME
# my_dataframe <- dataset_28433690_survey_df

# # Replace 'test.csv' with THE NAME of the file you're going to store in the bucket (don't delete the quotation marks)
# destination_filename <- 'survey.csv'

# ########################################################################
# ##
# ################# DON'T CHANGE FROM HERE ###############################
# ##
# ########################################################################

# # store the dataframe in current workspace
# write_excel_csv(my_dataframe, destination_filename)

# # Get the bucket name
# my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# # Copy the file from current workspace to the bucket
# system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

# # Check if file is in the bucket
# system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)

# # This snippet assumes that you run setup first

# # This code saves your dataframe into a csv file in a "data" folder in Google Bucket

# # Replace df with THE NAME OF YOUR DATAFRAME
# my_dataframe <- dataset_28433690_drug_df

# # Replace 'test.csv' with THE NAME of the file you're going to store in the bucket (don't delete the quotation marks)
# destination_filename <- 'drug.csv'

# ########################################################################
# ##
# ################# DON'T CHANGE FROM HERE ###############################
# ##
# ########################################################################

# # store the dataframe in current workspace
# write_excel_csv(my_dataframe, destination_filename)

# # Get the bucket name
# my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# # Copy the file from current workspace to the bucket
# system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

# # Check if file is in the bucket
# system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)

# # This snippet assumes that you run setup first

# # This code saves your dataframe into a csv file in a "data" folder in Google Bucket

# # Replace df with THE NAME OF YOUR DATAFRAME
# my_dataframe <- dataset_28433690_condition_df

# # Replace 'test.csv' with THE NAME of the file you're going to store in the bucket (don't delete the quotation marks)
# destination_filename <- 'condition.csv'

# ########################################################################
# ##
# ################# DON'T CHANGE FROM HERE ###############################
# ##
# ########################################################################

# # store the dataframe in current workspace
# write_excel_csv(my_dataframe, destination_filename)

# # Get the bucket name
# my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# # Copy the file from current workspace to the bucket
# system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

# # Check if file is in the bucket
# system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)

# # This snippet assumes that you run setup first

# # This code saves your dataframe into a csv file in a "data" folder in Google Bucket

# # Replace df with THE NAME OF YOUR DATAFRAME
# my_dataframe <- dataset_28433690_observation_df

# # Replace 'test.csv' with THE NAME of the file you're going to store in the bucket (don't delete the quotation marks)
# destination_filename <- 'observation.csv'

# ########################################################################
# ##
# ################# DON'T CHANGE FROM HERE ###############################
# ##
# ########################################################################

# # store the dataframe in current workspace
# write_excel_csv(my_dataframe, destination_filename)

# # Get the bucket name
# my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# # Copy the file from current workspace to the bucket
# system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

# # Check if file is in the bucket
# system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)

# # This snippet assumes that you run setup first

# # This code saves your dataframe into a csv file in a "data" folder in Google Bucket

# # Replace df with THE NAME OF YOUR DATAFRAME
# my_dataframe <- dataset_28433690_procedure_df

# # Replace 'test.csv' with THE NAME of the file you're going to store in the bucket (don't delete the quotation marks)
# destination_filename <- 'procedure.csv'

# ########################################################################
# ##
# ################# DON'T CHANGE FROM HERE ###############################
# ##
# ########################################################################

# # store the dataframe in current workspace
# write_excel_csv(my_dataframe, destination_filename)

# # Get the bucket name
# my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# # Copy the file from current workspace to the bucket
# system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

# # Check if file is in the bucket
# system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)

# # This snippet assumes that you run setup first

# # This code saves your dataframe into a csv file in a "data" folder in Google Bucket

# # Replace df with THE NAME OF YOUR DATAFRAME
# my_dataframe <- dataset_28433690_measurement_df

# # Replace 'test.csv' with THE NAME of the file you're going to store in the bucket (don't delete the quotation marks)
# destination_filename <- 'measurement.csv'

# ########################################################################
# ##
# ################# DON'T CHANGE FROM HERE ###############################
# ##
# ########################################################################

# # store the dataframe in current workspace
# write_excel_csv(my_dataframe, destination_filename)

# # Get the bucket name
# my_bucket <- Sys.getenv('WORKSPACE_BUCKET')

# # Copy the file from current workspace to the bucket
# system(paste0("gsutil cp ./", destination_filename, " ", my_bucket, "/data/"), intern=T)

# # Check if file is in the bucket
# system(paste0("gsutil ls ", my_bucket, "/data/*.csv"), intern=T)

### END Saving Data to Workspace ###
