import csv
import re
from bs4 import BeautifulSoup
import requests

# get current supply & demand page
import requests
response = requests.get("http://ets.aeso.ca/ets_web/ip/Market/Reports/CSDReportServlet")
html_text = response.text
html_text

# find the tables using BeautifulSoup
from bs4 import BeautifulSoup
soup = BeautifulSoup(html_text, 'html.parser')
types_tables = soup.find_all("table")[10:]
types_tables

# get asset id out of asset name row
def get_row_asset_id(row):
    return row.text.split('(')[1].split(')')[0]

# reads type and assets out of table
import re
def get_assets_of_type(table):
    title_html = table.find('th')
    title_text = title_html.text
    
    # finds all the tds with (asset) in the table
    asset_rows = table.findAll('td', string=re.compile('\('))
    assets = list(map(get_row_asset_id, asset_rows))
    return title_text, assets

# test out our function: gets types & assets
assets = get_assets_of_type(types_tables[5])
assets

# loop through tables and save their assets into a dictionary
types = {
    'GAS': 'gas',
    'HYDRO': 'hydro',
    'ENERGY STORAGE': 'energy_storage',
    'SOLAR': 'solar',
    'WIND': 'wind',
    'BIOMASS AND OTHER': 'biomass_other',
    'DUAL FUEL': 'dual_fuel',
    'COAL': 'coal',
}
other_types_tables = [types_tables[2], types_tables[3], types_tables[4], types_tables[5], types_tables[7], types_tables[8], types_tables[9]]
other_assets = {}
for table in other_types_tables:
    name, assets = get_assets_of_type(table)
    category = types[name]
    other_assets[category] = assets
other_assets

# gas table is in a different format, so it needs special code
gas_types = {
    'Simple Cycle': 'gas_simple',
    'Cogeneration': 'gas_cogeneration',
    'Combined Cycle': 'gas_combined',
    'Gas Fired Steam': 'gas_steam'
}
gas_table = types_tables[0]
subtitle_rows = gas_table.findAll("center")
subtitle_rows
subtitles = list(map(lambda row: row.text, subtitle_rows[1:]))
gas_assets = {}
# loop through subtitles to find assets of that type, and stop when we reach the next subtitle
for i in range(len(subtitles)):
    subtitle = subtitles[i]
    next_subtitle = subtitles[i+1] if i < 3 else None
    subtitle_category = gas_types[subtitle] # the string we want to save in our data for asset type
    row = gas_table.find("tr", string=subtitle)
    gas_assets[subtitle_category] = []
    # loops through each row starting from this subtitle
    for sibling in row.next_siblings:
        if (sibling != '\n'): # \n is new line in file - just skip these
            if (sibling.text == next_subtitle):
                break # stop looking when we hit the next subtitle
            elif ('(' in sibling.text):
                gas_assets[subtitle_category].append(get_row_asset_id(sibling))
gas_assets

all_assets = {**gas_assets, **other_assets}
all_assets


# save assets and types to a csv
import csv
with open('./data/asset_list_from_html.csv', 'w') as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(['type', 'asset'])
    for asset_type in all_assets.keys():
        for asset in all_assets[asset_type]:
            writer.writerow([asset_type, asset])