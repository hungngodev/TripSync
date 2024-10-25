import json
from django.core.management.base import BaseCommand
from core.models import Activity
import random

class Command(BaseCommand):
    help = 'Load activities from JSON file'

    def handle(self, *args, **kwargs):
        # Update the path to point to your activities.json file
        file_path = 'core/data/activities.json'  # Change this if necessary

        try:
            with open(file_path) as f:
                activities = json.load(f)
                for activity in activities:
                    Activity.objects.create(
                        id=int(activity['id']) + random.randint(100, 1000),
                        location=activity['location'],
                        category=activity['category'],
                        description=activity['description'],
                        source_link=activity['sourceLink']
                    )
            self.stdout.write(self.style.SUCCESS('Successfully loaded activities'))
        except FileNotFoundError:
            self.stdout.write(self.style.ERROR(f'File not found: {file_path}'))
        except json.JSONDecodeError:
            self.stdout.write(self.style.ERROR('Failed to decode JSON. Please check the file format.'))
        except Exception as e:
            self.stdout.write(self.style.ERROR(f'An error occurred: {str(e)}'))
