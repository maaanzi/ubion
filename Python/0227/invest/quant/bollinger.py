import pandas as pd
import numpy as np
from datetime import datetime


def createBand(_df, _col='Adj Close', _cnt = 20 , _start = '2010-01-01', _end = datetime.now()) :
    df = _df.copy()
    if 'Date' in df.columns:
        df.set_index('Date', inplace=True)
    
    df.index = pd.to_datetime(df.index, format='%Y-%m-%d') # datetime으로 바꿔주기
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
    
    flag = df.isin([np.nan, np.inf, -np.inf]).any(axis=1) # -np.inf : 음의 무한대, any() : 하나라도 True일 경우 True 반환
    df = df.loc[~flag, ] # 결측치, 무한대 제외

    result = df[[_col]] # 기준이 되는 컬럼만 뽑기

    result['center'] = result[_col].rolling(_cnt).mean() # 20일치 평균
    result['ub'] = result['center'] + (2 * result[_col].rolling(_cnt).std())
    result['lb'] = result['center'] - (2 * result[_col].rolling(_cnt).std())

    result = result.loc[start:end, ]

    return result


def createTrade(_df) :
    df = _df.copy()
    df['trade'] = ""

    # 기준이 되는 컬럼명
    col = _df.columns[0]

    for i in df.index :
        if df.loc[i, col] >= df.loc[i, 'ub'] :
            df.loc[i, 'trade'] = ""
        elif df.loc[i, col] <= df.loc[i, 'lb'] :
            df.loc[i, 'trade'] = "buy"
        else :
            if df.shift().loc[i, 'trade'] == "" :
                df.loc[i, 'trade'] = df.shift().loc[i, 'trade'] # 어제 값과 똑같이 유지
    
    return df

def createRtn(_df) :
    df = _df.copy()
    df['rtn'] = 1

    col = _df.columns[0]

    for i in df.index :
        if (df.shift().loc[i, 'trade'] == "") & (df.loc[i, 'trade'] == "buy") :
            buy = df.loc[i, col]
            print(f'매수일 : {i}, 매수가 : {buy}')
        elif (df.shift().loc[i, 'trade'] == "buy") & (df.loc[i, 'trade'] =="") :
            sell = df.loc[i, col]
            rtn = sell / buy
            print(f'매도일 : {i}, 매도가 : {sell}, 수익률 : {rtn}')
            df.loc[i, 'rtn'] = rtn
    
    df['acc_rtn'] = df['rtn'].cumprod()
    acc_rtn = df.iloc[-1,]['acc_rtn']

    return df, acc_rtn