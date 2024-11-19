from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from core.models import Activity, Calendar, ChosenActivity
from datetime import date, timedelta
import json

class Command(BaseCommand):
    help = 'Populate the database with fake data'

    def handle(self, *args, **kwargs):
        # Clear existing data
        Activity.objects.all().delete()
        Calendar.objects.all().delete()
        ChosenActivity.objects.all().delete()

        # Fake Data for Users
        User = get_user_model()
        users_data = [
            {
                'username': 'john_doe',
                'password': 'password123',
                'email': 'john@example.com',
                'first_name': 'John',
                'last_name': 'Doe',
                'is_active': True,
                'is_staff': False
            },
            {
                'username': 'jane_smith',
                'password': 'password123',
                'email': 'jane@example.com',
                'first_name': 'Jane',
                'last_name': 'Smith',
                'is_active': True,
                'is_staff': False
            },
            {
                'username': 'admin_user',
                'password': 'adminpass',
                'email': 'admin@example.com',
                'first_name': 'Admin',
                'last_name': 'User',
                'is_active': True,
                'is_staff': True,
                'is_superuser': True
            }
        ]

        for user_data in users_data:
            user = User(**user_data)
            user.set_password(user_data['password'])  # Set the password correctly
            user.save()

        # Fake Data for Activities
        activities_data = [
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

        for activity in activities_data:
            Activity.objects.create(**activity)

        # Fake Data for Calendars
        calendars_data = [
            {"user": User.objects.get(username="john_doe"), "name": "Summer Vacation"},
            {"user": User.objects.get(username="jane_smith"), "name": "Winter Getaway"},
        ]

        for calendar_data in calendars_data:
            Calendar.objects.create(**calendar_data)

        file_path = 'core/data/activities.json'  # Change this if necessary

        # Load activities from JSON file
        try:
            with open(file_path) as f:
                activities_from_file = json.load(f)
                for activity in activities_from_file:
                    Activity.objects.create(
                        location=activity['location'],
                        category=activity['category'],
                        description=activity['description'],
                        source_link=activity['sourceLink']
                    )
            self.stdout.write(self.style.SUCCESS('Successfully loaded activities from JSON file'))
        except FileNotFoundError:
            self.stdout.write(self.style.ERROR(f'File not found: {file_path}'))
        except json.JSONDecodeError:
            self.stdout.write(self.style.ERROR('Failed to decode JSON. Please check the file format.'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'An error occurred: {str(e)}'))

        # Fake Data for ChosenActivities
        chosen_activities_data = [
            {
                "activity": Activity.objects.get(location="Grand Canyon"),
                "calendar": Calendar.objects.get(name="Summer Vacation"),
                "user": User.objects.get(username="john_doe"),
                "start_date": date.today(),
                "end_date": date.today() + timedelta(days=2),
            },
            {
                "activity": Activity.objects.get(location="Le Gourmet"),
                "calendar": Calendar.objects.get(name="Winter Getaway"),
                "user": User.objects.get(username="jane_smith"),
                "start_date": date.today(),
                "end_date": date.today() + timedelta(days=1),
            },
        ]

        for chosen_activity_data in chosen_activities_data:
            ChosenActivity.objects.create(**chosen_activity_data)

        self.stdout.write(self.style.SUCCESS('Successfully populated the database with fake data.'))
