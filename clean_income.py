
import pandas as pd

income = pd.read_csv("data/vie_502.csv", sep=";")
print(income)
income = income.query("REF_DATE == 20181231")
income.DISTRICT_CODE.str.replace("")
print(income)
