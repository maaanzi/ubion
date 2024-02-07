# 주석 설명 & 테스트용 코드

# 변수를 설명
a <- 10
print(a)
b = "test"
print(b)
TRUE -> c
print(c)

# 벡터 데이터 생성
# c() 함수를 이용하여 생성
# 일반적인 변수에는 데이터가 1개 대입
# 벡터 데이터를, 여러 개의 데이터를 하나의 변수에 대입
d <- c(1, 2, 3, 4, 5)
e <- c("test1", "test2", "test3")
print(d)
print(e)
# 특정 변수의 데이터 값이 변했다면 결과가 출력되지 않는다. 
# 메모리상 데이터가 변하지 않았다.를 알 수 있다. 
e
f <- 1:10

print(d[1])
print(e[1])

# 행렬 데이터 생성
# 2차원 데이터
arr_x = array(1:20, dim=c(4,5))
print(arr_x)
arr_y = array(1:20, dim=c(4,4))
print(arr_y)
arr_z = array(1:20, dim=c(4,6))
print(arr_z)

a = 'test'
print(a)

# 리스트 형태의 데이터생성
# 벡터 데이터에서 index(위치) 값 대신에 key 값을 지정
# 벡터 데이터 :  순서대로 데이터를 나열
# 리스트 데이터 : 순서와 상관없이 key값을 기준으로 데이터를 출력

list_a = list(name = 'test', age =20, phone='01012345678')
print(list_a)
print(list_a['name'])
b = c('test', 20, '01012345768')
print(b[1])

# 데이터 프레임 생성
# 2차원 데이터를 생성하는 과정
# 인덱스와 칼럼을 기준으로 데이터를 생성
df = data.frame (
  name = c("test1", "test2", "test3"),
  age = c(20, 30, 40),
  phone = c('01023457890', '01012316784', '01098172839')
)
print(df)

# 벡터의 개수를 다르게 데이터프레임을 생성
df2 = data.frame (
  name = c("test1", "test2", "test3"),
  age = c(20,30)
) # 개수가 맞지 않아 에러발생

# 연산자

# 산술연산자
x <- 10
y <- 3
print(x + y) 
x - y -> result # print 생략해도 출력됨
print(x * y)
print(x / y)
print(x ^ y)
print(x %% y)
print(x %/% y)

# 비교 연산자
# 두 개의 데이터를 비교하여 결과값은 논리값(참/거짓)으로 출력
z <- 5
print(x == y)
print(x != y)
print(x > y)
print(x < y)
print(x <= y)
# 에러 발생
# print(x =< y)

a = 1; b = 2

# 논리연산자
# 부정
print(!TRUE)
# and
# 두 개의 논리값들이 모두 참이 경우에만 출력
# 그 외는 거짓
print(TRUE & TRUE)
print(TRUE & FALSE)
# or
# 두 개의 논리값 중 하나만 참이여도 참을 출력
# 두 개 모두 거짓인 경우만 거짓
print(TRUE | TRUE)
print(TRUE | FALSE)
print(FALSE | FALSE)

# 조건문 (if문)
x = 10
if (x > 5) {
  print('x는 5보다 크다')
}

# if - else
# if 조건식이 참인경우 실행할 코드와
# else 문에서 조건식이 거짓인 경우 실행 할 코드 작성
if (x > 5) {
  print('x는 5보다 크다')
} else {
  print('x는 5보다 작거나 같다')
}

# 조건이 여러 개인 조건문
score <- 95
if (score > 90) {
  print('A학점입니다')
} else if (score > 80) {
  print('B')
} else if (score > 70) {
  print('C')
} else {
  print('F')
}

g <- 1
if (g) {
  print("TEST")
}

# if 조건식에 조건식이 2개 이상인 경우
id <- 'test'
pass <- '1234'

if (id == 'test' & pass == '1234') {
  print('로그인 성공')
} else {
  print('로그인 실패')
}

# which문
# 벡터데이터에서 조건식이 일치하는 데이터의 위치 값을 출력
name <- c('test', 'test2', 'test3')
which (name == 'test')

if (name[1] == 'test2') {
  print(1)
} else if (name[2] == 'test2') {
  print(2)
} else {
  print(3)
}

which(name != 'test2')
which(name == 'test5')

# for (i=1, i<3, i++) {
#   name[i] == 'test2'
#   print(i)
# }

# 반복문

# for
# 벡터데이터의 원소 개수만큼 반복 실행하는 구문
array_a = 1:10
total = 0
for(i in array_a) {
  total = total + i # 1~10까지의 합계
}
print(total)

# while
# 초기 시작값을 지정 후 반복 실행할 때 마다 증감
# 거짓일 때까지 실행
i = 1
while (i <= 10) {
  print(i)
  i = i + 1
}

i = 1
total = 0
while (i <= 10) {
  total = total + i
  i = i + 1 # 증감문을 넣어주어야 함
}
print(total)

arr_a <- 2:9
arr_b <- 1:9

for(i in arr_a) {
  for(j in arr_b) {
    print(i*j)
  }
}

#반복문 문제
# 두 주사위의 합이 5의 배수

num = 1:6
cnt = 0
for(i in num) {
  for (j in num) {
    if((i+j) %% 5 == 0) {
      print(c(i, j))
      cnt = cnt + 1
    }
  }
}
print(cnt)

# break : 반복문 강제 종료
for (i in 1:100) {
  if (i > 3) {
    break;
  }
  print(i)
}

# 1~100 합계 중 2000 넘어가는 숫자는 몇일까, 합계는?
result = 0
for(i in 1:100) {
  result = result + i
  if(result > 2000) {
    print(i)
    print(result)
    break;
  }
}

# 1씩 누적합 중 50000을 넘어서는 순간은?
i = 1
result = 0

while (1) {
  result = result + i
  
  if (result >= 50000) {
    print(i)
    print(result)
    break;
  }
  i = i + 1 # 위치 확인
}

# 1~100 숫자 중 짝수의 누적합
total = 0

for(i in 1:100) {
  if(i %% 2 == 0) {
    total = total + i
  }
}
print(total)
## -----
for(i in 1:50) {
  result = result + (i * 2) # 코드 효율
}
print(result)
## -----
i = 1
total = 0
while(i <= 100) {
  if (i %% 2 == 0) {
    total = total + i
  }
  i = i + 1
}
print(total)
## -----
i = 2
total = 0
## -----
while(1) {
  if (i > 100) {
    break
  }
  result = result + i
  i = i + 2
}
print(result)

#비순서형 벡터 데이터를 이용한 for문
array_a = c('Kim','Lee','Park')
for (i in array_a) {
  print(i)
}

i <- 1
while (i <= 3) {
#  print(i)
  print(array_a[i])
  i = i + 1
}

# next
# 반복문으로 되돌아감, 다음으로 넘어감
for(i in 1:10) {
  if(i < 5) {
    next
  }
  print(i)
}

result = 0
for (i in 1:100) {
  if (i %% 2 == 1) { # 짝수 합계
    next
  }
  result = result + i
}
print(result)

















