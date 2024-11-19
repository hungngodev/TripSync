from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from rest_framework.authtoken.models import Token
from core.models import Activity, Calendar, ChosenActivity, Traveller

class Command(BaseCommand):
    help = 'Clear all data from the database, including user tokens'

    def handle(self, *args, **kwargs):
        # Clear all data from each model
        Activity.objects.all().delete()
        Calendar.objects.all().delete()
        ChosenActivity.objects.all().delete()
        
        # Clear all users and their tokens
        User = get_user_model()
        users = User.objects.all()

        # Delete all user tokens
        Token.objects.all().delete()

        # Delete all users
        users.delete()

        self.stdout.write(self.style.SUCCESS('Successfully cleared all data from the database'))
