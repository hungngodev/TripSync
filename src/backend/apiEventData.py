import os
from serpapi import GoogleSearch
import flask
from flask_restful import Resource, Api
import us

def expand_state_name(location):
    """
    Converts a string in the format 'city, state_abbreviation' to 'city, full_state_name'.
    
    Args:
        location (str): A string in the format 'city, state_abbreviation'.
        
    Returns:
        str: A string in the format 'city, full_state_name'.
    """
    try:
        city, state_abbr = location.split(", ")
        state = us.states.lookup(state_abbr)
        if state:
            return f"{city}, {state.name}"
        else:
            raise ValueError("Invalid state abbreviation")
    except Exception as e:
        return f"Error: {e}"
    
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
  event_results = results["events_results"]
  id = 100
  for key in event_results:
    key["id"] = id
    key["location"] = expand_state_name(key["address"][1])
    key["address"] = key["address"][0]
    key["category"] = "entertainment"
    key["source_link"] = key["link"]
    id+=1
  return event_results


api.add_resource(Events, '/')

if __name__ == '__main__':
    apiEventData.run(debug=True, host='0.0.0.0', port=8080)


