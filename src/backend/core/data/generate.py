from faker import Faker
import random
import json

fake = Faker()
categories = ['hotel', 'restaurant', 'entertainments']
states_towns = [
    ("California", "Los Angeles"),
    ("Colorado", "Aspen"),
    ("Texas", "Austin"),
    ("New York", "Manhattan"),
    ("Florida", "Miami"),
    ("Arizona", "Phoenix"),
    ("Illinois", "Chicago"),
    ("Washington", "Seattle"),
    ("Nevada", "Las Vegas"),
    ("Vermont", "Burlington"),
    ("Boston", "Massachusetts"),
    ("Atlanta", "Georgia"),
    ("Amherst", "Massachusetts"),
        ("Boston", "Massachusetts"),
    ("Cambridge", "Massachusetts"),
    ("Worcester", "Massachusetts"),
    ("Springfield", "Massachusetts"),
    ("Lowell", "Massachusetts"),
    ("Brockton", "Massachusetts"),
    ("Quincy", "Massachusetts"),
    ("Newton", "Massachusetts"),
    ("Lynn", "Massachusetts"),
    ("Somerville", "Massachusetts"),
        ("Framingham", "Massachusetts"),
    ("Peabody", "Massachusetts"),
    ("Revere", "Massachusetts"),
    ("Malden", "Massachusetts"),
    ("Taunton", "Massachusetts"),
    ("Chelsea", "Massachusetts"),
    ("Pittsfield", "Massachusetts"),
    ("Medford", "Massachusetts"),
    ("Weymouth", "Massachusetts"),
    ("Haverhill", "Massachusetts"),
      ("Marlborough", "Massachusetts"),
    ("Malden", "Massachusetts"),
    ("Beverly", "Massachusetts"),
    ("Fitchburg", "Massachusetts"),
    ("Danvers", "Massachusetts"),
    ("Northampton", "Massachusetts"),
    ("Westfield", "Massachusetts"),
    ("Westborough", "Massachusetts"),
    ("Andover", "Massachusetts"),
    ("Framingham", "Massachusetts")
]

data = []

for _ in range(1000):  # Generate 100 entries
    state, town = random.choice(states_towns)
    data.append({
        'id': _,
        "address": fake.address(),
        "title": fake.company(),
        "location": f"{state}, {town}",
        "category": random.choice(categories),
        "description": fake.text(max_nb_chars=200),
        "source_link": fake.url()
    })

# Save to JSON
with open('activities.json', 'w') as f:
    json.dump(data, f, indent=4)

print("Generated activities.json")
