from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import viewsets
from .models import Traveller, Activity, Calendar, ChosenActivity
from .serializers import TravellerSerializer, ActivitySerializer, CalendarSerializer, ChosenActivitySerializer

class TravellerViewSet(viewsets.ModelViewSet):
    queryset = Traveller.objects.all()
    serializer_class = TravellerSerializer

    def list(self, request):
        travellers = self.queryset
        serializer = self.get_serializer(travellers, many=True)
        return Response(serializer.data)

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            traveller = serializer.save()
            return Response(self.get_serializer(traveller).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        traveller = self.get_object()
        serializer = self.get_serializer(traveller)
        return Response(serializer.data)

    def update(self, request, pk=None):
        traveller = self.get_object()
        serializer = self.get_serializer(traveller, data=request.data)
        if serializer.is_valid():
            updated_traveller = serializer.save()
            return Response(self.get_serializer(updated_traveller).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def partial_update(self, request, pk=None):
        traveller = self.get_object()
        serializer = self.get_serializer(traveller, data=request.data, partial=True)
        if serializer.is_valid():
            updated_traveller = serializer.save()
            return Response(self.get_serializer(updated_traveller).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        traveller = self.get_object()
        traveller.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)



class ActivityViewSet(viewsets.ModelViewSet):
    serializer_class = ActivitySerializer
    queryset = Activity.objects.all()

    def get_queryset(self):
        queryset = Activity.objects.all()
        category = self.request.query_params.get('category', None)
        location = self.request.query_params.get('location', None)

        if category:
            queryset = queryset.filter(category__iexact=category)  # Case-insensitive match
        if location:
            queryset = queryset.filter(location__iexact=location)  # Case-insensitive match

        return queryset

    def list(self, request):
        activities = self.get_queryset()
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            activity = serializer.save()
            return Response(self.get_serializer(activity).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        activity = self.get_object()
        serializer = self.get_serializer(activity)
        return Response(serializer.data)

    def update(self, request, pk=None):
        activity = self.get_object()
        serializer = self.get_serializer(activity, data=request.data)
        if serializer.is_valid():
            updated_activity = serializer.save()
            return Response(self.get_serializer(updated_activity).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def partial_update(self, request, pk=None):
        activity = self.get_object()
        serializer = self.get_serializer(activity, data=request.data, partial=True)
        if serializer.is_valid():
            updated_activity = serializer.save()
            return Response(self.get_serializer(updated_activity).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        activity = self.get_object()
        activity.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


class CalendarViewSet(viewsets.ModelViewSet):
    queryset = Calendar.objects.all()
    serializer_class = CalendarSerializer
    
    def list(self, request):
        calendars = self.queryset
        serializer = self.get_serializer(calendars, many=True)
        return Response(serializer.data)

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            calendar = serializer.save()
            return Response(self.get_serializer(calendar).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        calendar = self.get_object()
        serializer = self.get_serializer(calendar)
        return Response(serializer.data)

    def update(self, request, pk=None):
        calendar = self.get_object()
        serializer = self.get_serializer(calendar, data=request.data)
        if serializer.is_valid():
            updated_calendar = serializer.save()
            return Response(self.get_serializer(updated_calendar).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def partial_update(self, request, pk=None):
        calendar = self.get_object()
        serializer = self.get_serializer(calendar, data=request.data, partial=True)
        if serializer.is_valid():
            updated_calendar = serializer.save()
            return Response(self.get_serializer(updated_calendar).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        calendar = self.get_object()
        calendar.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
class ChosenActivityViewSet(viewsets.ModelViewSet):
    queryset = ChosenActivity.objects.all()
    serializer_class = ChosenActivitySerializer
    
    def list(self, request):
        chosen_activities = self.queryset
        serializer = self.get_serializer(chosen_activities, many=True)
        return Response(serializer.data)

    def create(self, request):
        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            chosen_activity = serializer.save()
            return Response(self.get_serializer(chosen_activity).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        chosen_activity = self.get_object()
        serializer = self.get_serializer(chosen_activity)
        return Response(serializer.data)

    def update(self, request, pk=None):
        chosen_activity = self.get_object()
        serializer = self.get_serializer(chosen_activity, data=request.data)
        if serializer.is_valid():
            updated_chosen_activity = serializer.save()
            return Response(self.get_serializer(updated_chosen_activity).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def partial_update(self, request, pk=None):
        chosen_activity = self.get_object()
        serializer = self.get_serializer(chosen_activity, data=request.data, partial=True)
        if serializer.is_valid():
            updated_chosen_activity = serializer.save()
            return Response(self.get_serializer(updated_chosen_activity).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        chosen_activity = self.get_object()
        chosen_activity.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

    def get_all_chosen_activities_of_traveller(self, traveller_id):
        return self.queryset.filter(user_id=traveller_id)

    def get_all_chosen_activities_of_calendar(self, calendar_id):
        return self.queryset.filter(calendar_id=calendar_id)
    
    @action(detail=True, methods=['get'])
    def traveller(self, request, pk=None):
        activities = self.get_all_chosen_activities_of_traveller(pk)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['get'])
    def calendar(self, request, pk=None):
        activities = self.get_all_chosen_activities_of_calendar(pk)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)