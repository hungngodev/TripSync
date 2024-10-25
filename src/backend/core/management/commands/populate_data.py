from django.core.management.base import BaseCommand
from core.models import Traveller
from core.models import Activity, Calendar, ChosenActivity
from datetime import date, timedelta

class Command(BaseCommand):
    help = 'Populate the database with fake data'

    def handle(self, *args, **kwargs):
        # Fake Data for Travellers
        travellers = [
            {"username": "john_doe", "password": "password123"},
            {"username": "jane_smith", "password": "securePass!"},
            {"username": "mike_jones", "password": "myP@ssw0rd"},
        ]

        for traveller in travellers:
            t = Traveller(username=traveller['username'])
            t.set_password(traveller['password'])  # Hash the password
            t.save()

        # Fake Data for Activities
        activities = [
            {
                "location": "Grand Canyon",
                "category": "entertainment",
                "description": "A stunning natural wonder with breathtaking views.",
                "source_link": "https://www.nps.gov/grca/index.htm",
            },
            {
                "location": "The Ritz-Carlton",
                "category": "hotel",
                "description": "Luxury hotel with exceptional service and amenities.",
                "source_link": "https://www.ritzcarlton.com/en/hotels/usa/phoenix",
            },
            {
                "location": "Le Gourmet",
                "category": "restaurant",
                "description": "Fine dining restaurant with exquisite cuisine.",
                "source_link": "https://www.legourmet.com",
            },
        ]

        for activity in activities:
            a = Activity(
                location=activity['location'],
                category=activity['category'],
                description=activity['description'],
                source_link=activity['source_link'],
            )
            a.save()

        # Fake Data for Calendars
        calendars = [
            {"user": Traveller.objects.get(username="john_doe"), "name": "Summer Vacation"},
            {"user": Traveller.objects.get(username="jane_smith"), "name": "Winter Getaway"},
        ]

        for calendar in calendars:
            c = Calendar(user=calendar['user'], name=calendar['name'])
            c.save()

        # Fake Data for ChosenActivities
        chosen_activities = [
            {
                "activity": Activity.objects.get(location="Grand Canyon"),
                "calendar": Calendar.objects.get(name="Summer Vacation"),
                "user": Traveller.objects.get(username="john_doe"),
                "start_date": date.today(),
                "end_date": date.today() + timedelta(days=2),
            },
            {
                "activity": Activity.objects.get(location="Le Gourmet"),
                "calendar": Calendar.objects.get(name="Winter Getaway"),
                "user": Traveller.objects.get(username="jane_smith"),
                "start_date": date.today(),
                "end_date": date.today() + timedelta(days=1),
            },
        ]

        for chosen_activity in chosen_activities:
            ca = ChosenActivity(
                activity=chosen_activity['activity'],
                calendar=chosen_activity['calendar'],
                user=chosen_activity['user'],
                start_date=chosen_activity['start_date'],
                end_date=chosen_activity['end_date'],
            )
            ca.save()

        self.stdout.write(self.style.SUCCESS('Successfully populated the database with fake data.'))

