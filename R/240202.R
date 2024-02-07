# 매개변수가 존재하지 않는 함수를 생성
func_1 <- function() {
  print('hello R')
}

# 생성된 함수 호출
func_1()

func_2 <- function() {
  return ('Hello R')
}

func_2()
result1 <- func_1()
result2 <- func_2()

# 매개변수가 존재하는 함수 생성
func_3 <- function(input_x, input_y) {
  result = input_x +input_y
  print(result)
}

result3 = func_3(10,3)

# 변수의 종류
# 전역변수 (전체의 영역에서 사용가능한 변수)
# 지역변수 (함수 내부에서만 사용가능) -> 휘발성 변수
# 매개변수 (함수가 생성될 때 인자 값(=입력값)이 저장되는 공간) -> 내부에서만 사용

# 매개변수와 인자의 개수를 다르게 호출하는 경우
func_3(10) # 오류
func_3(10,3,2) # 오류

# 인자의 개수가 가변인 경우
func_4 <- function(...) {
  print(c(...))
}
func_4() # NULL
func_4(1,2,3,4)

# 커스텀 연산
"%s%" <- function(input_x, input_y) {
  result <- input_x ^ input_y
  return(result)
}
10 %s% 5

# 매개변수에 기본값 설정
func_5 <- function(input_x,input_y = 2,input_z = 3) {
  result <- input_x + input_y - input_z
  return(result)
}
func_5(5,10,3)
func_5(5)

# func_5(10, ,6)
func_5(10, input_z = 1)

# 매개변수가 2개
# 사이값들을 모두 합하는 함수
total = 0
func_6 <- function(start, end) {
  for (i in start:end) {
    total = total + i
  }
  return (total) # 리턴 꼭 주기
}
func_6(2,5)

min(3,6,1,5,9)
max(3,6,1,5,9)

#최소값 구하기
# 첫번째 매개변수는 데이터 하나를 저장
# 두번째 매개변수는 인자의 개수가 가변인 경우
func_8 <- function(val, val2) {
  result <- val # result와 두번째 입력값을 비교해 최솟값 저장
  if(val > val2) {
    result <- val2
  }
  return (result)
}
func_8(3,5)

func_8 <- function(val, ...) {
  result <- val
  for (i in c(...)) {
    if(result > i) {
      result <- i
    }
  }
  return(result)
}
func_8(2,5,6,7,8)

mean(c(5,2,1)) # 평균값

# 평균값 출력하는 함수
total = 0
cnt = 0
fn1 <- function(...) {
  for(i in c(...)) {
    total = total + i
    cnt = cnt + 1
  }
  return(total/cnt)
}
fn1(5,2,1)

func_10 <- function(...) {
  result = sum(...) / length(c(...))
  return(result)
}

func_10(5,2,1)

test_sum <- function(...) {
  result = 0
  for (i in c(...)) {
    result = result + i
  }
  return (result)
}
test_sum(2,5,6)
test_sum()

test_len <- function(value) {
  cnt = 0
  for (i in value) {
    cnt = cnt + 1
  }
  return (cnt)
}
test_len(c(2,5,7))
test_len()

# 데이터프레임 생성
# 벡터데이터 이용
name <- c('A','B','C','D','E')
grade <- c(1,3,2,2,1)
data.frame(name, grade) -> student

# 행렬 생성
# cbind() : 열 추가
midterm <- c(70,80,75,60,90)
final <- c(80,90,70,75,85)
score <- cbind(midterm, final)

# 행렬과 데이터 프레임 결합
data.frame(student, score)
cbind(student,score)

# 벡터데이터 생성
gender = c('M','F','F','M','F')

# 데이터프레임 + 벡터 데이터 + 행렬
data.frame(student, gender, score)
cbind(student, gender, score) -> students

# 길이가 다른 벡터 결합
test_vec = c(1,2,3,4)
cbind(students, test_vec)
data.frame(students, test_vec)

# 파생변수 생성
# 새로운 컬럼 추가 -> 분석에 필요한 데이터가 없을 때 가공하는 과정
students

# 백터데이터들의 합
midterm + final

# 특정 컬럼의 합
students$midterm # 벡터형식
students$midterm + students[['final']] -> total # $컬럼명, [['컬럼명']] 동일

# cbind(), data.frame() 함수를 이용하여 파생변수 생성
cbind(students, total)
data.frame(students, total) # -> cbind, data.frame 결과 같음, !!!!!저장 안됨!!!!!

students$total <- students$midterm + students$final
students

# students 에 파생변수 생성
# 평균성적, 컬럼 : mean

(students$midterm + students$final) / 2 -> mean # students$total과 동일
data.frame(students, mean) # cbind와 동일
students$mean <- students$total / 2 # 컬럼 저장

# 새로운 학생 정보 추가 (순서 바껴도 컬럼명을 인식함)
data.frame(name="F", grade=3, gender='M', midterm=60, final=80, total=140, mean=70) -> new_student

rbind(students, new_student) # 행 추가
data.frame(students, new_student) # 열 추가로 됨

# 리스트형태의 데이터
list_a = list(name = 'test', age = 20)
list_a$loc = 'Seoul'
list_a

# value값이 벡터 데이터인 경우
list_b = list(
  name = c('test','test2'),
  age = c(20,30)
)
list_b

list_b$name[1] # test 만 출력
list_b[['name']][1]

# 필터
# 데이터프레임명 [행의 조건, 열의 조건]
students[1,]
students[c(1,3),]

# 1학년인 학생의 정보만 출력
students$grade == 1 -> flag
students[flag,]
!flag
students[!flag, ]

# 행과 열 모두 조건식으로 추출
# 여학생들의 중간, 기말 성적만 추출
students$gender == 'F' -> flag2
students[flag2, ]
students[flag2, c('midterm', 'final')] # 열 조건이 2개 이상이 때는 벡터로 묶기

# 중간, 기말성적이 80이상인 학생
students$midterm >= 80 & students$final >= 80 -> flag3
students[flag3, c('midterm', 'final')]

students$midterm >= 80 -> mid
students$final >= 80 -> fin
students[mid & fin, ]
students[mid & fin] # 열 정렬 (T,F를 따르고 부족하면 다시 돈다) 추측임
students

# 컬럼의 순서를 변경하는 함수
student[c('grade','name')]
student

# 인덱스의 순서를 변경
students[c(3,4,5,1,2), ]
students

# order() : 정렬 위치 출력, default : 오름차순
# 학년을 기준으로 오름차순 정렬
order(students$grade) -> flag5
students[flag5, ]

# 기말성적을 기준으로 내림차순 (decreasing = TRUE)
order(students$final, decreasing = TRUE) -> flag6
students[flag6, ]
order(-students$final) # -를 붙여도 내림차순이 된다 : 수가 클수록 작아지기 때문 -> 숫자일때만

order(students$name, decreasing = TRUE)

students[flag6, ]

install.packages('dplyr')
library(dplyr)

# rename()
# 컬럼 이름 변경
students
rename(students, mean_score = mean)
students <- rename(students, mean_score = mean)

# ifelse(조건식, 참인경우 출력값, 거짓인 경우 출력값)
# 조건식을 이용하여 파생변수 생성
ifelse(
  students$mean_score >= 75,
  'pass',
  'fail'
) -> res
students$result <- res
students

# 75점 초과인 경우 pass
# 75점 인 경우는 hold
# 75점 미만인 경우는 fail

ifelse(
  students$mean_score > 75,
  'pass',
  ifelse(
    students$mean_score == 75,
    'hold',
    'fail'
  )
)

package_version(R.version)






