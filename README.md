# 제 4회 웹에서 하는 R통계 워크샵 자료집

### 일시: 2017년 8월 26일

### 강의: 문건웅(cardiomoon@gmail.com) 

### 내용: 

---

# 워크샵 자료 다운로드

- https://github.com/cardiomoon/webRworkshop

- http://web-r.org/board_WDJQ50

둘중 아무 곳에서나 받으시면 됩니다.
---

# 강의순서

시간  | 내용
-------|-------------
09:00 - 10:00  | 틀리지 않는 법 
10:00 - 12:00  | 웹에서 하는 R 통계 3.1
12:00 - 13:00  | 점심시간
13:00 - 14:00  | 데이터 변형
14:00 - 15:00  | 데이터 다듬기
15:00 - 16:00  | 관계형데이터
16:00 - 17:00  | 재현가능한 연구

---

# 틀리지 않는 법

1.틀리지않는법.pptx

---

# 웹에서 하는 R 통계

chrome, firefox, opera, safari 등을 사용하여 웹에서 하는 R통계 강의용 서버 접속

왼쪽 |가운데 |오른쪽
-----|-------|------
[R통계3.1](http://172.104.89.167:3838/betam3)|[R통계3.1](http://172.104.109.33:3838/betam3)|[R통계3.1](http://172.104.122.54:3838/betam3)
172.104.89.167:3838/betam3 | 172.104.109.33:3838/betam3 |172.104.122.54:3838/betam3 

---

# 점심시간

### 오후 강의 진행에 필요한 사항

- R 설치 :  
    - https://www.r-project.org/
    - http://cran.nexr.com/
    

- RStudio 설치: 
    - https://www.rstudio.com/products/rstudio/download/#download

- 패키지설치 : RStudio에서 다음 패키지 설치

```{r,eval=FALSE}
install.packages(c("knitr","tidyverse","learnr","rmarkdown"))
install.packages(c("devtools","nycflights13"))
devtools::install_github("cardiomoon/workshop")
```
---

# 데이터 변형

- R 소스파일: 2.데이터변형.R

---

# 데이터 다듬기

- R 소스파일: 3.데이터만들기.R

---

# 관계형 데이터

```{r,eval=FALSE}
learnr::run_tutorial("relationalData",package="workshop")
```


---

# 재현가능한 연구



- 5.재현가능한 연구.Rmd

