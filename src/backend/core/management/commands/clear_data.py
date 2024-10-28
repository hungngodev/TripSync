from django.core.management.base import BaseCommand
from core.models import Activity, Calendar, ChosenActivity, Traveller

class Command(BaseCommand):
    help = 'Clear all data from the database'

    def handle(self, *args, **kwargs):
        # Clear all data from each model
        Activity.objects.all().delete()
        Calendar.objects.all().delete()
        ChosenActivity.objects.all().delete()
        Traveller.objects.all().delete()
        
        self.stdout.write(self.style.SUCCESS('Successfully cleared all data from the database'))
