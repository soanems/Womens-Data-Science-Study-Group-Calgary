from datetime import datetime
import pandas as pd
from functools import reduce

# data is: 
# power production by asset across columns, plus some extra info
# each row is all the data for a given hour
# we also have a list of assets, but not their power types
# data only goes until the end of 2021

# what we want:
# add some columns of the total power production for each power type over time
# add on the latest data from 2022

import pandas as pd

df = pd.read_csv("./data/Hourly_Metered_Volumes_and_Pool_Price_and_AIL.csv")
assets = pd.read_csv("./data/AssetListReportServlet.csv")

df
assets

date_columns = ['Date_Begin_GMT', 'Date_Begin_Local']
price_columns = ['ACTUAL_POOL_PRICE', 'ACTUAL_AIL', 'DAY_AHEAD_POOL_PRICE']
interchange_columns = ['EXPORT_BC', 'EXPORT_MT', 'EXPORT_SK',
                       'IMPORT_BC', 'IMPORT_MT', 'IMPORT_SK']

# all the other columns are assets
asset_columns = [v for v in df.columns.values if v not in date_columns and v not in price_columns and v not in interchange_columns]

# when None, there is 0 power - needed to be able to sum
df = df.fillna(0)

# parse date into python datetime
df['Date_Begin_Local'] = pd.to_datetime(df['Date_Begin_Local'], format="%d%b%Y:%H:%M:%S")
df = df.drop(columns=['Date_Begin_GMT'])

from functools import reduce
def calculate_total(asset_names):
    return reduce(lambda total, asset: total + df[asset], asset_names, 0)

df['total_all'] = calculate_total(asset_columns)

# data exploration

df

df['total_all'].describe()
df['Date_Begin_Local'].describe(datetime_is_numeric=True)

df.hist(column="total_all")

df.plot(x='Date_Begin_Local', y='total_all')

from datetime import datetime
df_2021 = df[df['Date_Begin_Local'] >= datetime(2021, 1, 1)]
df_2021.plot(x='Date_Begin_Local', y='total_all')

# drop stuff we don't need
df = df.drop(columns=price_columns)
df = df.drop(columns=interchange_columns)
df = df.drop(columns=['total_all']) # will add back in later
# export csv
df.to_csv('./data/data_cleaned.csv', index=False)

# from here: add new data, and find totals by power type