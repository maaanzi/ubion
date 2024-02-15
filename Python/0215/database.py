import pymysql

class MyDB :
    # 생성자 함수 : db서버의 정보를 입력값으로 불러온다
    def __init__(
            self, 
            _host = '127.0.0.1',
            _port = 3306,
            _user = 'root',
            _password = '12340000',
            _database = 'ubion10'
        ) :
        # 객체 변수 생성
        self.host = _host
        self.port = _port
        self.user = _user
        self.password = _password
        self.database = _database

    def sql_query(self, sql, *values) :
        # db 서버 연결
        _db = pymysql.connect(
            host = self.host,
            port = self.port,
            user = self.user,
            password = self.password,
            db = self.database
        )
        # 커서 생성
        cursor = _db.cursor(pymysql.cursors.DictCursor)

        cursor.execute(sql, values)

        if sql.lower().split()[0] == 'select' :
            result = cursor.fetchall()
        else :
            _db.commit()
            result = 'Query OK'

        _db.close() # 연결 종료
    
        return result