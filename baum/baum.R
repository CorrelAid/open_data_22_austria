library(tidyverse)
library(readr)
library(dplyr)
library(ggplot2)
library(kableExtra)
library(knitr)

gc()

rm(list = ls())


data_baum <- read.csv("BAUMKATOGD.csv")




data_baum %>% select(GATTUNG_ART) %>% table() %>% data.frame() %>% arrange(Freq) %>% tail()

d <- data_baum %>% select(BEZIRK, GATTUNG_ART) %>% table() %>% data.frame() 


top <- d %>% 
  arrange(desc(Freq)) %>% 
  group_by(BEZIRK) %>% 
  slice(1:1) %>% 
  rename(bezirk = BEZIRK, lieblings_art = GATTUNG_ART, lieblings_freq = Freq)


ggplot(data=top, aes(x=bezirk, y=lieblings_freq, fill = lieblings_art))+
  geom_bar(stat="identity") +
  theme(legend.title = element_blank(), 
        axis.title.x=element_blank(),
        axis.title.y=element_blank()) 

top2 <- data_baum %>% 
  select(BEZIRK) %>% 
  table() %>% 
  data.frame() %>% 
  rename(bezirk = ".", total_freq = Freq)




median <- data_baum %>%                                        
  group_by(BEZIRK) %>%                         
  summarise_at(vars(STAMMUMFANG),              
               list(name = median,
                    mean = mean))  %>% 
  data.frame() %>% 
  rename(bezirk = BEZIRK, 
         umfang_median = name,
         umfang_mean = mean)

### mode von hoehe und kronendurchmesser
  
  getmode <- function(v) {
    uniqv <- unique(v)
    uniqv[which.max(tabulate(match(v, uniqv)))]
  }
  
  
mode <- c()  
for(i in unique(data_baum$BEZIRK)) {x <- data_baum %>% filter(BEZIRK == i)
h <- getmode(x$BAUMHOEHE)
k <- getmode(x$KRONENDURCHMESSER)

m <- cbind(h,k)
mode <- rbind(mode, m)
}
mode <- data.frame(mode)
i <- unique(data_baum$BEZIRK)
mode <- cbind(mode,i)
colnames(mode) <- c("mode_hoehe", "mode_krone", "bezirk")  
  


mode$mode_hoehe <- ifelse(mode$mode_hoehe == 2, "6-10",
                                  ifelse(mode$mode_hoehe == 3, "11-15",
                                         ifelse(mode$mode_hoehe == 1, "0-5",
                                         mode$mode_hoehe)))

mode$mode_krone <- ifelse(mode$mode_krone  == 2, "4-6",
                          ifelse(mode$mode_krone == 1, "0-3",
                                 ifelse(mode$mode_krone  == 3, "7-9",
                                        mode$mode_krone)))


top <- arrange(top, bezirk)
top2 <- arrange(top2, bezirk)
median <- arrange(median, bezirk)
median <- median[1:23,]
mode <- arrange(mode, bezirk)
mode <- mode[1:23,]

baum <- merge(top, top2, by = "bezirk")
baum <- merge(baum, median, by = "bezirk")
baum <- merge(baum, mode, by = "bezirk")

write.csv(baum, "baum.csv")
