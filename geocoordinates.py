import pandas as pd
from geopy.geocoders import Nominatim
import geocoder
import csv


mydata = pd.read_csv('UnderageCitations.csv')

mydata = mydata.rename(columns = {"Ticket.Address" :"Location"})


locations = mydata['Location'].apply(str)

locations = locations + ", Berkeley" + ", CA"

csvfileobj = open("underage_coordinates.csv" , "w")
writer = csv.writer(csvfileobj)
lat = []
lng = []
writer.writerow(["Latitude" , "Longitude"])
for location in locations:
			geocode = geocoder.google(location)
			lat.append(geocode.lat)
			lng.append(geocode.lng)


rows = zip(lat , lng)

for row in rows:
	writer.writerow(row)

csvfileobj.close()