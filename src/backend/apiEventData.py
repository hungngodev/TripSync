import os
from serpapi import GoogleSearch
import us
from dotenv import load_dotenv
load_dotenv()

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
    

def get( city = "Amherst"):
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

print(get("Amherst"))   