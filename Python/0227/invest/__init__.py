# 4개 투자 전략 모듈 로드
from invest.quant import bollinger as boll
from invest.quant import buyAndHold as bnh
from invest.quant import halloween as hw
from invest.quant import momentum as mmt
from datetime import datetime

import pandas as pd
import numpy as np

import importlib
importlib.reload(bnh)
importlib.reload(boll)
importlib.reload(hw)
importlib.reload(mmt)

class Invest :
    def __init__ (self, _df, _col = 'Adj Close', _start = '2010-01-01', _end = datetime.now()) :
        if 'Date' in _df.columns :
            _df.set_index('Date', inplace=True)

        _df.index = pd.to_datetime(_df.index, format='%Y-%m-%d')

        flag = _df.isin([np.nan, np.inf, -np.inf]).any(axis=1)
        self.df = _df.loc[~flag, [_col]]
        try:
            self.start = datetime.strptime(_start, '%Y-%m-%d')
            if type(_end) == 'str' :
                self.end = datetime.strptime(_end, '%Y-%m-%d')
            else :
                self.end = _end

        except :
            print('지원하지 않는 형식입니다.')
        
        self.col = _col

    def buyAndHold(self) :
        result, acc_rtn = bnh.buyandhold(self.df, self.col, self.start, self.end)
        print(acc_rtn)
        return result, acc_rtn
    
    def bollinger(self, _cnt=20) :
        print("class cnt :", _cnt)
        band_df = boll.createBand(self.df, self.col, _cnt, self.start, self.end)
        trade_df = boll.createTrade(band_df)
        result, acc_rtn = boll.createRtn(trade_df)

        return result, acc_rtn
    
    def halloween(self, _month=11) :
        h_start = self.start.year
        h_end = self.end.year
        result, acc_rtn = hw.six_month(self.df, self.col, h_start, h_end, _month)
        return result, acc_rtn
    
    def momentum(self, _momentum=12, _score=1, _select = 1) :
        ym_df = mmt.createSTD_YM(self.df, self.col)
        month_df = mmt.create_month(ym_df, self.start, self.end, _momentum, _select)
        result, acc_rtn = mmt.create_rtn(ym_df, month_df, _score)

        return result, acc_rtn
    
    
        