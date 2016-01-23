# Getting and Cleaning Data - Course Project

The R script, `run_analysis.R`, 

1. Download site data if it does not already in the working directory
2. Unzips the `Dataset.zip` file unless data is already extracted
3. Load the activity labels and feature data
4. Select the mean and standard deviation features only to be used to limit data used
5. Clean up the feature names for readablity (will be used as column names later)
6. Loads both the training and test datasets, keeping only those columns which
   reflect a mean or standard deviation. 
7. Use cbind to link the three file types to generate two datasets (train, test)
8. Merge the two datasets using rbind
9. Add descriptive column names generated in step 5 to dataset
10. Add enumeration / labels for activity and subject columns converting to factors
11. Pivot data using melt using the identity columns acitivity and subject
12. Calculate means for all varibles and pivot data back on identity columns using dcast
13. Output end results in the file `tidy.txt`.