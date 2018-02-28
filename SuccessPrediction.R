
## Visualization of World Map (FULL)
install.packages("leaflet")
install.packages("dplyr")
library(stringr)
library(leaflet)
library(dplyr)
source("myfunctions.R")

library(foreign)

GT <- read.csv("~/Downloads/Terrorism/globalterrorismdb_0617dist.csv")

GT01= GT[,c("iyear", "city", "country_txt", "latitude","longitude", "attacktype1_txt", "targtype1_txt", "targsubtype1_txt", 
            "target1", "weaptype1_txt","weapsubtype1_txt", "gname", "motive", "summary")]




#Omitting NA values for visualisation purposes
GT01[GT01==""] <- NA
GT01 = na.omit(GT01)



################################################################################################
# 2010 - 2016

after2010 <- GT01[GT01$iyear>2010 & GT01$iyear<=2016 ,  ]


mymap <- 
  leaflet() %>% 
  addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
           attribution='Map tiles by 
           <a href="http://stamen.com">Stamen Design</a>, 
           <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> 
           &mdash; 
           Map data &copy; 
           <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>') %>%
  setView(15, 40, zoom= 2)




mymap %>% addCircles (data=after2010, lat= ~latitude, lng = ~longitude, 
                      popup=paste(
                        "<strong>Year: </strong>", GT01$iyear,
                        "<br><strong>City: </strong>", GT01$city, 
                        "<br><strong>Country: </strong>", GT01$country_txt, 
                        "<br><strong>Attack type: </strong>", GT01$attacktype1_txt, 
                        "<br><strong>Target: </strong>", GT01$targtype1_txt, 
                        " | ", GT01$targsubtype1_txt, 
                        " | ", GT01$target1, 
                        "<br><strong>Weapon: </strong>", GT01$weaptype1_txt, 
                        "<br><strong>Group: </strong>", GT01$gname, 
                        "<br><strong>Motive: </strong>", GT01$motive, 
                        "<br><strong>Summary: </strong>", GT01$summary),
                      weight = 0.8, color="#8B1A1A", stroke = TRUE, fillOpacity = 0.6)






#################################################################################################################
# -  

library(readr)
mydata1 <- read_csv("GTDcleanFINAL.csv")
mydata1$nkill <- ifelse(is.na(mydata1$nkill) ,0 ,mydata1$nkill)


##Factoring
mydata1$attacktype1 <- factor(mydata1$attacktype1)
mydata1$success <- factor(mydata1$success)
mydata1$weaptype1 <- factor(mydata1$weaptype1)
mydata1$targtype1 <- factor(mydata1$targtype1)
mydata1$specificity <- factor(mydata1$specificity)
mydata1$suicide <- factor(mydata1$suicide)
mydata1$imonth <- factor(mydata1$imonth)

mydata1$nkill

#European Countries
germany <- mydata1[mydata1$country_txt == "Germany",]
UK <- mydata1[mydata1$country_txt == "United Kingdom",]

#### Adjustments
germany <- germany[germany$targtype1!=7,]

#South Asia
Desi <- mydata1[mydata1$region_txt == "South Asia",]
india <- mydata1[mydata1$country_txt == "India",]
bangladesh <- mydata1[mydata1$country_txt == "Bangladesh",]

#### Adjustments
bangladesh <- bangladesh[bangladesh$targtype1!=11,]


#High activity countries
Pakistan <- mydata1[mydata1$country_txt == "Pakistan",]
Afghanistan <- mydata1[mydata1$country_txt == "Afghanistan",]

#### Adjustments
Pakistan <- Pakistan[Pakistan$targtype1!=11,]

india$guncertain1<- factor(india$guncertain1)
india$claimed<- factor(india$claimed)
bangladesh$claimed<- factor(bangladesh$claimed)
india$suicide<- factor(india$suicide)
bangladesh$suicide<- factor(bangladesh$suicide)

india$claimmode<- factor(india$claimmode)
bangladesh$claimmode<- factor(bangladesh$claimmode)

#Train Model
model.linear <- glm(nkill ~ attacktype1*claimed + suicide    , data=india)
summary((model.linear))
summary(fitted.values(model.linear))
hist(fitted.values(model.linear), breaks = 40,main="Prediction for Linear Regression")

#Test Model
pred.linear <- predict(model.linear, newdata=bangladesh,type="response")
summary(pred.linear)
hist(pred.linear, breaks = 40,main="Prediction for Linear Regression") 

#Performance Metrics
cor(pred.linear , bangladesh$nkill)

R2(y=bangladesh$nkill, pred=pred.linear)

FPR_TPR <- function(prediction, actual){
  
  TP <- sum((prediction)*(actual))
  FP <- sum((prediction)*(!actual))
  FN <- sum((!prediction)*(actual))
  TN <- sum((!prediction)*(!actual))
  result <- data.frame( TP, FP, FN, TN, FPR = FP / (FP + TN), TPR = TP / (TP + FN), ACC = (TP+TN)/(TP+TN+FP+FN) )
  
  return (result)
}  

PL.performance75 <- FPR_TPR(pred.linear>=0.4 , bangladesh$nkill)
PL.performance75

#######################################################################################################################################
## Predicting Success GREECE and UK

united<- mydata1[mydata1$country_txt == "United Kingdom",]

united$targtype1 <-  factor(united$targtype1)

united$attacktype1 <-  factor(united$attacktype1)

united$weaptype1 <-  factor(united$weaptype1)

united$multiple <-  factor(united$multiple)

united <- united[united$attacktype1!=(4),]
united <- united[united$attacktype1!=(6),]
united <- united[united$weaptype1!=(10),]
united <- united[united$targtype1!=(4),]
united <- united[united$targtype1!=(12),]
united <- united[united$targtype1!=(16),]
united <- united[united$targtype1!=(20),]
united <- united[united$targtype1!=(21),]

model.log2 <- glm(success ~ attacktype1*targtype1 , data=greece,family="binomial")
summary(model.log2)$coef[,1]
pred.log2 <- predict(model.log2, newdata=united, type="response")

summary(pred.log2)

My1<- united$success == 1

mean(germany$success)
mean(united$success) 

FPR_TPR <- function(prediction, actual){
  
  TP <- sum((prediction)*(actual))
  FP <- sum((prediction)*(!actual))
  FN <- sum((!prediction)*(actual))
  TN <- sum((!prediction)*(!actual))
  result <- data.frame( TP, FP, FN, TN, FPR = FP / (FP + TN), TPR = TP / (TP + FN), ACC = (TP+TN)/(TP+TN+FP+FN) )
  
  return (result)
}  

PL.performance75 <- FPR_TPR(pred.log2>=0.5, My1)
PL.performance75