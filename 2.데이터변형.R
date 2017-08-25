## ----setup, include=FALSE------------------------------------------------
options(htmltools.dir.version = FALSE)
knitr::opts_chunk$set(echo = TRUE,comment=NA, message=FALSE, warning=FALSE,
                      fig.asp=0.618, fig.align="center")

## ------------------------------------------------------------------------
#install.packages("tidyverse") 

library(tidyverse)
library(nycflights13)

## ------------------------------------------------------------------------
iris

## ------------------------------------------------------------------------
iris1=as_tibble(iris)
iris1

## ------------------------------------------------------------------------
flights

## ------------------------------------------------------------------------
print(flights,n=10,width=Inf)

## ------------------------------------------------------------------------
filter(flights, month==1, day==1)

## ------------------------------------------------------------------------
jan1 <- filter(flights, month==1, day==1)

## ------------------------------------------------------------------------
(dec25 <- filter(flights, month==12, day==25))

## ---- error=TRUE---------------------------------------------------------
filter(flights, month = 1) 

## ------------------------------------------------------------------------
sqrt(2)^2 == 2
1/49*49 == 1

## ------------------------------------------------------------------------
 near(sqrt(2)^2,2)
 near(1/49*49,1)

## ------------------------------------------------------------------------
filter(flights, month == 1 | month == 12)

## ----eval=FALSE----------------------------------------------------------
## filter(flights, month == 1 | 12)

## ------------------------------------------------------------------------
filter(flights, month %in% c(1,7,12))

## ----eval=FALSE----------------------------------------------------------
## filter(flights, !(arr_delay > 120 | dep_delay > 120))
## filter(flights, arr_delay <= 120, dep_delay <= 120)

## ------------------------------------------------------------------------
NA > 5
10 == NA
NA + 10
NA / 2

## ------------------------------------------------------------------------
NA == NA

## ------------------------------------------------------------------------
# 철수의 나이를 x라고 하고 나이를 모른다고 하자
x <- NA

# 영희의 나이를 y라고 하고 나이를 모른다고 하자
y <- NA

#철수와 영희가 나이가 같은가?
x == y 
# 모른다!!

## ------------------------------------------------------------------------
is.na(x)

## ------------------------------------------------------------------------
df <- tibble(x = c(1, NA, 3))
filter(df, x > 1)

## ------------------------------------------------------------------------
filter(df, is.na(x) | x > 1)

## ---- eval=FALSE---------------------------------------------------------
## filter(flights,arr_delay >= 120)

## ---- eval=FALSE---------------------------------------------------------
## filter(flights, dest %in% c("IAH","HOU"))

## ---- eval=FALSE---------------------------------------------------------
## filter(flights, carrier %in% c("UA","AA","DL"))

## ---- eval=FALSE---------------------------------------------------------
## filter(flights, month >= 7, month <= 9)

## ---- eval=FALSE---------------------------------------------------------
## filter(flights, arr_delay >= 120, dep_delay<=0 )

## ---- eval=FALSE---------------------------------------------------------
## filter(flights, arr_delay >= 60, dep_delay - arr_delay >= 30 )

## ---- eval=FALSE---------------------------------------------------------
## filter(flights, dep_time >= 0, dep_time <= 600 )

## ---- eval=FALSE---------------------------------------------------------
## filter(flights, dep_time >=0, dep_time<=600)
## filter(flights, between(dep_time ,0, 600))

## ---- eval=FALSE---------------------------------------------------------
## filter(flights,is.na(dep_time))

## ------------------------------------------------------------------------
arrange(flights, year, month, day)

## ------------------------------------------------------------------------
arrange(flights, desc(arr_delay))

## ------------------------------------------------------------------------
df <- tibble(x = c(5, 2, NA))
arrange(df, x)
arrange(df, desc(x))

## ------------------------------------------------------------------------
arrange(df, desc(x))

## ----eval=FALSE----------------------------------------------------------
## arrange(flights, !is.na(x),desc(arr_delay))

## ----eval=FALSE----------------------------------------------------------
## arrange(flights,desc(distance/air_time))
## top_n(flights,1,distance/air_time)

## ----eval=FALSE----------------------------------------------------------
## arrange(flights,desc(distance))
## arrange(flights,desc(air_time))
## top_n(flights,1,air_time)

## ------------------------------------------------------------------------

# 열 이름으로 선택하기
select(flights, year, month, day)

## ------------------------------------------------------------------------
# year부터 day 까지 열 선택하기
select(flights, year:day)

## ------------------------------------------------------------------------
# year부터 day 까지 열을 제외하고 나머지 열 선택
select(flights, -(year:day))


## ----eval=FALSE----------------------------------------------------------
## rename(flights, tail_num = tailnum)

## ------------------------------------------------------------------------
select(flights, time_hour, air_time,everything())

## ---- eval=FALSE---------------------------------------------------------
## vars <- c("year", "month", "day", "dep_delay", "arr_delay")
## select(flights, one_of(vars))

## ---- eval=FALSE---------------------------------------------------------
## select(flights, contains("TIME"))

## ------------------------------------------------------------------------
flights_sml <- select(flights, 
                      year:day, ends_with("delay"), distance, air_time)

mutate(flights_sml,
  gain = arr_delay - dep_delay,
  speed = distance / air_time * 60
)

