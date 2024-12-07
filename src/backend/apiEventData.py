import os
from serpapi import GoogleSearch
import flask
from flask_restful import Resource, Api

apiEventData = flask.Flask(__name__)
api = Api(apiEventData)

class Events(Resource):
 def get(self, city = "Amherst"):
  params = {
  "engine": "google_events",
  "q": "Events in "+ city,
  "hl": "en",
  "gl": "us",
  "api_key": os.environ.get('API_KEY')
  }
  search = GoogleSearch(params)
  results = search.get_dict()
  return results["events_results"]

api.add_resource(Events, '/')

if __name__ == '__main__':
    apiEventData.run(debug=True, host='0.0.0.0', port=8080)


