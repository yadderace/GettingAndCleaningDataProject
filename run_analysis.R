library(dplyr);
library(tidyr);

MEAN_STD_REGEX <- '-(mean|std)\\(\\)';
FEATURE_NAME <- "FeatureName";
ACTIVITY_CODE <- "ActivityCode";
ACTIVITY_NAME <- "ActivityName";
DATA_TYPE <- "DataType";
TEST_DATA <- "Test";
TRAINING_DATA <- "Training";
SUBJECT_cODE <- "SubjectCode";

#               1. LOAD DATA  
###################################################
#  Read the downloaded files and then covert them #
#  into tables.                                   #
###################################################

####### LOAD TEST DATA 
test_x <- tbl_df(read.table("test/X_test.txt"));
test_y <- tbl_df(read.table("test/y_test.txt"));
test_subject <- tbl_df(read.table("test/subject_test.txt"));
names(test_subject)[1] <- SUBJECT_cODE;

####### LOAD TRAIN DATA
train_x <- tbl_df(read.table("train/X_train.txt"));
train_y <- tbl_df(read.table("train/y_train.txt"));
train_subject <- tbl_df(read.table("train/subject_train.txt"));
names(train_subject)[1] <- SUBJECT_cODE;

####### LOAD FEATURES DATA
features <- tbl_df(read.table("features.txt"));
names(features)[2] <- FEATURE_NAME;

####### LOAD ACTIVITIES DATA
activities <- tbl_df(read.table("activity_labels.txt"));
names(activities)[1] <- ACTIVITY_CODE;
names(activities)[2] <- ACTIVITY_NAME;


#           2. EXTRACT FEATURES DATA
###################################################
#   Find into the feature table the activities    #
#   who contain mean and std.                     #
###################################################

##### GET NUMBER OF COLUMNS OF DATA FOR MEAN AND STANDARD DEVIATION
mean_and_std_columns <- grep(MEAN_STD_REGEX, features$FeatureName);

##### FILTER MEAN AND STD INFORMATION
mean_and_std_data <- filter(features, grepl(MEAN_STD_REGEX, FeatureName));

##### CLEAN FEATURES NAMES
mean_and_std_data <- mean_and_std_data %>% 
  mutate(FeatureName = gsub("^(f|t)", replacement = "", FeatureName)) %>%
  mutate(FeatureName = gsub("mean", replacement = "Mean", FeatureName)) %>%
  mutate(FeatureName = gsub("std", replacement = "Std", FeatureName)) %>%
  mutate(FeatureName = gsub("(\\(|\\)|-)", replacement = "", FeatureName));


#           3. BIND AND MERGE DATA 
###################################################
#   ADD COLUMN NAMES TO DATA SETS                 #
#   BIND THE DATA SETS                            #
#   MERGE DATA SET ACCORDING ID                   #
###################################################

##### CHANGE THE NAMES FOR COLUMNS IN "X" DATA
test_x <- select(test_x, mean_and_std_columns);
train_x <- select(train_x, mean_and_std_columns);
names(test_x) <- mean_and_std_data$FeatureName;
names(train_x) <- mean_and_std_data$FeatureName;

##### ADD TYPE OF DATA AND SUBJECT
test_x <- bind_cols(test_subject, test_x);
train_x <- bind_cols(train_subject, train_x);

test_x <- mutate(test_x, DataType = TEST_DATA);
train_x <- mutate(train_x, DataType = TRAINING_DATA);


##### BIND THE TEST AND TRAINING DATA
test_train_x <- bind_rows(test_x, train_x);
test_train_y <- bind_rows(test_y, train_y);
names(test_train_y)[1] <- ACTIVITY_CODE;


##### JOIN ACTIVITIES LABELS AND "Y" DATA
test_train_y <- inner_join(activities, test_train_y, by = ACTIVITY_CODE);

#### BIND ALL DATA
human_activity_data_set <- bind_cols(test_train_y, test_train_x);
tidy_human_activity_data_set <- gather(human_activity_data_set, Feature, Value, -c(ActivityCode, ActivityName, SubjectCode, DataType));


#           4. CREATE SECOND DATA SET
###################################################
#     FROM TIDY DATA CREATE ANOTHER DATA SET      #
#     WITH AVERAGE FROM ACTIVITY, SUBJECT AND     #
#     FEATURE                                     #
###################################################

grouped_tidy_data <- group_by(tidy_human_activity_data_set, ActivityCode, ActivityName, SubjectCode, Feature);
average_tidy_data <- summarise(grouped_tidy_data, mean(Value));