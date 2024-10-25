from django.db import models
from django.contrib.auth.hashers import make_password, check_password
# Create your models here.
from django.db import models

class Traveller(models.Model):
    username = models.CharField(max_length=150, unique=True)
    password = models.CharField(max_length=128)  # Store hashed passwords
    # Use Django's built-in user authentication for password handling
    
    def set_password(self, raw_password):
        self.password = make_password(raw_password)

    def check_password(self, raw_password):
        return check_password(raw_password, self.password)


class Activity(models.Model):
    CATEGORY_CHOICES = [
        ('hotel', 'Hotel'),
        ('restaurant', 'Restaurant'),
        ('entertainments', 'Entertainment'),
    ]
    location = models.CharField(max_length=255)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES)
    description = models.TextField()
    source_link = models.URLField()

    
class Calendar(models.Model):
    user = models.ForeignKey(Traveller, on_delete=models.CASCADE)
    name = models.CharField(max_length=255)


class ChosenActivity(models.Model):
    activity = models.ForeignKey(Activity, on_delete=models.CASCADE)
    calendar = models.ForeignKey(Calendar, on_delete=models.CASCADE)
    user = models.ForeignKey(Traveller, on_delete=models.CASCADE)
    start_date = models.DateField()
    end_date = models.DateField()
