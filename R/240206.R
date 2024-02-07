# ifelse
# ifelse(조건식(벡터데이터), 참인 경우, 거짓인 경우)
# ifelse 결과값 타입 -> 벡터데이터
a <- c(TRUE, FALSE, TRUE, FALSE, FALSE)
ifelse(a, "T", "F")

# ifelse 함수 안에는 비어있는 벡터데이터가 필요하다?
# 그냥 벡터데이터가 필요하다는 뜻인 것 같음

# 벡터데이터에 데이터 추가
result <- c()
for (i in 1:10) {
  if (i %% 2 == 0) {
    result[length(result)+1] <- i # 뭐지 이건
  }
}
result

# ifelse 함수 생성
# 매개변수 3개
iftest <- function(vector_bool, t, f) {
  result <- c() # 마지막 결과값
  
  # 벡터의 길이만큼 반복하는 반복문
  i <- 1 # 초기값
  while (i <= length(vector_bool)) {
    if(vector_bool[i]) { # true일 때만 실행되니까 == TRUE를 지정해줄 필요가 없음
      result[i] <- t
    } else {
      result[i] <- f
    }
    i = i + 1
  }
  return(result)
}
iftest(
  c("FALSE","FALSE","TRUE","FALSE"),
  "T",
  "F"
)

# 결측치 데이터 처리
c1 = c(1,2,NA,4,5)
c2 = c(1,2,3,4,5)
c3 = c(NA,NA,3,4,5)

df = data.frame(c1,c2,c3)
df

str(df)
# 결측치 존재 유무
is.na(df)

# 결측치 개수 확인
table(is.na(df))

# 데이터 필터링
is.na(df$c1) -> flag
df[flag, ] # true만 표시 -> 결측치값
df[!flag, ]

mean(df$c1) # 결측치가 포함되면 연산이 안됨
max(df$c1, na.rm = T) # 결측치 제거

exam <- read.csv('../csv/csv_exam.csv')
exam

table(is.na(exam))

# 결측치 강제 입력
exam[c(2,5), 'math'] <- NA

exam$math
library(dplyr)

# 수학 결측치 제거 후 그룹화
exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math)) # 결측치 존재 

exam %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math, na.rm = T)) # 결측치 제거

exam %>% 
  filter(!is.na(math)) %>% 
  group_by(class) %>% 
  summarise(mean_math = mean(math))

# 결측치에 특정 데이터 대입
ifelse(is.na(exam$math), mean(exam$math, na.rm = T), exam$math)
ifelse(is.na(exam$math), 0, exam$math)

exam$math
mean(exam$math, na.rm=T)

# 극단치
library(ggplot2)

mpg <- ggplot2 :: mpg
str(mpg)
View(mpg)

# 고속도로 연비 데이터에서 극단치 확인
boxplot(mpg$hwy)

# 극단치 수치화
boxplot(mpg$hwy)$stats

# 결측치 확인
table(is.na(mpg$hwy))

# 극단치인 데이터를 결측치로 대체
mpg$hwy < 12 | mpg$hwy > 37 -> flag
table(flag) # T,F 개수확인

ifelse(flag, NA, mpg$hwy) -> mpg$hwy
table(is.na(mpg))

# 컬럼 이름 변경
# manufacturer -> 제조사 hwy->고속도로 cty->시내 class->차종 drv->구동방식
mpg %>% 
  rename(
    제조사 = manufacturer,
    고속도로 = hwy, 
    시내 = cty,
    차종 = class,
    구동방식 = drv,
    ) -> mpg

# 제조사별 고속도로의 평균 연비는 어디가 가장 좋은가?
# 컬럼 제조사, 고속도로 선택
mpg %>% 
  select(제조사, 고속도로) %>% 
  group_by(제조사) %>% 
  summarise(평균연비 = mean(고속도로, na.rm = T)) %>% 
  arrange(desc(평균연비)) %>% 
  head(5)

mpg %>% 
  filter(!is.na(고속도로)) %>% 
  select(제조사, 고속도로) %>% 
  group_by(제조사) %>% 
  summarise(평균연비 = mean(고속도로)) %>% 
  arrange(desc(평균연비)) %>% 
  head(5)

install.packages("extrafont")
library(extrafont)
font_import()
library(ggplot2)
theme_set(theme_grey(base_family = "AppleGothic"))

# 데이터 시각화
# 그래프 표현

# 레이어를 하나씩 추가 하며 그래프 완성

# 배경 레이어 생성
ggplot(
  data = mpg,
  aes( # 축
    x = displ,
    y = 고속도로
    )
) + geom_point() + xlim(3,6)

# 막대 그래프
mpg %>% 
  group_by(구동방식) %>% 
  summarise(평균연비 = mean(고속도로, na.rm = T)) -> group_data

ggplot(
  data = group_data,
  aes(
    x = 구동방식,
    y = 평균연비
  )
) + geom_col()

ggplot(
  data = mpg,
  aes(
    x = 구동방식
  )
) + geom_bar()