## ------------------------------------------------------------------------
mutate(flights_sml,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

## ------------------------------------------------------------------------
transmute(flights,
  gain = arr_delay - dep_delay,
  hours = air_time / 60,
  gain_per_hour = gain / hours
)

## ------------------------------------------------------------------------
transmute(flights,
  dep_time,
  hour = dep_time %/% 100,
  minute = dep_time %% 100
)

## ------------------------------------------------------------------------
(x <- 1:10)
lag(x)
lead(x)

## ------------------------------------------------------------------------
x <- c(1,2,2,3,7,7,8,1)
x
lag(x)
x-lag(x)
x != lag(x)

## ------------------------------------------------------------------------
(x <- 1:10)
cumsum(x)
cummean(x)

## ------------------------------------------------------------------------
y <- c(1,2,2,NA,3,4)
min_rank(y)
min_rank(desc(y))

## ------------------------------------------------------------------------
row_number(y)
dense_rank(y)
percent_rank(y)
cume_dist(y)

## ------------------------------------------------------------------------
flights %>% 
    select(ends_with("dep_time")) %>% 
    mutate(
        dep_min = dep_time %/% 100*60 + dep_time %% 100,
        sched_dep_min = sched_dep_time %/% 100*60 + sched_dep_time %% 100
    )

## ------------------------------------------------------------------------
flights %>% 
    mutate(time_diff = arr_time - dep_time) %>%
    select(air_time,arr_time,dep_time,time_diff)

## ------------------------------------------------------------------------
time2min=function(time){
    time %/%100*60 + time %%100
}
flights %>% 
    mutate(
        arr_min=time2min(arr_time),
        dep_min=time2min(dep_time),
        timediff=arr_min-dep_min
    ) %>%
    select(air_time,arr_time, dep_time, timediff)

## ------------------------------------------------------------------------
flights %>%
    mutate(dep_diff = time2min(dep_time) - time2min(sched_dep_time)) %>%
    filter(dep_delay!=dep_diff)

## ------------------------------------------------------------------------
flights %>% 
    mutate(rank=min_rank(desc(arr_delay))) %>%
    arrange(desc(arr_delay)) %>%
    filter(rank<=10)

## ------------------------------------------------------------------------
flights %>% 
    top_n(10,arr_delay) %>%
    arrange(desc(arr_delay))

## ------------------------------------------------------------------------
1:3 + 1:10

## ------------------------------------------------------------------------
summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

## ------------------------------------------------------------------------
by_day <- group_by(flights, year, month, day)
summarise(by_day, delay= mean(dep_delay, na.rm = TRUE))

## ------------------------------------------------------------------------
by_dest <- group_by(flights, dest)
delay <- summarise(by_dest,
  count = n(),
  dist = mean(distance, na.rm = TRUE),
  delay = mean(arr_delay, na.rm = TRUE)
)
delay <- filter(delay, count > 20, dest != "HNL")

## ------------------------------------------------------------------------
ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)

## ------------------------------------------------------------------------
delays <- flights %>% 
  group_by(dest) %>% 
  summarise(
    count = n(),
    dist = mean(distance, na.rm = TRUE),
    delay = mean(arr_delay, na.rm = TRUE)
  ) %>% 
  filter(count > 20, dest != "HNL")

## ------------------------------------------------------------------------
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

## ------------------------------------------------------------------------
flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay, na.rm=TRUE)) 

## ------------------------------------------------------------------------
not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

## ----fig.height=3,fig.width=5--------------------------------------------
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay))

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_freqpoly()

## ----fig.height=4,fig.width=6--------------------------------------------
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(
    delay=mean(arr_delay, na.rm = TRUE),
    n = n()
  )
ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

## ----fig.height=5,fig.width=7--------------------------------------------
delays %>% 
  filter(n > 25) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
    geom_point(alpha = 1/10)

## ----eval=FALSE----------------------------------------------------------
## install.packages("Lahman")

## ------------------------------------------------------------------------
batting <- as_tibble(Lahman::Batting)

batters <- batting %>% 
  group_by(playerID) %>% 
  summarise(
    ba = sum(H, na.rm = TRUE) / sum(AB, na.rm = TRUE),
    ab = sum(AB, na.rm = TRUE)
  )

## ------------------------------------------------------------------------
batters %>%
    top_n(10,ba)

## ----fig.height=5,fig.width=7--------------------------------------------
batters %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point() + 
    geom_smooth(se = FALSE)

## ----fig.height=5,fig.width=7--------------------------------------------
batters %>% 
  filter(ab > 100) %>% 
  ggplot(mapping = aes(x = ab, y = ba)) +
    geom_point() + 
    geom_smooth(se = FALSE)

## ------------------------------------------------------------------------
not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    avg_delay1 = mean(arr_delay),
    avg_delay2 = mean(arr_delay[arr_delay > 0]) # the average positive delay
  )

## ------------------------------------------------------------------------
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd))

## ------------------------------------------------------------------------
# Which destinations have the most carriers?
not_cancelled %>% 
  group_by(dest) %>% 
  summarise(carriers = n_distinct(carrier)) %>% 
  arrange(desc(carriers))

## ------------------------------------------------------------------------
not_cancelled %>% 
  count(dest)

## ------------------------------------------------------------------------
not_cancelled %>% 
  count(tailnum, wt = distance)

## ------------------------------------------------------------------------
not_cancelled %>%
    group_by(year,month,day) %>%
    summarise(
        n_early=sum(dep_time<=500),
        early_perc=mean(dep_time<=500)
    )

## ------------------------------------------------------------------------
not_cancelled %>%
    group_by(year,month,day) %>%
    summarise(
        hour_perc=mean(arr_delay>60)
    )

## ------------------------------------------------------------------------
flights_sml %>% 
  group_by(year, month, day) %>%
  filter(rank(desc(arr_delay)) < 2)
  #top_n(1,arr_delay)

## ------------------------------------------------------------------------
popular_dest <- flights %>%
    group_by(dest) %>%
    filter(n()>365)
popular_dest

