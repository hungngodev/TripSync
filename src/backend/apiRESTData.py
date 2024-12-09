import os
import requests
from flask import Flask, jsonify, request
from flask_restful import Api, Resource

apiRESTData = Flask(__name__)
api = Api(apiRESTData)

YELP_API_KEY = os.environ.get('YELP_API_KEY')
YELP_API_URL = "https://api.yelp.com/v3/businesses/search"

class Restaurants(Resource):
    def get(self):
        # Get city from query parameters, default to "Amherst"
        city = request.args.get('city', 'Amherst')
        term = request.args.get('term', 'restaurants')
        headers = {
            "Authorization": f"Bearer {YELP_API_KEY}"
        }
        params = {
            "location": city,
            "term": term,
            "limit": 20
        }

        response = requests.get(YELP_API_URL, headers=headers, params=params)

        if response.status_code == 200:
            data = response.json()
            # Extract relevant information
            businesses = []
            for business in data.get('businesses', []):
                businesses.append({
                    "id": 100, 
                    # fake data entries 100
                    "address": " ".join(business['location'].get('display_address', [])),
                    "category": "restaurant",
                    "description": business.get('name') + business.get('rating'),
                    "source_link": business.get('url')
                })
                id+=1
            return jsonify(businesses)
        else:
            return {"error": response.json()}, response.status_code


api.add_resource(Restaurants, '/')

if __name__ == '__main__':
    apiRESTData.run(debug=True, host='0.0.0.0', port=8080)
