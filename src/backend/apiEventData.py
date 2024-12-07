import os
from serpapi import GoogleSearch

params = {
  "engine": "google_events",
  "q": "Events in Amherst",
  "hl": "en",
  "gl": "us",
  "api_key": os.environ.get('API_KEY')
}

search = GoogleSearch(params)
results = search.get_dict()
events_results = results["events_results"]

