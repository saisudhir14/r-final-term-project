# r-final-term-project

# Sales Data Analysis Documentation

## Step 1: Reading the Dataset
I'm loading the sales dataset from a CSV file using the read.csv function. The dataset is stored in the variable df, and the View function allows us to inspect the initial structure of the data.

```R
# Read the dataset
df <- read.csv("C:/Users/sudhi/OneDrive/Desktop/BIS581_FinalProject/Sales.csv", 
               header=TRUE, stringsAsFactors=FALSE);
View(df)
#This code reads the sales dataset from a CSV file and displays it in a tabular format.
```

## Step 2: Data Exploration and Cleaning
Here, I'm checking the structure of the dataset using the ```str``` function to understand the data or the structure in the csv file.

```R
# Checking the structure of the data
#I'm checking the structure of the dataset and also trying to understand its composition.
str(df)
```
I will then install and load the tidyverse package, which will help me in data manipulation and visualizations
```R
# Installing and loading the required packages now..
install.packages("tidyverse")
library(tidyverse)
```

Checking if there are any missing values in the dataset using the sapply function and then I'm using sum fucntion to check if there are any missing values in each column.
```R
# Checking for missing values
missing_values <- sapply(df, is.na)
sum(missing_values)
```

 Using ```trims``` function to delete the leading and trailing spaces in specific columns, to improve the data cleanliness and consistency in the dataframe.
```R
# Trimming leading or trailing spaces in columns
df$Date <- trimws(df$Date)
# Trim other columns similarly
View(df)
```

Converting the Categorical variables into factors by using the ```factor``` function and then trying to make it easier for categorical data analysis.
```R
# Converting categorical variables to factors
TrSpaceAfter$Country <- factor(TrSpaceAfter$Country)
```
Checking the structure of the data again..
```R
# Convert other columns similarly
View(factorDf)
```
Date column is converted to a proper date type for accurate date-related operations
```R
# Converting Date column to Date type
factorDf$Date <- as.Date(factorDf$Date, format = "%Y-%m-%d")
str(factorDf)
```
Selected columns are converted to numeric format, I will be using these columns to do the statistical analysis.
```R
# Converting required columns to numeric format
factorDf$Day <- as.numeric(factorDf$Day)
# Convert other columns similarly
str(factorDf)
summary(factorDf)
View(factorDf)
```
Trying yo split the 'Age_Group' column into 'Age_Range' and 'Age_Group,' so that I can provide more detailed information for age-related analysis.
```R
# Separating Age Group and Range into two different columns
factorDf$Age_Range <- gsub(".*\\((.*)\\).*", "\\1", factorDf$Age_Group)
factorDf$Age_Group <- gsub("\\(.*\\)", "", factorDf$Age_Group)
factorDf$Age_Range <- trimws(factorDf$Age_Range)
View(factorDf)
```

Verifying the dataset to check if there are any missing values after the data cleaning steps before working on creating the visualizations.
## Step 3: Data Visualization
```R
# Data summary before analysis
summary(factorDf)
analysisDf <- factorDf
View(analysisDf)
```

#### Viz 1: Creating a bar plot to visualize the distribution of product categories by age group.
```R
# Using 'ggplot2' and 'viridis' packages
ggplot(analysisDf, aes(x = Product_Category, fill = Age_Group)) +
  geom_bar(position = "dodge") +
  labs(title = "Product Category Distribution by Age Group",
       x = "Product Category",
       y = "Count") +
  scale_fill_manual(values = c("pink", "beige", "brown", "chocolate", "orange")) +
  theme_minimal()

```

#### Viz 2: Scatter plot for Order Quantity vs. Profit
```R
ggplot(analysisDf, aes(x = Order_Quantity, y = Profit, color = Age_Range)) +
  geom_point() +
  labs(title = "Scatter Plot of Order Quantity vs. Profit",
       x = "Order Quantity",
       y = "Profit") +
  scale_color_manual(values = age_range_colors) +
  facet_wrap(~Age_Range, scales = "free")
```

#### Viz 3: Pie chart for Age Group distribution
```R 
ggplot(analysisDf, aes(x = "", fill = Age_Group)) +
  geom_bar(width = 1, color = "white") +
  geom_text(stat = "count", aes(label = stat(count)), position = position_stack(vjust = 0.5), color = "black", size = 4) +
  scale_fill_manual(values = my_colors) +
  coord_polar("y") +
  labs(title = "Pie Chart of Age Group Distribution with Counts") +
  theme_minimal()
```
#### Viz 4: Faceted bar plot for Country Distribution by Age Group
```R
ggplot(analysisDf, aes(x = Age_Group, fill = Age_Group)) +
  geom_bar() +
  facet_wrap(~ Country, scales = "free") +
  labs(title = "Country Distribution by Age Group",
       x = "Age Group",
       y = "Count") +
  theme_minimal()
```
#### Viz 5: Bar plot for Average Profit by Age Group
```R
ggplot(df, aes(x = Age_Group, y = Profit, fill = Age_Group)) +
  geom_bar(stat = "summary", fun = "mean") +
  scale_fill_manual(values = c("#0818A8", "#191970", "#5F9EA0", "#6495ED")) +
  labs(title = "Average Profit by Age Group",
       x = "Age Group",
       y = "Average Profit")
```

# Step 4: Statistics and Analysis
```R
# Descriptive statistics and analysis
length(analysisDf$Unit_Price)
length(analysisDf$Gender)
summary(analysisDf)
sum(is.na(analysisDf$Order_Quantity))
# Check other columns similarly
```

#### Using tapply to know the sum of order quantity by Age Group
```R
#using tapply function to calculate the sum of order quantity by age group
tapply(analysisDf$Order_Quantity, analysisDf$Age_Group, sum, na.rm = TRUE)
```

#### Countries Revenue sum
```R
#analysis to understand the relationship between revenue and selected variables
tapply(analysisDf$Revenue, analysisDf$Country, sum, na.rm = TRUE)
```

#### Linear regression
```R
lm_model <- lm(Revenue ~ Customer_Age + Unit_Price + Order_Quantity, data = analysisDf)
summary(lm_model)
```

#### Shiny App 

