import pandas as pd
import numpy as np
import requests
import io
import time

import datetime

# make requests to the API
import requests
api_url = "http://ets.aeso.ca/ets_web/ip/Market/Reports/PublicSummaryAllReportServlet"
def get_daily_metered_data(date):
    date_string = date.strftime("%m%d%Y")
    url = api_url+"?beginDate="+date_string+"&endDate="+date_string+"&contentType=csv"
    response = requests.get(url).content.decode('utf-8')
    return response

get_daily_metered_data(datetime.date(2022,1,1))

# gets a pandas dataframe for one day, and transforms it to match historical data format
import pandas as pd
import numpy as np
import io
static_column_names = ["Pool_Participant_Id", "Asset_Type", "Asset_Id"]
def get_daily_df(date):
    response = get_daily_metered_data(date)
    df = pd.read_csv(io.StringIO(response), header=[5])
    # column names on this CSV are: first 3 plus 1 column per hour
    times = list(map(lambda hour: datetime.datetime.combine(date , datetime.time(hour = hour)),list(range(0, 24))))
    df.columns = [*static_column_names, *times]
    # filter for power sources (not transfers/usage/storage)
    df = df[(df['Asset_Type'] == 'GENCO') | (df['Asset_Type'] == 'IPP')]

    # combine all the hours into one
    df = df.melt(id_vars=static_column_names, 
            var_name="Datetime", 
            value_name="Metered_Value")

    # pivot to the same format as historical data
    df = df.pivot_table(index='Datetime', columns='Asset_Id', values=['Metered_Value'], aggfunc=np.sum)['Metered_Value']
    return df


df = get_daily_df(datetime.date(2022,1,1))
df

# loop through from start date to end date and append data to csv

start_date = datetime.date(2022,1,1)
end_date = datetime.date(2022,3,23)

import time
date = start_date
full_df = pd.DataFrame()
while date <= end_date:
    print(date)
    time.sleep(0.2) # prevents us from sending too many requests
    df = get_daily_df(date)
    full_df = full_df.append(df)
    date += datetime.timedelta(days=1)
full_df

full_df.to_csv("./data/2022_data.csv")






# same function for DeepSea
# loop through from start date to end date and append data to csv
def get_new_data(start_date, end_date):
    import time
    date = start_date
    full_df = pd.DataFrame()
    while date <= end_date:
        # print(date)
        time.sleep(0.2) # prevents us from sending too many requests
        df = get_daily_df(date)
        full_df = full_df.append(df)
        date += datetime.timedelta(days=1)
    return full_df
