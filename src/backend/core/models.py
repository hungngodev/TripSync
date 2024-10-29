from django.db import models
from django.contrib.auth import get_user_model

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
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, null=True)  # Reference to Traveller model
    name = models.CharField(max_length=255)

class ChosenActivity(models.Model):
    activity = models.ForeignKey(Activity, on_delete=models.CASCADE, null=True)
    calendar = models.ForeignKey(Calendar, on_delete=models.CASCADE, null=True)
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, null=True)  # Reference to Traveller model
    start_date = models.DateField()
    end_date = models.DateField() 
