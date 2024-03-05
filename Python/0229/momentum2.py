import pandas as pd
import numpy as np
import glob
import os
from datetime import datetime

# 월별 수익률 계산하는 함수
def create_1M_rtn(_df, _ticker, _start = '2010-01-01', _col = 'Adj Close') :
    result = _df.copy()

    if 'Date' in result.columns :
        result = result.loc[result['Date'] >= _start, ['Date', _col]]
        result['Date'] = pd.to_datetime(result['Date'], format='%Y-%m-%d')
    else :
        result.index = pd.to_datetime(result.index, inplace=True)
        result = result.loc[_start : , [_col]]
        result.reset_index(inplace=True)

    result['STD-YM'] = result['Date'].dt.strftime('%Y-%m') # 기준연월 컬럼 생성
    result['1m_rnt'] = 0
    result['CODE'] = _ticker

    ym_list = result['STD-YM'].unique() # unique() : 중복값제외

    return result, ym_list

# 함수 생성 (경로 지정 매개변수)
def data_load(_path = './data/') :
    files = glob.glob(f'{_path}/*.csv')

    stock_df = pd.DataFrame() # 종목별
    month_last_df = pd.DataFrame() # 월말

    for file in files :
        folder, name = os.path.split(file) # 경로와 파일이름이 나눠짐
        head, tail = os.path.splitext(name) # 이름과 확장자가 나눠짐
        print(head, tail) # GDX .csv

        read_df = pd.read_csv(file) # file : ./data/AAPL.csv 경로가 들어있음

        price_df, ym_list = create_1M_rtn(read_df, head)

        stock_df = pd.concat([stock_df, price_df], axis=0)

        for ym in ym_list :
            flag = price_df['STD-YM'] == ym

            # 월별 수익률
            m_rtn = price_df.loc[flag, ].iloc[-1, 1] / price_df.loc[flag, ].iloc[0,1] # 월말 / 월초
            price_df.loc[flag, '1m_rtn'] = m_rtn
            data = price_df.loc[flag, ['Date', 'CODE', '1m_rtn']].tail(1) # 월말 데이터들
            month_last_df = pd.concat([month_last_df, data], axis=0)

    return stock_df, month_last_df

# 월별 수익률 기준 랭크 설정 함수
def create_position(_df, _pct = 0.15) :
    df = _df.copy()

    rank_df = df.pivot_table(
        index='Date',
        columns='CODE',
        values='1m_rtn' # 월말 데이터(= 월별수익률)
    )

    rank_df = rank_df.rank(
        axis=1,
        ascending=False, # 내림차순
        method='max', # 최대치부터
        pct=True
    ) 

    rank_df = rank_df.where(rank_df < _pct, 0)

    rank_df[rank_df != 0] = 1

    sig_dict = dict() # 어떤 월에 어떤 종목을 사면 되는지 ?

    for date in rank_df.index :
        ticker_list = list(rank_df.loc[date, rank_df.loc[date] >= 1].index)
        sig_dict[date] = ticker_list

    stock_codes = list(rank_df.columns)

    return sig_dict, stock_codes

# 거래 내역을 담아주는 데이터프레임
def create_trade_book(_df, _code, _sig_dict) :
    book = _df.pivot_table(
        index='Date',
        columns='CODE',
        values=_df.columns[1] # 월말 데이터(= 월별수익률)
    )

    book['STD-YM'] = book.index.strftime('%Y-%m')
    for c in _code:
        book['p' + c] = '' # 구매시기?
        book['r' + c] = '' # 수익률

    for date, values in _sig_dict.items() : # (key, value)
        for stock in values : # 주식명
            book.loc[date, 'p'+stock] = 'ready' + stock

    return book

# 거래 내역 추가
def trading(_book, s_code) :
    book = _book.copy()
    std_ym = ''
    buy_phase = False

    # 종목별로 순회
    for code in s_code :
        for i in book.index :
            if (book.loc[i, 'p' + code] == '') & (book.shift().loc[i, 'p' + code] == 'ready' + code) :
                std_ym = book.loc[i, 'STD-YM']
                buy_phase = True

            # 해당 종목코드에 신호가 잡혀있다면 매수 상태 유지
            if (book.loc[i, 'p' + code] == '') & (book.loc[i, 'STD-YM'] == std_ym) & (buy_phase) :
                book.loc[i, 'p' + code] = 'buy' + code

            # std_ym, buy_phase 초기화
            if book.loc[i, 'p' + code] == '' :
                std_ym = ''
                buy_phase = False
        
    return book

# 수익률 계산 함수
def multi_returns(_book, s_code) :
    book = _book.copy()
    rtn = 1
    buy_dict = dict()
    sell_dict = dict()

    for i in book.index :
        for code in s_code :
            # 매수 (p+code), 2일전에 "" 1일전 ready 오늘 buy인 상태
            if (book.shift(2).loc[i, 'p' + code] == '') & \
                (book.shift().loc[i, 'p' + code] == 'ready' + code) & \
                (book.loc[i, 'p' + code] == 'buy' + code) :
                    buy_dict[code] = book.loc[i, code]
                    print(f'매수일 : {i}, 종목코드 : {code}, 매수가 : {buy_dict[code]}')

            # 매도 : 1일전 pcode는 buy, 오늘 ''
            elif (book.shift().loc[i, 'p' + code] == 'buy' + code) & \
                (book.loc[i, 'p' + code] == '') :
                    sell_dict[code] = book.loc[i, code]
                    rtn = sell_dict[code] / buy_dict[code]
                    book.loc[i, 'r' + code] = rtn
                    print(f'매도일 : {i}, 종목코드 : {code}, 매도가 : {sell_dict[code]}, 수익률 : {rtn}')

            if book.loc[i, 'p' + code] == '' :
                  buy_dict[code] = 0
                  sell_dict[code] = 0
    return book

# 누적 수익률 계산 함수
def multi_acc_returns(_book, s_code) :
    book = _book.copy()
    acc_rtn = 1
    for i in book.index :
        count = 0
        rtn = 0
        for code in s_code :
            if book.loc[i, 'r' + code] :
                count += 1
                rtn += book.loc[i, 'r' + code]
        if (rtn != 0) & (count != 0) :
            acc_rtn *= (rtn / count)
            print(f'누적 매도일 : {i}, 매도 종목 수 : {count}, 수익률 : {round(rtn/count, 2)}')
        book.loc[i, 'acc_rtn'] = acc_rtn

    return book, acc_rtn