# 라인 그래프 : 제조년도별 생산 차량의 개수
table(mpg$year)
mpg %>% 
  group_by(year) %>% 
  summarise(count = n()) -> group_data2 # 개수 체크 

ggplot(
  data = group_data2,
  aes(
    x = year,
    y = count
  )
) + geom_line()

ggplot(
  data = economics,
  aes(
    x = date,
    y = unemploy
  )
) + geom_line()

mpg <- ggplot2 :: mpg # 초기화 : 다시 불러오기
boxplot(mpg$hwy)
ggplot(
  data = mpg,
  aes(
    x = drv,
    y = hwy
  )
) + geom_boxplot()

# sav 파일 로드
# foreign 라이브러리 설치
install.packages('foreign')
library(foreign)
welfare <- read.spss("../csv/Koweps.sav", to.data.frame = T)
str(welfare)

# 컬럼의 이름 변경
welfare %>% 
  rename(
    gender = h10_g3,
    birth = h10_g4,
    income = p1002_8aq1,
    code_job = h10_eco9
  ) -> welfare

# 특정 컬럼 추출
welfare_copy <- welfare[c(
  'gender','birth','income','code_job'
)]

# 결측치 개수 확인
table(is.na(welfare_copy))
table(is.na(welfare_copy$gender))
table(is.na(welfare_copy$birth))
table(is.na(welfare_copy$income))
table(is.na(welfare_copy$code_job))

# 성별 데이터에서 이상치가 존재하는가 ?
table(welfare_copy$gender)
ifelse(welfare_copy$gender==1, 'male', 'female') -> welfare_copy$gender
table(welfare_copy$gender)

# income 컬럼의 데이터가 0, 9999 라면 NA 변환
# case1
welfare_copy$income > 0 & welfare_copy$income < 9999 -> flag
ifelse(flag, welfare_copy$income, NA)

# case2
welfare_copy$income == 0 | welfare_copy$income == 9999 -> flag2
ifelse(flag2, NA, welfare_copy$income)

# case3
welfare_copy$income %in% c(0,9999) -> flag3
ifelse(flag3, NA, welfare_copy$income) -> welfare_copy$income

# 성별을 기준으로 평균 임금의 차이가 존재하는가
welfare_copy %>% 
  filter(!is.na(income)) %>% 
  select(gender, income) %>% 
  group_by(gender) %>% 
  summarise(mean_income = mean(income)) -> gender_data

ggplot(
  data = gender_data,
  aes(
    x = gender,
    y = mean_income
  )
) + geom_col()

# 나이에 따른 임금의 차이는?
# age 컬럼 생성 : 기준년도 - birth
# welfare_copy %>% 
#  mutate(age = 2015 - birth)
# 2015 - welfare_copy$birth -> welfare_copy$age

2015 - welfare_copy$birth -> age
welfare_copy$age <- age

welfare_copy %>% 
  filter(!is.na(income)) %>% 
  select(age, income) %>% 
  group_by(age) %>% 
  summarise(mean_income = mean(income)) %>% 
  arrange(desc(mean_income)) -> age_data

ggplot(
  data = age_data,
  aes(
    x = age,
    y = mean_income
  )
) + geom_col()

age_data %>% 
  arrange(desc(mean_income)) %>% 
  head(5)

# 연령대별 평균 임금

welfare_copy %>% 
  mutate(
    ageg = ifelse(age < 40,'young',
                  ifelse(age>=60, 'old', 'middle'))
    ) %>% 
  select(ageg, income) %>% 
  group_by(ageg) %>% 
  summarise(mean_income = mean(income, na.rm = T)) -> ageg_data

ggplot(
  data = ageg_data,
  aes(
    x = ageg,
    y = mean_income
  )
) + geom_col() + scale_x_discrete(limits = c('young','middle','old')) # x축 순서 커스텀

# excel 파일 로드
install.packages('readxl')
library(readxl)

read_excel('../csv/Koweps_Codebook.xlsx', sheet = 2) -> code_book

# join 결합
# welfare_copy, code_book -> 기준 : code_job
left_join_data <- left_join(
  welfare_copy,
  code_book,
  by='code_job'
)
str(left_join_data)
left_join_data

inner_join_data <- inner_join(
  welfare_copy,
  code_book,
  by='code_job'
)
str(inner_join_data)

welfare_copy %>% 
  filter(is.na(code_job) & !is.na(income))

# 직업별 평균 임금이 높은 상위 5개
left_join_data %>%
#  filter(!is.na(income) & gender == 'male') %>%  # 남자 기준
  filter(!is.na(income)) %>% 
  select(job, income) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income)) %>% 
  arrange(desc(mean_income)) %>% 
  head(5)

# income 결측치를 0
ifelse(is.na(left_join_data$income), 0, left_join_data$income) -> left_join_data$income

left_join_data %>% 
  filter(gender == 'female' & !is.na(job)) %>% 
  select(job, income) %>% 
  group_by(job) %>% 
  summarise(mean_income = mean(income)) %>% 
  arrange(-mean_income) %>% 
  head(5)















