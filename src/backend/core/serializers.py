from rest_framework import serializers
from .models import Traveller, Activity, Calendar, ChosenActivity

from rest_framework import serializers
from .models import Traveller  # Use your custom model

class TravellerSerializer(serializers.ModelSerializer):
    def create(self, validated_data):
        user = Traveller.objects.create_user(**validated_data)
        return user

    class Meta:
        model = Traveller
        fields = (
            'username',
            'first_name',
            'last_name',
            'email',
            'password',
        )
        extra_kwargs = {'password': {'write_only': True}}
        validators = [
            serializers.UniqueTogetherValidator(
                queryset=Traveller.objects.all(),
                fields=['username', 'email']
            )
        ]


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
