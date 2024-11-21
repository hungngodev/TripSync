from rest_framework import serializers
from .models import Activity, Calendar, ChosenActivity
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
        return representation