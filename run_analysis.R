# Create filepaths for the files that I require
mainDir = "UCI HAR Dataset/"
fileLocationTrainSub = paste(mainDir, "train/subject_train.txt", sep="")
fileLocationTrainX = paste(mainDir, "train/X_train.txt", sep="")
fileLocationTrainY = paste(mainDir, "train/y_train.txt", sep="")
fileLocationTestSub = paste(mainDir, "test/subject_test.txt", sep="")
fileLocationTestX = paste(mainDir, "test/X_test.txt", sep="")
fileLocationTestY = paste(mainDir, "test/y_test.txt", sep="")
fileLocationFeatureNames = paste(mainDir, "features.txt", sep="")

# Load in the training set
train_sub = read.table(fileLocationTrainSub, header = F)
train_X = read.table(fileLocationTrainX, header = F)
train_y = read.table(fileLocationTrainY, header = F)
training = cbind(train_sub, train_X, train_y)

# Load in the testing set
test_sub = read.table(fileLocationTestSub, header = F)
test_X = read.table(fileLocationTestX, header = F)
test_y = read.table(fileLocationTestY, header = F)
testing = cbind(test_sub, test_X, test_y)

dataSet = rbind(training, testing)

# Create a vector of the column header names
features = scan(fileLocationFeatureNames, sep=" ", what = "character")[c(FALSE, TRUE)]
features = c("Subject", features, "Activity")

names(dataSet) = features

# Filter the column headers to only have std and mean
cols = grep("[Mm]ean|std|Activity|Subject",colnames(dataSet))
dataSet = dataSet[cols]

# Clean up column names
cleanNames = gsub("\\(\\)", "", names(dataSet))
cleanNames = gsub("[,-]", ".", cleanNames)
cleanNames = gsub("\\(", ".", cleanNames)
cleanNames = gsub("\\)", "", cleanNames)

# Replace number labels with factors
names(dataSet) = cleanNames
activities = c("Walking", "Walking.Upstairs", "Walking.Downstairs", "Sitting", "Standing", "Laying")
dataSet$Activity = activities[dataSet$Activity]

# Aggregate by Subject and Activity
aggDataSet = aggregate(. ~ Subject+Activity, data=dataSet, FUN=mean)

# Create text file of tidy set
write.table(aggDataSet, file = "tidySet.txt", row.name = FALSE)




