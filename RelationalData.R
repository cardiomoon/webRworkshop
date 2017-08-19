## ----setup, include=FALSE------------------------------------------------
library(learnr)
knitr::opts_chunk$set(echo = TRUE, message=FALSE, comment= NA)

## ---- message= FALSE, echo=TRUE------------------------------------------
library(tidyverse)
library(nycflights13)

## ----data, exercise=TRUE, exercise.eval=TRUE,exercise.lines = 1----------
airlines

## ----out.width="70%",fig.align='center'----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/relational-nycflights.png")

## ----primary-key, exercise=TRUE, exercise.eval=TRUE----------------------
planes 



## ----primary-key-hint----------------------------------------------------
planes %>%
    count(tailnum) %>%
    filter(n>1)

## ----flight, exercise=TRUE, exercise.eval=TRUE---------------------------
flights %>% 
  count(year, month, day, flight) %>% 
  filter(n > 1)

## ----flight-surrogate, exercise=TRUE, exercise.eval=TRUE-----------------
flights

## ----flight-surrogate-hint-----------------------------------------------
flights %>% mutate(no=row_number()) 

## ----Batting, exercise=TRUE, exercise.eval=TRUE--------------------------
Lahman::Batting

## ------------------------------------------------------------------------
flights2 <- flights %>%
    select(year:day, hour, origin, dest, tailnum, carrier)
flights2

## ------------------------------------------------------------------------
flights2 %>%
    select(-origin, -dest) %>%
    left_join(airlines, by ="carrier")

## ------------------------------------------------------------------------
flights2 %>%
  select(-origin, -dest) %>% 
  mutate(name = airlines$name[match(carrier, airlines$carrier)])

## ------------------------------------------------------------------------
x <- tribble(
  ~key, ~val_x,
     1, "x1",
     2, "x2",
     3, "x3"
)
y <- tribble(
  ~key, ~val_y,
     1, "y1",
     2, "y2",
     4, "y3"
)

## ----fig.align='center'--------------------------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-setup.png")

## ------------------------------------------------------------------------
inner_join(x,y,by="key")

## ----fig.align='center',out.width="70%"----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-inner.png")

## ----fig.align='center',out.width="70%"----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-outer.png")

## ----fig.align='center',out.width="70%"----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-venn.png")

## ----fig.align='center',out.width="70%"----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-one-to-many.png")

## ------------------------------------------------------------------------
x <- tribble(
  ~key, ~val_x,
     1, "x1",
     2, "x2",
     2, "x3",
     1, "x4"
)
y <- tribble(
  ~key, ~val_y,
     1, "y1",
     2, "y2"
)
left_join(x, y, by = "key")

## ----fig.align='center',out.width="70%"----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-many-to-many.png")

## ------------------------------------------------------------------------
x <- tribble(
  ~key, ~val_x,
     1, "x1",
     2, "x2",
     2, "x3",
     3, "x4"
)
y <- tribble(
  ~key, ~val_y,
     1, "y1",
     2, "y2",
     2, "y3",
     3, "y4"
)
left_join(x, y, by = "key")

## ------------------------------------------------------------------------
flights2 %>%
    left_join(weather)

## ------------------------------------------------------------------------
flights2 %>%
    left_join(planes,by="tailnum")

## ------------------------------------------------------------------------
flights2 %>%
    left_join(airports,c("dest"="faa"))

flights2 %>%
    left_join(airports,c("origin"="faa"))

## ------------------------------------------------------------------------
airports %>%
    semi_join(flights, c("faa"="dest")) %>%
    ggplot(aes(lon, lat)) +
    borders("state") +
    geom_point()+
    coord_quickmap()

## ----exercise-1, exercise=TRUE, exercise.eval=TRUE-----------------------
flights %>%
    group_by(dest) %>%
    summarize(delay=mean(arr_delay,na.rm=TRUE)) 

## ----exercise-1-hint-----------------------------------------------------
flights %>%
    group_by(dest) %>%
    summarize(delay=mean(arr_delay,na.rm=TRUE)) %>%
    left_join(airports, by=c("dest"="faa")) %>%
    ggplot(aes(lon, lat,colour=delay)) +
    borders("state") +
    geom_point() +
    scale_color_gradientn(colours=c("blue","white","red"))+
    coord_quickmap()

