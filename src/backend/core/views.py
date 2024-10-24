from django.shortcuts import render

# Create your views here.
from rest_framework import viewsets
from .models import Traveller, Activity, Calendar, ChosenActivity
from .serializers import TravellerSerializer, ActivitySerializer, CalendarSerializer, ChosenActivitySerializer

class TravellerViewSet(viewsets.ModelViewSet):
    queryset = Traveller.objects.all()
    serializer_class = TravellerSerializer


class ActivityViewSet(viewsets.ModelViewSet):
    queryset = Activity.objects.all()
    serializer_class = ActivitySerializer


class CalendarViewSet(viewsets.ModelViewSet):
    queryset = Calendar.objects.all()
    serializer_class = CalendarSerializer


class ChosenActivityViewSet(viewsets.ModelViewSet):
    queryset = ChosenActivity.objects.all()
    serializer_class = ChosenActivitySerializer
    
    def get_all_chosen_activities_of_traveller(self, traveller_id):
        return self.queryset.filter(user_id=traveller_id)

    def get_all_chosen_activities_of_calendar(self, calendar_id):
        return self.queryset.filter(calendar_id=calendar_id)
