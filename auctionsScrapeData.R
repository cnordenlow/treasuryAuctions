
library(tidyverse)
library(dplyr)
library(ggplot2)
library(readr)
library(slider)
library(kableExtra)
library(httr)
library(jsonlite)

#Import data

url <- "https://www.treasurydirect.gov/TA_WS/securities/jqsearch?format=json&filterscount=0&groupscount=0&pagenum=0&pagesize=1000&recordstartindex=0&recordendindex=100"

x <- fromJSON(url)


auctionsRaw <- x$securityList


#Select fields
auctionsData <- auctionsRaw %>%
  select(cusip, securityType, securityTerm, offeringAmount, tips, type, interestRate, pricePer100, floatingRate, reopening, 
         auctionDate , maturityDate, securityTerm, term, competitiveAccepted,
         allocationPercentage, averageMedianYield, bidToCoverRatio,
         competitiveAccepted, highYield, lowYield, somaAccepted, somaHoldings, 
         primaryDealerAccepted , directBidderAccepted,directBidderTendered, indirectBidderAccepted,
         indirectBidderTendered, interestPaymentFrequency)

#Date formats
auctionsData$auctionDate <- as.Date(gsub("\\D", "", auctionsData$auctionDate), format = "%Y%m%d")
auctionsData$maturityDate <- as.Date(gsub("\\D", "", auctionsData$maturityDate), format = "%Y%m%d")


auctionsData <- auctionsData %>%
  mutate(Type = ifelse(as.character(reopening) == "Yes", "Reopen", "Refund"))



auctionsData <- auctionsData%>%
  filter(as.numeric(offeringAmount) > 100000000)%>%
  mutate(
    Cusip = cusip,
    Date = as.Date(auctionDate),
    Term = term,
    Size = round(as.numeric(offeringAmount) / 1000000000,1),
    SOMA = round(as.numeric(somaAccepted,na.rm = TRUE) / 1000000000,1),
    highYield = as.numeric(highYield),
    averageMedianYield = as.numeric(averageMedianYield),
    allocationPercentage = round(as.numeric(allocationPercentage),3),
    bidToCoverRatio = as.numeric(bidToCoverRatio),
    Primary = round(as.numeric(primaryDealerAccepted,na.rm = TRUE) / as.numeric(competitiveAccepted,na.rm = TRUE)*100,digits=1),
    Direct = round(as.numeric(directBidderAccepted,na.rm = TRUE) / as.numeric(competitiveAccepted,na.rm = TRUE)*100,digits=1),
    Indirect = round(as.numeric(indirectBidderAccepted,na.rm = TRUE) / as.numeric(competitiveAccepted,na.rm = TRUE)*100,digits=1)
  ) 



auctionsData <- arrange(auctionsData,Date)



df <- auctionsData %>%
  filter(Term %in% c("2-Year", "3-Year", "5-Year", "7-Year", "10-Year", "20-Year", "30-Year"))%>%
  filter(Date > Sys.Date() -1500)%>%
  filter(floatingRate == "No")%>%
  filter(tips == "No")%>%
  select(Cusip,Date,Term, Type, Size,  SOMA,highYield, allocationPercentage,bidToCoverRatio,Primary, Direct, Indirect)
