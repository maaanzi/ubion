import pandas as pd
import numpy as np
from datetime import datetime

def createSTD_YM(_df, _col = 'Adj Close') :
    df = _df.copy()
    if 'Date' in df.columns :
        df.set_index('Date', inplace=True)
    
    df.index = pd.to_datetime(df.index, format='%Y-%m-%d')
    df = df[['Adj Close']]

    flag = df.isin([np.nan, np.inf, -np.inf]).any(axis=1)
    df = df.loc[~flag, [_col]]

    df['STD-YM'] = df.index.strftime('%Y-%m')

    return df


def create_month(_df, _start='2010-01-01',_end = datetime.now(), _momentum = 12, _select = 1) :
    if _select == 1 :
        flag = _df['STD-YM'] != _df.shift(-1)['STD-YM'] # 후 행과 다른지 확인 : 월말
    elif _select == 0 :
        flag = _df['STD-YM'] != _df.shift()['STD-YM'] # 전 행과 다른지 확인
    else :
        return 'select 인자는 0과 1이 가능하다'

    col = _df.columns[0] # Adj Close
    df = _df.loc[flag, ]

    df['BF1'] = df.shift()[col].fillna(0)
    df['BF2'] = df.shift(_momentum)[col].fillna(0)

    try :
        if type(_start) == 'str' :
            start = datetime.strptime(_start, '%Y-%m-%d')
        else :
            start = _start
            
        if type(_end) == 'str' :
            end = datetime.strptime(_end, '%Y-%m-%d')
        else :
            end = _end
    except :
        return '인자값의 타입이 잘못되었습니다. (예) YYYY-mm-dd)'

    df = df.loc[start : end, ]
    return df


def create_rtn(_df1, _df2, _score = 1) :
    _df1['trade'] = ""
    _df1['rtn'] = 1

    for i in _df2.index :
        signal = ""

        momentum_index = _df2.loc[i, 'BF1'] / _df2.loc[i, 'BF2'] - _score

        flag = (momentum_index > 0) & (momentum_index != np.inf)

        if flag :
            signal = 'buy'

        _df1.loc[i : , 'trade'] = signal
        print(f'날짜 : {i}, 모멘텀 인덱스 : {momentum_index}, flag : {flag}, signal : {signal}')

    col = _df1.columns[0]

    for i in _df1.index :
        if (_df1.shift().loc[i, 'trade'] == "") & (_df1.loc[i, 'trade'] == 'buy') :
            buy = _df1.loc[i, col]
            print(f'매수일 : {i}, 매수가 : {buy}')
        elif (_df1.shift().loc[i, 'trade'] == 'buy') & (_df1.loc[i, 'trade'] == "") :
            sell = _df1.loc[i, col]
            rtn = sell / buy
            _df1.loc[i, 'rtn'] = rtn
            print(f'매도일 : {i}, 매도가 : {sell}, 수익률 : {rtn}')
        
    _df1['acc_rtn'] = _df1['rtn'].cumprod()

    acc_rtn = _df1.iloc[-1, ]['acc_rtn']

    return _df1, acc_rtn