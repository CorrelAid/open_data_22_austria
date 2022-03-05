
from calendar import c
import pandas as pd

DROP_COLS = ["SUB_DISTRICT_CODE", "INCOME_MEN", "INCOME_WOMEN", "INCOME_TOTAL", "REF_DATE"]
income = pd.read_csv("data/raw/vie_502.csv", sep=";")
income = income.query("REF_DATE == 20181231")
income.drop([f"NUTS{x+1}" for x in range(3)] + DROP_COLS, axis=1, inplace=True)
income.rename(columns = {"DISTRICT_CODE": "bezirk"}, inplace=True)  
income.bezirk = income.bezirk.apply(lambda x: int(str(x)[1:3]))

income.columns = income.columns.str.lower()
income.columns = income.columns.str.replace('average', 'avg')
print(income)

for col in income.columns:
    income[col].astype(int)

income.to_csv("data/income.csv", index=False)