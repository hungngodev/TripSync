from serpapi import GoogleSearch

params = {
  "engine": "google_events",
  "q": "Entertainment Events in Austin",
  "hl": "en",
  "gl": "us",
  "api_key": "965609997e653a55296b04938f2768cb20c5256a118cf45696ffb5d9771b4319"
}

search = GoogleSearch(params)
results = search.get_dict()
events_results = results["events_results"]
print(events_results)