import requests
from requests.structures import CaseInsensitiveDict
params = {
  "lat": "-8.830670999999999",
  "lon": "115.21533099999999",
  "apiKey": "8327fef3815948aaa747382b8375c64b"
}

url = "https://api.geoapify.com/v1/geocode/reverse"

headers = CaseInsensitiveDict()
headers["Accept"] = "application/json"

resp = requests.get(url, headers=headers, params=params)

print(resp.status_code)
print(resp.text)