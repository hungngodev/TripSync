from django.db import models
from django.contrib.auth import get_user_model

class Activity(models.Model):
    CATEGORY_CHOICES = [
        ('hotel', 'Hotel'),
        ('restaurant', 'Restaurant'),
        ('entertainments', 'Entertainment'),
    ]
    address = models.CharField(max_length=255, null =  True)    
    title = models.CharField(max_length=255, null = True)
    location = models.CharField(max_length=255)
    category = models.CharField(max_length=50, choices=CATEGORY_CHOICES)
    description = models.TextField()
    source_link = models.URLField()

class Calendar(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, null=True)  # Reference to Traveller model
    name = models.CharField(max_length=255)
    start_date = models.DateField(null = True)
    end_date = models.DateField(null = True)
    created_at = models.DateTimeField(auto_now_add=True)

class ChosenActivity(models.Model):
    activity = models.ForeignKey(Activity, on_delete=models.CASCADE, null=False)
    calendar = models.ForeignKey(Calendar, on_delete=models.CASCADE, null=True)
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, null=False)  # Reference to Traveller model
    start_date = models.DateTimeField(null = True)
    end_date = models.DateTimeField(null = True) 
    title = models.CharField(max_length=255, null=True, blank = True)
    description = models.TextField(null = True, blank= True)
    location = models.CharField(max_length=255, null=True, blank = True)
    isAllDay = models.BooleanField(default=False)
    startTimeZone = models.CharField(max_length=255, null=True, blank = True)
    endTimeZone = models.CharField(max_length=255, null=True, blank = True)
    color = models.CharField(max_length=255, null=True, blank = True)
    
class Post(models.Model):
    title = models.CharField(max_length=100)
    content = models.TextField()
    image_url = models.URLField(null=True, blank=True)
    calendar = models.ForeignKey(Calendar, on_delete=models.CASCADE, null=True)
    date_posted = models.DateTimeField(auto_now_add=True)
    author = models.ForeignKey(get_user_model(), on_delete=models.CASCADE)
    created_at = models.DateTimeField(auto_now_add=True)
    likes = models.ManyToManyField(get_user_model(), related_name='post_likes', blank=True, default=None)
    
    def __str__(self):
        return self.title