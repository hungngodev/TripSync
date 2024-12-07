from serpapi import GoogleSearch
import os

params = {
  "engine": "google_hotels",
  "q": "Amherst Hotels",
  "check_in_date": "2024-12-08",
  "check_out_date": "2024-12-09",
  "adults": "2",
  "currency": "USD",
  "gl": "us",
  "hl": "en",
  "api_key": os.environ.get('API_KEY')
}

search = GoogleSearch(params)
results = search.get_dict()