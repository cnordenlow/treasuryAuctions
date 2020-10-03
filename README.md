# treasuryAuctions<br>
This page aims to give an overview how to analyse US Treasury Auctions and to provide neccesary code to import, gather, breakdown and visualize the results.

### US Treasury auctions<br>
The US Treasury uses a Dutch auction to sell it securities aimed to finance the country´s debt. In a Dutch auction structure the price of the offering is set after taking in all bids to determine the highest price at which the total offering can be sold. Investors place a bid for the amount they are willing to pay. When the auction is complete, the the allotment proces begin. The bids with the lowest yield will be accepted first since the buyer will prefer to pay lower yield. However, all investors will pay the highest rate.


### Definitions<br>
**High rate:** This is the highest yield that was accepted at the auction. <br>
**Alloted at high:** This is the percentage of the total what was filled at the highest yield.<br>
**Median rate:** Half of the competetive bids weere submitted below this rate, and half above.<br>
**Low yield:** The lowest submitted yield.<br>
**Primary Dealers:** A primary dealer is a bank that works with the FED to purchase government securities. A primary dealer is required to bid on US Treasuries, with the effect that auctions are designed to never fail.<br>
**Direct bidders:** Bidders who submits bids directly. Usually domestic pension funds and large domestic investors.
**Indirect bidders:** These are bidders that bid on behalf of others. The underlying bidder is usually foerign central banks and governments.


### How to interpret the results?<br>
US auctions are an important short term driver of the Fixed Income markets. Poor auctions (low interest to buy) are bad for the sentiment (rates rise) while strong auctions (strong interest to buy) are good for the sentiment (rates fall). In times as in 2020 when the countrys debt are about to rise this can be even important to see if the market can handle the extra volumes of debt. But how to interpret if the results were good, decent, or bad?<br>

There are a couple of ways to interpret the results, some better and some worse. Below, are couple of ways. All of the below should be set in comparision with the average results of the previous 6-10 auctions of the same term (7-year should be compared with 7-year auctions).<br>

**Bid-to-cover:** Probably the most popular way to digest the result, probably due to it´s easy structure. The ratio says how large the interest of buying the bond where over the accepted volume. A Bid-to-cover rate of 2 indicated that there were 2 times more bids than accepted volume. However, even though the ratio says some, it dosen´t tell the whole truth. Even if there are a high ratio (a lot of underlying demand), it dosen´t say anything about the the quality of the bids. The overshooting bids could be significantly over the the high price, which in fact could indicate that there weren´t a lot of extra interest at the high price.






### Code
