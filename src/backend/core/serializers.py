from rest_framework import serializers
from .models import Traveller, Activity, Calendar, ChosenActivity

class TravellerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Traveller
        fields = ['id', 'username', 'password']

class ActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = Activity
        fields = ['id', 'location', 'category', 'description', 'source_link']

class CalendarSerializer(serializers.ModelSerializer):
    class Meta:
        model = Calendar
        fields = ['id', 'user', 'name']

class ChosenActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = ChosenActivity
        fields = ['id', 'activity', 'calendar', 'user', 'start_date', 'end_date']
