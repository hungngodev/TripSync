import os
from serpapi import GoogleSearch
import flask
from flask_restful import Resource, Api
from datetime import datetime, timedelta

apiHotelData = flask.Flask(__name__)
api = Api(apiHotelData)

class Hotels(Resource):
 def get(self, city = "Amherst"):
  params = {
  "engine": "google_hotels",
  "q": city + " Hotels",
  "check_in_date": datetime.today(),
  "check_out_date": datetime.now() + timedelta(1),
  "currency": "USD",
  "gl": "us",
  "hl": "en",
  "api_key": os.environ.get('API_KEY')
  }
  search = GoogleSearch(params)
  hotel_results = search.get_dict()["properties"]
  id = 100
  for key in hotel_results:
    key["id"] = id
    key["location"] = city
    key["address"] = city
    key["category"] = "hotel"
    key["source_link"] = key["link"]
    id+=1
  return hotel_results


api.add_resource(Hotels, '/')

if __name__ == '__main__':
    apiHotelData.run(debug=True, host='0.0.0.0', port=8080)
