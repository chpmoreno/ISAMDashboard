library(shiny)
library(shinydashboard)
library(lubridate)
library(Cairo)
library(dplyr)
library(ggplot2)
library(readr)
library(scales)
library(wordcloud)
library(stringi)
library(stringr)
library(DT)
library(plotly)
library(tagcloud)
library(feather)
options(shiny.reactlog=TRUE)

setwd("Data")

info <- readr::read_csv("sentimiento.csv") %>% dplyr::select(-one_of(c("idioma"))) %>% 
        dplyr::mutate(fecha_dia = as.POSIXct(as.character(trunc(fecha,"days")))) %>% 
        dplyr::mutate(rss_sign = ifelse(rss > 0, "positive", ifelse(rss < 0, "negative", "neutral"))) %>% 
        dplyr::mutate(lough_sign = ifelse(lough > 0, "positive", ifelse(lough < 0, "negative", "neutral")))

entidades <- c("all", unique(info$entidad))

freqdist <- readr::read_csv("unifreqdist-bruto.csv")
bifreqdist <- readr::read_csv("bifreqdist-bruto.csv")
trifreqdist <- readr::read_csv("trifreqdist-bruto.csv")

fecha_range_ini <- c('2007-01-01', as.character(max(as.Date(info$fecha_dia))))
#fecha_range_ini <- c('2008-01-01', '2016-03-01')

colorsign <- c("#D21034", "#0079C1", "#009543")
names(colorsign) <- c("negative", "neutral", "positive")

wordcloud_rep <- repeatable(wordcloud)

freqdistaux  <- freqdist %>% group_by(id) %>% summarise(maxconteo = max(conteo))
freqdistaxu2 <- freqdist %>% group_by(ngrama) %>% summarise(nngrama = length(ngrama)) %>% 
                mutate(idf = log(nrow(freqdistaux)/nngrama))
freqdisttfidf <- left_join(freqdist, freqdistaux) %>% mutate(termfreq = 0.5 + 0.5 * (conteo/maxconteo)) %>%
                 left_join(freqdistaxu2) %>% mutate(tfidf = termfreq*idf)

bifreqdistaux  <- bifreqdist %>% group_by(id) %>% summarise(maxconteo = max(conteo))
bifreqdistaxu2 <- bifreqdist %>% group_by(ngrama) %>% summarise(nngrama = length(ngrama)) %>% 
                  mutate(idf = log(nrow(bifreqdistaux)/nngrama))
bifreqdisttfidf <- left_join(bifreqdist, bifreqdistaux) %>% mutate(termfreq = 0.5 + 0.5 * (conteo/maxconteo)) %>%
                   left_join(bifreqdistaxu2) %>% mutate(tfidf = termfreq*idf)

trifreqdistaux  <- trifreqdist %>% group_by(id) %>% summarise(maxconteo = max(conteo))
trifreqdistaxu2 <- trifreqdist %>% group_by(ngrama) %>% summarise(nngrama = length(ngrama)) %>% 
                   mutate(idf = log(nrow(trifreqdistaux)/nngrama))
trifreqdisttfidf <- left_join(trifreqdist, trifreqdistaux) %>% mutate(termfreq = 0.5 + 0.5 * (conteo/maxconteo)) %>%
                    left_join(trifreqdistaxu2) %>% mutate(tfidf = termfreq*idf)

timeseries <- readr::read_csv("Series.csv") %>% mutate(yearmonth = paste0(str_sub(Fecha,7,10), "-",str_sub(Fecha,4,5))) %>%
              select(-one_of("Fecha"))

for(i in colnames(timeseries)[!str_detect(colnames(timeseries), "yearmonth")][!str_detect(colnames(timeseries)[!str_detect(colnames(timeseries), "yearmonth")], "Events")]){
  assign(paste0(i,"_smooth"), loess(paste0(i,"~seq_along(timeseries$yearmonth)"), data = timeseries, span = 0.15)$fit)
}

for(i in colnames(timeseries)[!str_detect(colnames(timeseries), "yearmonth")][!str_detect(colnames(timeseries)[!str_detect(colnames(timeseries), "yearmonth")], "Events")]){
  timeseries <- timeseries %>% cbind(get(paste0(i,"_smooth")))
}
colnames(timeseries)[str_detect(colnames(timeseries), "get")] <- paste0(colnames(timeseries)[!str_detect(colnames(timeseries), "get")][!str_detect(colnames(timeseries)[!str_detect(colnames(timeseries), "get")], "yearmonth")][!str_detect(colnames(timeseries)[!str_detect(colnames(timeseries), "get")][!str_detect(colnames(timeseries)[!str_detect(colnames(timeseries), "get")], "yearmonth")], "Events")],"_smooth")

lough_index_monthly_SI <- info %>% group_by(yearmonth = (str_sub(fecha_dia, 1, 7))) %>% summarise(lough_index = mean(lough))
timeseries2 <- left_join(timeseries, lough_index_monthly_SI)
info_axis <- read.csv("info_axis.csv")
write_csv(timeseries2,"timeseries.csv")
