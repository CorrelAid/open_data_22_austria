
import matplotlib.pyplot as plt
import seaborn as sns
import pandas as pd

income = pd.read_csv("data/income/income.csv", sep=",")
income = income[["bezirk", 'avg_income_fulltime_total', 'avg_income_fulltime_men',
       'avg_income_fulltime_women']]

income = income[["bezirk", 'avg_income_fulltime_total']]

income.plot.bar(x="bezirk")
plt.savefig("income_bar.png")

income.groupby(['bezirk']).sum().plot(kind='pie', y='avg_income_fulltime_total')
plt.savefig("income_pie.png")

dogs = pd.read_csv("data/hunde/hundebeutel_pro_bezirk.csv", sep=",")
mdf = dogs.merge(income)

sns.lmplot(x="summe_beutel_bezirk", y="avg_income_fulltime_total",data=mdf,fit_reg=True) 
# mdf.plot.scatter(x="summe_beutel_bezirk", y="avg_income_fulltime_total", c="DarkBlue")
plt.savefig("hundebeutel_income.png")
print(mdf)