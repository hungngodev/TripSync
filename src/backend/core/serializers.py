from rest_framework import serializers
from .models import Activity, Calendar, ChosenActivity, Post, Friend
from rest_framework import serializers
from django.contrib.auth.models import User
from rest_framework import serializers
from rest_framework.validators import UniqueTogetherValidator


class UserSerializer(serializers.ModelSerializer):

    def create(self, validated_data):
        user = User.objects.create_user(**validated_data)
        return user

    class Meta:
        model = User
        fields = '__all__'
        validators = [
            UniqueTogetherValidator(
                queryset=User.objects.all(),
                fields=['username', 'email']
            )
        ]

class ActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Activity
        fields = '__all__'

class CalendarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Calendar
        fields = '__all__'

class ChosenActivitySerializer(serializers.ModelSerializer):
    activity = serializers.PrimaryKeyRelatedField(queryset=Activity.objects.all())  
    calendar = serializers.PrimaryKeyRelatedField(queryset=Calendar.objects.all())
    class Meta:
        model = ChosenActivity
        fields = '__all__'
        
    def to_representation(self, instance):
        """
        Override the to_representation method to include the full activity details
        in the response (when sending data back to the frontend).
        """
        representation = super().to_representation(instance)
        # Serialize the related activity using ActivitySerializer
        representation['activity'] = ActivitySerializer(instance.activity).data
        representation['calendar'] = CalendarSerializer(instance.calendar).data
        return representation
    
class PostSerializer(serializers.ModelSerializer):
    author = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    calendar = serializers.PrimaryKeyRelatedField(queryset=Calendar.objects.all())
    
    class Meta:
        model = Post
        fields = '__all__'
        
    def get_likes_count(self, obj):
        return obj.likes.count()

    def get_is_liked_by_user(self, obj):
        user = self.context.get('request').user
        return user.is_authenticated and obj.likes.filter(id=user.id).exists()
    
    def is_belong_to_user(self, obj):
        user = self.context.get('request').user
        return user.is_authenticated and obj.author == user
    
    def to_representation(self, instance):
        """
        Override the to_representation method to include the full activity details
        in the response (when sending data back to the frontend).
        """
        representation = super().to_representation(instance)
        # Serialize the related activity using ActivitySerializer
        representation['calendar'] = CalendarSerializer(instance.calendar).data
        representation['author'] = UserSerializer(instance.author).data
        representation['likes_count'] = self.get_likes_count(instance)
        representation['is_liked_by_user'] = self.get_is_liked_by_user(instance)
        representation['is_belong_to_user'] = self.is_belong_to_user(instance)
        representation['events'] = ChosenActivitySerializer(ChosenActivity.objects.get_activities_of_calendar(instance.author.id, instance.calendar.id), many=True).data
        representation['is_friend'] = Friend.objects.are_friends(self.context.get('request').user, instance.author)
        representation['is_send_request'] = Friend.objects.are_send_request(self.context.get('request').user, instance.author)
        representation['is_receive_request'] = Friend.objects.are_receive_request(self.context.get('request').user, instance.author)
        representation['friendship_id'] = Friend.objects.get_friendship_id(self.context.get('request').user, instance.author)
        return representation
    
class FriendSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    friend = serializers.PrimaryKeyRelatedField(queryset=User.objects.all())
    class Meta:
        model = Friend
        fields = '__all__'
        
    def to_representation(self, instance):
        representation = super().to_representation(instance)
        representation['user'] = UserSerializer(instance.user).data
        representation['friend'] = UserSerializer(instance.friend).data
        representation['mutual_friends'] = Friend.objects.mutual_friends_count(instance.user, instance.friend)
        representation['others'] = self.context.get('request').user.id == instance.user.id
        return representation