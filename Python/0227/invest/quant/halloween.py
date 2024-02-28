import pandas as pd
from datetime import datetime
from dateutil.relativedelta import relativedelta

# 할로윈 전략 함수화
def six_month(_df, _col, _start = 2000, _end = datetime.now().year, _month = 11) :
    df = _df.copy()
    if 'Date' in df.columns :
        df.set_index('Date', inplace=True)

    df.index = pd.to_datetime(df.index, format='%Y-%m-%d')
    df = df[[_col]]

    result = pd.DataFrame() # 비어있는 데이터프레임

    for i in range(_start, _end) :
        start = datetime(year = i, month=_month, day=1)
        end = start + relativedelta(months=5)

        buy_month = start.strftime('%Y-%m')
        sell_month = end.strftime('%Y-%m')

        try :
            buy = df.loc[buy_month].head(1)
            sell = df.loc[sell_month].tail(1)

            result = pd.concat([result, buy, sell], axis=0)

        except :
            break


    result['rtn'] = 1
    for i in range(1, len(result), 2) :
        rtn = result.iloc[i,][_col] / result.iloc[i-1,][_col]
        result.iloc[i, 1] = rtn

    result['acc_rtn'] = result['rtn'].cumprod()
    acc_rtn = result.iloc[-1,]['acc_rtn']

    return result, acc_rtn