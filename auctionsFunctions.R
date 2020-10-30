












#Function to create table
create_table2 <- function(auction_term){
  
 # auction_term = "30-Year"
  ###
  df2 <- df %>%
    filter(Term == auction_term)%>%
    filter(Date > Sys.Date() -720)%>%
    select(-Term)%>%
    rename('Size(bn)' = Size)%>%
    rename('Stop out Yield' = highYield)%>%
    rename('Alloted at high' = allocationPercentage)%>%
    rename('Cover Ratio' = bidToCoverRatio)
  
  
  
  #calculate average last 6: all auctions
  df3 <- df2 %>%
    filter(Date < Sys.Date()) %>% ##ta bort kommande auktioner
    pivot_longer(
#  cols = c('Size(bn)':Tail),
      cols = starts_with('Size(bn)'),
      names_to = "figure",
      names_prefix = "value")
  
  #help table for calculating last six auctions
  df3 <- df3 %>%
    group_by(figure) %>%
    mutate(num = 1:n())
  
  #help table for calculating last six auctions divided by type 
  df_temp <- df3 %>%
    group_by(figure, Type) %>%
    mutate(num = 1:n())
  
  
  #all
  dft1 <- df3  %>%
    group_by(figure) %>% 
    mutate(avg_6_auctions = round(slide_index_dbl(value, num, mean, .before=5, .after=0,.complete=T),2))%>%
    filter(Date == max(df3$Date))%>%
    select(-c(num,value))%>%
    mutate(Type = "All") %>%
    pivot_wider(
      names_from = figure,
      values_from = c("avg_6_auctions"))
  
  #reopen
  dft2 <- df_temp  %>%
    group_by(figure, Type) %>% 
    mutate(reopen_avg = round(slide_index_dbl(value, num, mean, .before=5, .after=0,.complete=T),2))%>%
    filter(Type == "Reopen")%>%
    filter(num == max(num))%>%
    select(-c(num,value))%>%
    pivot_wider(
      names_from = figure,
      values_from = c("reopen_avg"))
  
  #refund  
  dft3 <- df_temp  %>%
    group_by(figure, Type) %>% 
    mutate(refund_avg = round(slide_index_dbl(value, num, mean, .before=5, .after=0,.complete=T),2))%>%
    filter(Type == "Refund")%>%
    filter(num == max(num))%>%
    select(-c(num,value))%>%
    pivot_wider(
      names_from = figure,
      values_from = c("refund_avg"))
  
  
  dft1 <- as.data.frame(dft1)
  dft2 <- as.data.frame(dft2)
  dft3 <- as.data.frame(dft3)
  
  #check if there are any reopening. If there are reopening, separate de results per type, otherwise use only all summary
  if (nrow(dft2) == 0){
    
    df3 <- dft1
    
  } else {
    df3 <- rbind(dft1, dft2, dft3)
  }
  
  
  
  
  
  df3$Cusip <- "Average"
  df3$Date <- as.POSIXct(NA)
  
  
  
  df2 <- rbind(df2, df3)
  
  
  ###table
  table <- df2 %>%
    
    mutate(
      Type = ifelse(Type ==  "Reopen",
                    cell_spec(Type, "html", bold = F),
                    cell_spec(Type, "html", bold = T)))%>%
    
  #  mutate(
  #    Tail = ifelse(Tail >  0,
  #                  cell_spec(Tail, "html", color = "green"),
  #                  cell_spec(Tail, "html", color = "red")))%>%
    
    
    
    
    kable("html", escape = F, format.args=list(big.mark=" ", scientific=F)) %>%
    kable_styling(bootstrap_options = c("striped", "hover"), full_width = F, position= "right", fixed_thead = T)%>%
    # kable_styling(full_width = F, position= "right", fixed_thead = T)%>%
    # cell_spec(which(df2$Type == "Refund"),"html",  bold = T)%>%
    pack_rows("Summary last 6 auctions", nrow(df2)-nrow(df3)+1, nrow(df2)-nrow(df3)+1)
  
  
  return(table)
}

