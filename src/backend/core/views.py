from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import viewsets
from .models import  Activity, Calendar, ChosenActivity
from .serializers import  ActivitySerializer, CalendarSerializer, ChosenActivitySerializer
from rest_framework import status
from rest_framework.permissions import IsAdminUser
from rest_framework.views import APIView
from .serializers import UserSerializer
from rest_framework.response import Response
from rest_framework.permissions import IsAdminUser
from django.contrib.auth.models import User
from rest_framework.authtoken.views import ObtainAuthToken
from rest_framework.permissions import IsAuthenticated
from rest_framework.authtoken.models import Token

class CustomAuthToken(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        print("Getting the user serializable in custom auth token")
        
        # Create or get the token for the user
        token, created = Token.objects.get_or_create(user=user)
        
        # Return token and user ID
        return Response({
            'token': token.key,
            'id': user.id,
            'username': user.username,  # Optional: return additional user info
        }, status=status.HTTP_200_OK)

class UserRecordView(APIView):
    """
    API View to create or get a list of all the registered
    users. GET request returns the registered users whereas
    a POST request allows to create a new user.
    """
    # permission_classes = [IsAdminUser]
    def get(self, request, user_id=None, format=None):
        if user_id is not None:
            # Fetch a single user if user_id is provided
            try:
                user = User.objects.get(pk=user_id)
                serializer = UserSerializer(user)
                return Response(serializer.data)
            except User.DoesNotExist:
                return Response(
                    {"error": "User not found"},
                    status=status.HTTP_404_NOT_FOUND
                )
        else:
            # Fetch all users if no user_id is provided
            users = User.objects.all()
            serializer = UserSerializer(users, many=True)
            return Response(serializer.data)

    def post(self, request):
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid(raise_exception=True):
            user = serializer.create(validated_data=serializer.validated_data)
            response_data = UserSerializer(user).data
            return Response(
                response_data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            {
                "error": True,
                "error_msg": serializer.errors,
            },
            status=status.HTTP_400_BAD_REQUEST
        )
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
    permission_classes = [IsAuthenticated] 
    
    
    def list(self, request):
        chosen_activities = self.queryset
        serializer = self.get_serializer(chosen_activities, many=True)
        return Response(serializer.data)

    def create(self, request):
        adding = {
            'user': request.user.id,
            'activity': request.data['activity']
        }
        serializer = self.get_serializer(data=adding)
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
    
    @action(detail=False, methods=['post'])
    def bulk_create(self, request):
        print("Bulk create chosen activities")
        # Assuming the request body will contain a list of chosen activities
        activities_data = request.data
        user = request.user
        activities_data = [
    {
        "activity": 1,  # Assume activity ID 1 exists
        "calendar": 2,  # Assume calendar ID 2 exists
        "user": 3,      # Assume user ID 3 exists
        "start_date": "2024-12-01",  # Example start date
        "end_date": "2024-12-07"     # Example end date
    },
    {
        "activity": 2,  # Assume activity ID 2 exists
        "calendar": 1,  # Assume calendar ID 1 exists
        "user": 4,      # Assume user ID 4 exists
        "start_date": "2024-12-05",
        "end_date": "2024-12-10"
    }
]
        print(activities_data)
        serializer = ChosenActivitySerializer(data=activities_data, many=True)
        if serializer.is_valid():
            # Save all the chosen activities in bulk
            print("Saving all the chosen activities in bulk")
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)