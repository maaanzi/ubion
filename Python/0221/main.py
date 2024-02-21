# flask 프레임워크 로드
from flask import Flask, render_template, request, redirect # flask : 웹서버 구동, render_template : 웹페이지 리턴
import database # 모듈
import pandas as pd

mydb = database.MyDB( # 모듈
    _host = '172.16.12.155',
    _port = 3306,
    _user = 'ubion',
    _password = '1234',
    _database = 'ubion10'
)

# Flask class 생성
app = Flask(__name__) # __name__ : 현재 파일의 이름 출력

# 네비게이터 생성 : 해당 주소로 함수 호출
@app.route("/")
def index() :
    # return "Hello World"
    return render_template('index.html')

@app.route('/login')
def login() : # 유저가 보낸 데이터를 서버에 변수로 저장
    user_id = request.args['input_id']
    user_pass = request.args['_password']
    print(request.args)
    print('ID : ', user_id) # 로그 출력
    print('PASS : ', user_pass)

    sql = """
        select * from user
            where id = %s and password = %s
    """
    print(result) # print : 로그 출력!!!

    if result  :
        return '로그인 성공'
    
    else :
        return '로그인 실패'
    
@app.route('/login2', methods=['post']) # post방식으로 요청
def login2() :
    user_id = request.form['input_id']
    user_pass = request.form['input_password']
    # print(request.form)
    # print(user_id)
    # print(user_pass)

    sql = """
        select * from user
            where id = %s and password = %s
    """
    result = mydb.sql_query(sql, user_id, user_pass)
    # print(result) # print : 로그 출력!!!

    if result  :
        user_name = result[0]['name']
        return render_template('main.html', _name = user_name)
    else :
        return redirect('/') # redirect('주소')
    
@app.route('/view_corona')
def view_corona() :
    df = pd.read_csv('corona.csv', index_col=0)
    df = df[['createDt', 'deathCnt','decideCnt','stateDt']]
    df.columns = ['등록일시','총사망자','총확진자','기준일']
    df.sort_values('기준일', inplace=True)
    df.reset_index(drop=True, inplace=True)
    df['일일사망자'] = df['총사망자'].diff().fillna(0)
    df['일일확진자'] = (df['총확진자'] - df['총확진자'].shift()).fillna(0)
    result = df.tail(10)
    cols = result.columns
    val = result.values
    cols_cnt = len(cols)
    val_cnt = len(val)
    x = result['기준일'].to_list()
    y = result['일일사망자'].to_list()
    print(cols)
    print(val)
    return render_template('corona.html', columns = cols, values = val, c_cnt = cols_cnt, v_cnt = val_cnt, x = x, axis_y = y)


@app.route('/corona')
def corona() :
    serviceKey = request.args['serviceKey']

    _limit = request.args['_limit']
    print(_limit)

    if serviceKey == 'aaa' :
        sql = f"select * from corona limit {_limit}" # limit : 데이터 개수 제한
        result = mydb.sql_query(sql)
        return result
    else :
        return 'Service Key Error'



app.run(port=8080, debug=True)
