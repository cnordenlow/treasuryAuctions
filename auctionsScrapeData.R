
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



#df3 <- df

## Below is using Bloomberg. Bloomberg is account is needed.
##get tail

#library(Rblpapi)
library(data.table)
library(lubridate)

#con <- blpConnect() 


#funkar men blir fel när det inte finns

#df2 <- df %>%
 # select(Date, Term, highYield)%>%
#  mutate(ticker = case_when(
#    Term == "2-Year" ~ "WIT2 Govt",
 #   Term == "3-Year" ~ "WIT3 Govt",
  #  Term == "5-Year" ~ "WIT5 Govt",
   # Term == "7-Year" ~ "WIT7 Govt",
    #Term == "10-Year" ~ "WIT10 Govt",
#    Term == "20-Year" ~ "WIT20 Govt",
 #   Term == "30-Year" ~ "WIT30 Govt"
#  ))%>%
 # filter(ticker != "") %>%
#  mutate(
 #   Date = ymd(Date, tz = "UTC"),
  #  start_date = make_datetime(year(Date), month(Date), day(Date), 16, 58),
  #  end_date = make_datetime(year(Date), month(Date), day(Date), 17, 00)
  #)%>%
  
#  filter(Date > Sys.Date() -200)%>%
#  filter(Date < Sys.Date())



#df2 <- df2 %>% rowwise() %>% mutate(res = list(getBars(ticker, "BID", startTime= start_date, endTime=end_date))) 


#df2 <- df2%>%
  #   unnest(res, keep_empty = TRUE)
 # unnest(res)


#df2 <- df2 %>%
#  mutate(Tail = (highYield - close)*100)


### Import historical tail info
#historicalTailInfo <- read.csv("X:\\AFM Handlarbordet\\ForvaltningValutareserven\\portfolioAnalytics\\usTreasuryAuctions\\bloombergWitPrices.csv", header = TRUE, sep=';')



#merge with df2

#df2 = as_tibble(t(df2), rownames = "row_names")
#dftest2 = as_tibble(t(historicalTailInfo), rownames = "row_names")

#df2 <- left_join(df2,dftest2, by = "row_names")
#df2 = as_tibble(t(df2))

#row_to_names(df2)
#colnames(df2) <- as.character(df2[1, ])
#df2 <- df2[-1,]

#df2 <- df2 %>% distinct(start_date, Term, ticker, .keep_all = TRUE)


#save as new file
#write.csv2(df2, "X:\\AFM Handlarbordet\\ForvaltningValutareserven\\portfolioAnalytics\\usTreasuryAuctions\\bloombergWitPrices.csv",row.names=FALSE,na = "", quote = FALSE)



#select a few columns
#df3 <- df2 %>%
#  select(Date, Term, close, Tail)%>%
 # rename('WI BID 1PM' = close)




#merge with blmrg
#df <- left_join(df, df3, by = c("Date", "Term"), all.x = TRUE)





