import pandas as pd

# now we will merge all the csvs together and calculate some new column values

historical = pd.read_csv("./data/data_cleaned.csv")
new = pd.read_csv("./data/2022_data.csv")
asset_types = pd.read_csv("./data/asset_list_from_html.csv")

new
historical
asset_types

# prep for merge: we want to merge on the assets that are in both tables
historical_assets = [c for c in historical.columns if c != 'Date_Begin_Local']
new_assets = [c for c in new.columns if c != 'Datetime']
shared_assets = [c for c in new_assets if c in historical_assets]
all_assets = list(set(historical_assets) | set(new_assets))
all_assets

# outer join the 2 tables & clean data
merged = pd.merge(left=historical, right=new, left_on=['Date_Begin_Local', *shared_assets], right_on=['Datetime', *shared_assets], how='outer')
merged = merged.fillna(0)


# fix date column from join
def get_date(row):
    if row['Date_Begin_Local'] != 0:
        return row['Date_Begin_Local']
    return row['Datetime']

merged['date'] = merged.apply(get_date, axis=1)
merged['date'] = pd.to_datetime(merged['date'])
merged['date']


# add new columns for total by asset type!
from functools import reduce
def calculate_total(asset_names):
    return reduce(lambda total, asset: total + merged[asset] if asset in merged.columns else total, asset_names, 0)

merged['total_all'] = calculate_total(all_assets)
merged['total_all']

hydro_assets = list(asset_types[asset_types['type'] == 'hydro']['asset'])
merged['hydro_total'] = calculate_total(hydro_assets)

wind_assets = list(asset_types[asset_types['type'] == 'wind']['asset'])
merged['wind_total'] = calculate_total(wind_assets)

solar_assets = list(asset_types[asset_types['type'] == 'solar']['asset'])
merged['solar_total'] = calculate_total(solar_assets)

biomass_assets = list(asset_types[asset_types['type'] == 'biomass_other']['asset'])
merged['biomass_other_total'] = calculate_total(biomass_assets)

dual_fuel_assets = list(asset_types[asset_types['type'] == 'dual_fuel']['asset'])
merged['dual_fuel_total'] = calculate_total(dual_fuel_assets)

gas_simple_assets = list(asset_types[asset_types['type'] == 'gas_simple']['asset'])
merged['gas_simple_total'] = calculate_total(gas_simple_assets)

gas_cogeneration_assets = list(asset_types[asset_types['type'] == 'gas_cogeneration']['asset'])
merged['gas_cogeneration_total'] = calculate_total(gas_cogeneration_assets)

gas_combined_cycle_assets = list(asset_types[asset_types['type'] == 'gas_combined']['asset'])
merged['gas_combined_total'] = calculate_total(gas_combined_cycle_assets)

gas_steam_assets = list(asset_types[asset_types['type'] == 'gas_steam']['asset'])
merged['gas_steam_total'] = calculate_total(gas_steam_assets)

merged['total_all_gas'] = merged['gas_simple_total'] + merged['gas_cogeneration_total'] + merged['gas_cogeneration_total'] + merged['gas_combined_total'] + merged['gas_steam_total']

merged['total_all_renewables'] = merged['hydro_total'] + merged['wind_total'] + merged['solar_total']


merged

smaller_dataset = merged[['date','total_all','hydro_total','wind_total','solar_total','biomass_other_total','dual_fuel_total','gas_simple_total','gas_cogeneration_total','gas_combined_total','gas_steam_total','total_all_gas','total_all_renewables']]

# export csv
smaller_dataset.to_csv("./data/final_totals_data.csv", index=False)