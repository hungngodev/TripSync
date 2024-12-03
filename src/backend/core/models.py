from django.db import models
from django.contrib.auth import get_user_model
from datetime import datetime
from django.core.exceptions import ObjectDoesNotExist

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


class ChosenActivityManager(models.Manager):
    def get_activities_of_traveller(self, user_id):
        return self.filter(user_id=user_id, calendar_id=None).select_related('activity')

    def get_activities_of_calendar(self, user_id, calendar_id):
        return self.filter(
            user_id=user_id, start_date__isnull=False, calendar_id=calendar_id
        ).select_related('activity')

    def get_activities_of_calendar_today(self, user_id):
        return self.filter(
            user_id=user_id,
            start_date__isnull=False,
            calendar_id__isnull=False,
            start_date__date=datetime.now().date(),
        ).select_related('activity')


class ChosenActivity(models.Model):
    objects = ChosenActivityManager()
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

class FriendsManager(models.Manager):
    def get_friends(self, user):
        """Retrieve all approved friends of a user."""
        return self.filter(user=user, status=True).values_list('friend', flat=True)

    def are_friends(self, user1, user2):
        """Check if two users are friends."""
        return self.filter(
            models.Q(user=user1, friend=user2) | models.Q(user=user2, friend=user1),
            status=True
        ).exists()
    def are_send_request(self, user1, user2):
        """Check if user1 send friend request to user2."""
        return self.filter(
            models.Q(user=user1, friend=user2),
            status=False
        ).exists()
    
    def are_receive_request(self, user1, user2):
        """Check if user1 receive friend request from user2."""
        return self.filter(
            models.Q(user=user2, friend=user1),
            status=False
        ).exists()
    
    def get_pending_requests(self, user):
        """Retrieve all pending friend requests for a user."""
        return self.filter(friend=user, status=False)

    def send_request(self, user, friend):
        """Send a friend request."""
        if not self.are_friends(user, friend):
            return self.get_or_create(user=user, friend=friend, defaults={'status': False})

    def accept_request(self, user, friend):
        """Accept a friend request."""
        try:
            request = self.get(user=friend, friend=user, status=False)
            request.status = True
            request.save()
            return request
        except self.model.DoesNotExist:
            return None

    def remove_friend(self, user, friend):
        """Remove a friend connection."""
        self.filter(
            models.Q(user=user, friend=friend) | models.Q(user=friend, friend=user)
        ).delete()

    def mutual_friends_count(self, user1, user2):
        """Get the count of mutual friends between two users."""
        friends_user1 = set(self.get_friends(user1))
        friends_user2 = set(self.get_friends(user2))
        mutual_friends = friends_user1.intersection(friends_user2)
        return len(mutual_friends)

    
    def get_friendship_id(self, user1, user2):
        """
        Retrieve the friendship ID between two users if it exists.
        """
        try:
            friendship = self.filter(
                user=user1, friend=user2
            ).union(
                self.filter(user=user2, friend=user1)
            ).first()
            return friendship.id if friendship else None
        except ObjectDoesNotExist:
            return None
class Friend(models.Model):
    user = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, related_name='user')
    friend = models.ForeignKey(get_user_model(), on_delete=models.CASCADE, related_name='friend')
    status = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)
    objects = FriendsManager()
    def __str__(self):
        return self.user.username + ' - ' + self.friend.username