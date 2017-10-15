Getting and Cleaning Data - Course Project
==========================================

This repository contains the course project for Getting and Cleaning Data from from Coursera.

----------


 <i class="icon-file"></i>Data Source
--------------------------------------------------------------

The data is about an experiment with 30 volunteer wearing a smartphone on the waist.
They did 6 different activities (Walking, Walking Upstairs, Walking Downstairs, Sitting, Standing, Laying). With different embedded sensors (Accelerometer and Gyroscope), they registered the values that they got in the activities. 

The whole data is available in
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip


#### Structure
I only show the files considered for the analysis.

├── <i class="icon-folder-open"></i>UCI HAR Dataset
│   ├── <i class="icon-file"></i> activity-labels.txt
│   ├── <i class="icon-file"></i> features.txt
│   ├── <i class="icon-folder-open"></i> test
│   │   ├── <i class="icon-file"></i> subject_test.txt
│   │   ├── <i class="icon-file"></i> X_test.txt
│   │   ├── <i class="icon-file"></i> y_test.txt
│   ├── <i class="icon-folder-open"></i> train
│   │   ├── <i class="icon-file"></i> subject_train.txt
│   │   ├── <i class="icon-file"></i> X_train.txt
│   │   ├── <i class="icon-file"></i> y_train.txt




#### <i class="icon-info"></i> Files Information

- 'activity_labels.txt': Links the class labels with their activity name.
- 'features.txt': List of all features.
- 'train/subject_train.txt': Each row identifies the subject who performed the activity in training data for each window sample. Its range is from 1 to 30. 
- 'train/X_train.txt': Training set.
- 'train/y_train.txt': Training labels.
- 'test/subject_test.txt': Each row identifies the subject who performed the activity in test data for each window sample. Its range is from 1 to 30. 
- 'test/X_test.txt': Test set.
- 'test/y_test.txt': Test labels.

 <i class="icon-search"></i>Analysis
--------------------------------------------------------------

The objective for the project is to create a tidy data set. Basically, I used a process with 4 steps to complete the objective.

- **Load the data and rename columns**: in this step I loaded all the files in [Structure](#structure) section and rename some columns of the data.

-   **Extract the correct data into features data set**: I extracted just the data with mean and std in the columns of features  data set, and then we clean the names of that columns.

-   **Bind and merge data**: in this step, we changed the column names of "X" from  the columns that I got from features data set. Then I bonded rows for "X" data, the training and test data. For "Y" data I took the same actions. Finally I merged and bonded all the data sets(X data, Y data, and subject) in one data set.

-   **Create a second and independent data set**: regardless from the previous steps, this step calculate the average of the data grouped by feature, activity and subject.

All this steps and actions are in run_analysis.R script.

> **Note:** This steps are brief details about the work. Each step include more actions that you could realize in the run_analysis script.