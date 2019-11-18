import codecademylib
import pandas as pd

ad_clicks = pd.read_csv('ad_clicks.csv')
print(ad_clicks.head(10))
highutm=ad_clicks.groupby('utm_source').user_id.count().reset_index()
#print(highutm)

ad_clicks['is_click']=~ad_clicks\
.ad_click_timestamp.isnull()

clicks_by_source=ad_clicks.groupby(['utm_source','is_click']).user_id.count().reset_index()

clicks_pivot=clicks_by_source.pivot(
columns='is_click',
index='utm_source',
values='user_id' ).reset_index()
print(clicks_pivot)

clicks_pivot['percent_clicked']=clicks_pivot[True] / (clicks_pivot[True]+clicks_pivot[False])

print(clicks_pivot)

#Analyzing an A/B Test
abtest=ad_clicks.groupby('experimental_group').user_id.count().reset_index()
print(abtest)