## ----exercise-2, exercise=TRUE, exercise.eval=TRUE-----------------------
flights2

## ----exercise-2-hint-----------------------------------------------------
airports2 <- airports %>%
    select(c(1,3,4))

flights2 %>%
    left_join(airports2, by=c("origin"="faa")) %>%
    left_join(airports2, by=c("dest"="faa"))

## ----exercise-3, exercise=TRUE, exercise.eval=TRUE-----------------------
flights %>% 
    group_by(tailnum) %>%
    summarise(delay=mean(arr_delay,na.rm=TRUE))

## ----exercise-3-hint-----------------------------------------------------
flights2 <- flights %>% 
    group_by(tailnum) %>%
    summarise(delay=mean(arr_delay,na.rm=TRUE)) %>%
    left_join(planes) %>%
    mutate(age=2017-year) %>%
    select(1:3,"age")
    
flights2 %>%
    ggplot(aes(age,delay)) + geom_point()

## ----exercise-4, exercise=TRUE, exercise.eval=TRUE-----------------------
flights %>%
    left_join(weather) 
    

## ----exercise-4-hint-----------------------------------------------------
delay <- flights %>%
    left_join(weather) %>%
    select("dep_delay",20:28)

delay %>% ggplot(aes(wind_speed, dep_delay)) +geom_point()

## ----exercise-5, exercise=TRUE, exercise.eval=TRUE-----------------------
flights %>% 
    filter(year==2013, month==6, day==13) %>%
    group_by(dest) %>%
    summarize(delay=mean(arr_delay,na.rm=TRUE)) %>%
    left_join(airports,by=c("dest"="faa")) %>%
    ggplot(aes(lon, lat,colour=delay)) +
    scale_colour_gradientn(colors=c("green","orange","red"))+
    borders("state") +
    geom_point()+
    coord_quickmap()

## ----exercise-5-hint-----------------------------------------------------
flights %>% 
    filter(year==2013, month==6, day==13) %>%
    group_by(dest) %>%
    summarize(delay=mean(arr_delay,na.rm=TRUE)) %>%
    left_join(airports,by=c("dest"="faa")) %>%
    ggplot(aes(lon, lat,colour=delay)) +
    scale_colour_gradientn(colors=c("green","orange","red"))+
    borders("state") +
    geom_point()+
    coord_quickmap()

## ------------------------------------------------------------------------
top_dest <- flights %>%
    count(dest, sort=TRUE) %>%
    head(10)

top_dest

## ------------------------------------------------------------------------
flights %>%
    filter(dest %in% top_dest$dest)

## ------------------------------------------------------------------------
flights %>%
    semi_join(top_dest)

## ----out.width="70%",fig.align='center'----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-semi.png")

## ----out.width="70%",fig.align='center'----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-semi-many.png")

## ----out.width="70%",fig.align='center'----------------------------------
knitr::include_graphics("http://r4ds.had.co.nz/diagrams/join-anti.png")

## ------------------------------------------------------------------------
flights %>%
    anti_join(planes,by="tailnum") %>%
    count(tailnum, sort=TRUE)

## ------------------------------------------------------------------------
flights %>%
    filter(is.na(tailnum))

## ------------------------------------------------------------------------
common_plane<-flights %>% count(tailnum,sort=TRUE) %>% filter(n>100)
flights %>% semi_join(common_plane)

## ------------------------------------------------------------------------
fueleconomy::vehicles %>%
    semi_join(fueleconomy::common)

## ------------------------------------------------------------------------
anti_join(flights, airports, by = c("dest" = "faa"))
anti_join(airports, flights, by = c("faa" = "dest"))

## ------------------------------------------------------------------------
flights %>% 
    select(carrier,tailnum) %>%
    group_by(tailnum) %>%
    count(carrier) %>%
    count(tailnum) %>%
    filter(nn>1) -> dup

flights %>% 
    select(carrier,tailnum) %>%
    group_by(tailnum) %>%
    count(carrier) %>%
    semi_join(dup)

