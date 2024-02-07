# 패키지 설치
install.packages('dplyr')

# 패키지 로드
library(dplyr)

# 파일 경로
# 1. 절대 경로
# 2. 상대 경로
# ./ : 현재 작업중인 디렉토리
# ../ : 상위 디렉토리로 이동

# 외부 데이터 파일 로드 (csv) : read.csv(파일경로)
df <- read.csv('../csv/example.csv') # 상대
df

df2 <- read.csv('/Users/minzy/Desktop/ubion/csv/example.csv') # 절대
df2

# 파이프 연산자
# %>% : command + shift + M
# 왼쪽에 있는 데이터를 오른쪽 함수에 대입

# head : 상위 n개 출력
head(df, 3)
df %>% head(3)

# 인덱스의 조건식으로 필터링
# filter(조건식)
df %>% filter(Gender == 'male')
df

# base 함수로 필터링
df$Gender == 'male' -> flag
df[flag, ]

# 특정 컬럼의 데이터만 출력
# 패키지 사용
df %>% select(Name, Phone)
df %>% select(-Gender) # Gender컬럼 제외

# Base
df[c('Name', 'Phone')]

# 성별이 남자인 데이터 중 이름과 연락처만
df %>% 
  filter(Gender == 'male') %>% 
  select(Name, Phone)

df$Gender == 'male' -> flag
df[flag, c('Name', 'Phone')]

exam <- read.csv('../csv/csv_exam.csv')

# 내림차순
order(exam$math, decreasing == TRUE) -> flag3
exam[flag3, ]

# 정렬 방식의 조건이 2개 이상인 경우
# 학년 별로 내림차순 정렬, 수학 성적은 오름차순
exam %>%
  arrange(desc(class), math)

# 그룹화 연산
# class 별 수학, 과학, 영어의 평균 점수를 출력
exam %>% 
  group_by(class) %>% 
  summarise(
    mean_math = mean(math),
    mean_english = mean(english),
    mean_science = mean(science),
  )

# 데이터프레임 결합
# 행 결합 : 유니온 결합
# 열 결합 : 조인 결합

# 유니온(행)
df1 <- data.frame(
  id = 1:5,
  score = c(70,80,65,80,90)
)
df2 <- data.frame(
  id = 3:6,
  weight = c(60,50,70,80)
)

# 행 결합 함수 (rbind() : 구조가 같은 데이터만 결합)
rbind(df1, df2) # 에러(구조가 달라서)

df3 <- data.frame(
  id = 3:7,
  score = c(50,70,80,34,47)
)

rbind(df1, df3)

# bind_rows() : 데이터의 구조와 상관없이 데이터를 결합
bind_rows(df1, df2)
bind_rows(df1, df2, df3)

# join
df4 <- data.frame(
  id = c('test1', 'test2', 'test3', 'test4'),
  item = c('A','B','B','D')
)

df5 <- data.frame(
  item = c('A','B','C'),
  price = c(1000,2000,3000)
)

# inner_join() : 겹치는 데이터만 출력
inner_join(df4, df5, by='item') # item 기준

# left_join() : 왼쪽 기준으로 결합
left_join(df4, df5, by='item')
right_join(df4, df5, by='item')
full_join(df4, df5, by='item')

install.packages('ggplot2')
library(ggplot2)

# ggplot2 패키지 안에 샘플데이터 로드
midwest <- ggplot2::midwest

head(midwest, 3)
str(midwest) # 데이터 속성 출력

View(midwest) # 뷰어 창에서 확인

# 컬럼의 이름 변경
# rename(데이터프레임명, 새컬럼명 = 변경할 컬럼명)
rename(midwest, asian = popasian) -> midwest
rename(midwest, total = poptotal) -> midwest

# 복사본 생성 (county, asian, total 만 저장)
# filter : index, select : column
midwest[c('county', 'asian', 'total')]

# 패키지 사용
midwest %>% 
  select(county, asian, total) -> df

# 전체 인구수 대비 아시아 인구 비율 컬럼 생성 (ratio)
( df$asian / df$total ) * 100 -> ratio

bind_cols(df, ratio = ratio) # 벡터 데이터로 잇는 거라 컬럼명을 지정해주어야 함
cbind(df, ratio)
data.frame(df, ratio)
df$ratio <- ratio
head(df, 1)

# 패키지 이용해 파생변수 추가
df2 <- midwest[c('county','asian','total')]

# mutate() : 파생컬럼 생성 함수
df2 %>% 
  mutate(ratio = (asian / total) * 100) # df2에 들어가지 않은 상태 (할당해줘야함)

# 히스토그램 : hist(벡터데이터)
hist(df$ratio)

# 전체 ratio의 평균 값 출력
mean(df$ratio) -> mean_ratio

# mean_ratio와 ratio 비교해 평균값 보다 높은 경우 large, 이하인 경우 small
# 컬럼명 : group

df$ratio > mean_ratio -> flag4

# ifelse(조건식, 참인 경우, 거짓인 경우)
ifelse(flag4, 'large', 'small') -> group_data
df$group = group_data

df %>% 
  mutate(group = ifelse(
                 ratio > mean(ratio),
                 'large',
                 'small'
                 )
  ) -> df

table(df$group) # 함수 개수 확인

# midwest 데이터에서 데이터 정제
# 컬럼의 이름 변경
# popadult -> adult, poptotal -> total
# county, adult, total 따로 추출해 변수에 저장
# 전체 인구수 대비 미성년자의 인구비율 : child_ratio
# child_ratio 가장 높은 상위 5개의 지역 출력
#   1. 미성년자 인구수 컬럼 생성 : total - adult
#   2. 미성년자 인구수 / 총 인구수 * 100 -> child_ratio
rename(midwest, adult = popadults) -> midwest
midwest$adult -> adult
# rename(midwest, total = poptotal)

midwest %>% select(county, adult, total) -> test

(midwest$total - midwest$adult) / midwest$total * 100 -> child_ratio
cbind(test, child_ratio)

test$child_ratio <- child_ratio
test %>% arrange(desc(child_ratio)) -> test

head(test, 5)

# 답안
rename(midwest, adult = popadults) -> midwest
rename(midwest, total = poptotal) -> midwest

df <- midwest[c('county','adult','total')]

df$total - df$adult -> df$child
(df$child / df$total) * 100 -> df$child_ratio
order(df$child_ratio, decreasing = TRUE) -> flag
df[flag, ] -> df

head(df, 5)

# %>%(파이프) : 결과를 쭉쭉 이어주는 것 (중간중간 변수 할당 안해도 됨 대박~)
# 원본 데이터 유지
midwest <- ggplot2 :: midwest

midwest %>%
  rename(adult = popadults, total = poptotal) %>%
  select(county, adult, total) %>% 
  mutate(child = total - adult,
         child_ratio = child / total * 100) %>% 
  arrange(desc(child_ratio)) %>% 
  head(5)
  




