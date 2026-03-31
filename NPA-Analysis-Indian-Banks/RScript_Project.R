library("plm")
library("ggplot2")
library("dplyr")
library("lmtest")
library("sandwich")

#Get the data
data <- read.csv("RA_Final.csv")
head(data)
dim(data)
str(data)
#Fixing the columns
names(data) <- c("Bank","Year","NPA","CAR","BankSize","ROA","CreditGrowth","GDPGrowth","Inflation")
str(data)
 
#Removing peercentage variable
data$CreditGrowth <- gsub("%", "", data$CreditGrowth)
data$GDPGrowth <- gsub("%","", data$GDPGrowth)
data$Inflation <- gsub("%","", data$Inflation)

data$CreditGrowth <- as.numeric(data$CreditGrowth)
data$GDPGrowth <- as.numeric(data$GDPGrowth)
data$Inflation <- as.numeric(data$Inflation)

#Missing values
data[data== "-"] <- NA
dim(data)

#Converting remaining variables
data$Bank <- as.factor(data$Bank)
data$Year <- as.numeric(data$Year)

data$NPA <- as.numeric(data$NPA)
data$CAR <- as.numeric(data$CAR)
data$BankSize <- as.numeric(data$BankSize)
data$ROA <- as.numeric(data$ROA)

str(data)
#checking where NA exists
colSums(is.na(data))

#Fill NA with column mean
data$CreditGrowth[is.na(data$CreditGrowth)] <- mean(data$CreditGrowth, na.rm = TRUE)
colSums(is.na(data))

nrow(data)


#Creating Panel data
pdata<- pdata.frame(data, index = c("Bank","Year"))
index(pdata)

#Pooled OLS model
pooled_model <- plm(NPA~CAR + BankSize + ROA + CreditGrowth + GDPGrowth + Inflation,
                    data = pdata, model = "pooling") 
summary(pooled_model)


#Fixed effects model
fixed_model <- plm(NPA~CAR + BankSize + ROA + CreditGrowth + GDPGrowth + Inflation,
                   data = pdata, model = "within")
summary(fixed_model)




# Random effects
random_model <- plm(NPA~CAR + BankSize + ROA + CreditGrowth + GDPGrowth + Inflation,
                    data = pdata, model = "random")
summary(random_model)


#Hausman test
phtest(fixed_model,random_model)

#Random effects is the one that fits
#Diagnostics
#Heteroskedasticity Test
bptest(random_model)

#Serial correlation test
pbgtest(random_model)

#Robust Standard Errors
coeftest(random_model,vcov. = vcovHC(random_model))

#Plots
#NPA trend by bank
ggplot(data, aes(x = Year, y = NPA, color = Bank)) +
  geom_line(size = 1.2) +
  geom_point() +
  theme_minimal() +
  labs(title = "NPA Trend Across Banks (2014–2023)",
       x = "Year",
       y = "NPA (%)")

#Credit growth vs NPA
ggplot(data, aes(x = Year, y = NPA, color = Bank)) +
  geom_line(size = 1.2) +
  geom_point() +
  theme_minimal() +
  labs(title = "NPA Trend Across Banks (2014–2023)",
       x = "Year",
       y = "NPA (%)")
ggplot(data, aes(x = CreditGrowth, y = NPA)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal() +
  labs(title = "Credit Growth vs NPA",
       x = "Credit Growth (%)",
       y = "NPA (%)")

#ROA vs NPA
ggplot(data, aes(x = ROA, y = NPA)) +
  geom_point() +
  geom_smooth(method = "lm") +
  theme_minimal() +
  labs(title = "ROA vs NPA",
       x = "Return on Assets",
       y = "NPA (%)")


#Average NPA by bank
avg_npa <- data %>%
  group_by(Bank) %>%
  summarise(AverageNPA = mean(NPA))

ggplot(avg_npa, aes(x = Bank, y = AverageNPA, fill = Bank)) +
  geom_bar(stat = "identity") +
  theme_minimal() +
  labs(title = "Average NPA by Bank",
       x = "Bank",
       y = "Average NPA (%)")


#NPA heatmap across banks and years
ggplot(data, aes(x = Year, y = Bank, fill = NPA)) +
  geom_tile(color = "white") +
  scale_fill_gradient(low = "lightyellow", high = "red") +
  theme_minimal() +
  labs(title = "Heatmap of NPA Across Banks (2014–2023)",
       x = "Year",
       y = "Bank",
       fill = "NPA (%)")

















