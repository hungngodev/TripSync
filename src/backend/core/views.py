from rest_framework import viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework import viewsets
from .models import  Activity, Calendar, ChosenActivity, Post, Friend, InviteCalendar
from .serializers import  ActivitySerializer, CalendarSerializer, ChosenActivitySerializer, PostSerializer, FriendSerializer, InviteCalendarSerializer
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
from datetime import datetime
from rest_framework.exceptions import ValidationError
from django.contrib.auth.hashers import check_password

from django.db.models import Q
import random


class CustomAuthToken(ObtainAuthToken):
    def post(self, request, *args, **kwargs):
        print("Custom auth token", request.data)
        

        try:
            serializer = self.serializer_class(data=request.data)
            serializer.is_valid(raise_exception=True)
            user = serializer.validated_data['user']
        except ValidationError as e:
            print("Validation Error:", e.detail)
            return Response({"error": str(e.detail)}, status=status.HTTP_400_BAD_REQUEST)
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
        elif 'random' in request.query_params:
            # Fetch a random user ordered by mutual friends if 'random' query param is provided
            return self.get_random_user_by_mutual_friends(request)
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
        
    def put(self, request, user_id=None):
        # print("Request data:", request.data)
        if user_id is None:
            return Response(
                {"error": "User ID is required"},
                status=status.HTTP_400_BAD_REQUEST
            )

        try:
            user = User.objects.get(pk=user_id)
        except User.DoesNotExist:
            return Response(
                {"error": "User not found"},
                status=status.HTTP_404_NOT_FOUND
            )

        # Update user fields from request data
        user.username = request.data.get('username', user.username)
        user.email = request.data.get('email', user.email)
        user.last_name = request.data.get('last_name', user.last_name)

        try:
            user.save()  # Save the updated fields
        except Exception as e:
            return Response(
                {"error": f"Failed to update user: {str(e)}"},
                status=status.HTTP_400_BAD_REQUEST
            )

        # Return the updated user data
        return Response(
            UserSerializer(user).data,
            status=status.HTTP_200_OK
        )

    def get_random_user_by_mutual_friends(self, request):
        """Helper function to get the top 10 users ordered by mutual friends, excluding friends."""
        logged_in_user = request.user
        
        # Fetch users and annotate them with the count of mutual friends with the logged-in user
        users = User.objects.exclude(id=logged_in_user.id)  # Exclude the logged-in user
        users_with_mutual_friends = []
        
        for user in users:
            # Ensure the user is not already friends with the logged-in user
            if not Friend.objects.get_friendship_id(logged_in_user, user):
                # Count the number of mutual friends between the logged-in user and each user
                mutual_count = Friend.objects.mutual_friends_count(logged_in_user, user)
                users_with_mutual_friends.append((user, mutual_count))
        
        # Sort users by mutual friend count in descending order
        users_with_mutual_friends.sort(key=lambda x: x[1], reverse=True)

        # Select the top 10 users with the most mutual friends
        top_users = users_with_mutual_friends[:10]

        # If there are users, prepare the response
        if top_users:
            response_data = []
            
            for user, mutual_count in top_users:
                # Serialize user data and add mutual friends count to the response
                serializer = UserSerializer(user)
                user_data = serializer.data
                user_data['mutual_friends'] = mutual_count
                response_data.append(user_data)
            
            return Response(response_data)
        else:
            return Response(
                {"error": "No users with mutual friends found"},
                status=status.HTTP_404_NOT_FOUND
            ) 


            

class ActivityViewSet(viewsets.ModelViewSet):
    serializer_class = ActivitySerializer
    queryset = Activity.objects.all()

    def get_queryset(self):
        
        queryset = Activity.objects.all()
        category = self.request.query_params.get('category', None)
        location = self.request.query_params.get('location', None)
        category = category.lower() if category else None
        limit = 30
        if category:
            categories = category.split(',')
            query = Q()
            for c in categories:
                query |= Q(category__icontains=c)
            queryset = queryset.filter(query)  # Case-insensitive match
        if location:
            queryset = queryset.filter(location__icontains=location.lower())

        return queryset[:limit]

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
        calendars =Calendar.objects.filter(user=request.user)
        serializer = self.get_serializer(calendars, many=True)
        if request.GET.get('detail', False):
            name = request.GET.get('name')
            data = serializer.data
            new_data = []
            for calendar in data:
                new_data.append({
                    **calendar,
                    'events': ChosenActivitySerializer(ChosenActivity.objects.get_activities_of_calendar(request.user.id, calendar['id']), many=True).data
                })
            return Response(new_data)
        return Response(serializer.data)

    def create(self, request):
        adding = {
            'user': request.user.id,
            **request.data
        }
        serializer = self.get_serializer(data= adding)
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
    
    @action(detail=False, methods=['get'])
    def invite(self, request):
        invites = InviteCalendar.objects.filter(invite=request.user
                                                        )
        calendar_ids = [invite.calendar.id for invite in invites]    
        calendars = Calendar.objects.filter(id__in=calendar_ids)
        serializer = self.get_serializer(calendars, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class ChosenActivityViewSet(viewsets.ModelViewSet):
    queryset = ChosenActivity.objects.all()
    serializer_class = ChosenActivitySerializer
    permission_classes = [IsAuthenticated] 
    
    
    def list(self, request):
        self.queryset = ChosenActivity.objects.filter(user=request.user)
        chosen_activities = self.queryset
        serializer = self.get_serializer(chosen_activities, many=True)
        return Response(serializer.data)

    def create(self, request):
        
        adding = {
            'user': request.user.id,
            **request.data  

        }
        serializer = self.get_serializer(data=adding)
        if serializer.is_valid():
            print("Serializer is valid")
            chosen_activity = serializer.save()
            # print(self.get_serializer(chosen_activity).data)
            return Response(self.get_serializer(chosen_activity).data, status=status.HTTP_201_CREATED)
        print("Serializer is invalid")
        print("Errors:", serializer.errors)  
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        self.queryset = ChosenActivity.objects.all()
        chosen_activity = self.get_object()
        serializer = self.get_serializer(chosen_activity)
        return Response(serializer.data)

    def update(self, request, pk=None):
        print("Updating chosen activity")
        chosen_activity = self.get_object()
        adding = {
            'user': request.user.id,
            **request.data

        }
        serializer = self.get_serializer(chosen_activity, data=adding)
        if serializer.is_valid():
            updated_chosen_activity = serializer.save()
            return Response(self.get_serializer(updated_chosen_activity).data)
        print("Serializer is invalid")
        print("Errors:", serializer.errors)  
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

    @action(detail=False, methods=['get'])
    def chosen_list(self, request):
        name = request.GET.get('calendar', None)
        activities = ChosenActivity.objects.get_activities_of_traveller(request.user.id, name)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)

    @action(detail=True, methods=['get'])
    def calendar(self, request, pk=None):
        activities = ChosenActivity.objects.get_activities_of_calendar(request.user.id, pk)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def today(self, request):
        activities = ChosenActivity.objects.get_activities_of_calendar_today(request.user.id)
        serializer = self.get_serializer(activities, many=True)
        return Response(serializer.data)
    

class PostViewSet(viewsets.ModelViewSet):
    queryset = Post.objects.all()
    serializer_class = PostSerializer
    
    def list(self, request):
        posts = Post.objects.all().order_by('-created_at')
        serializer = self.get_serializer(posts, many=True)
        return Response(serializer.data)

    def create(self, request):
        adding = {
            'author': request.user.id,
            **request.data
        }
        serializer = self.get_serializer(data= adding)
        if serializer.is_valid():
            post = serializer.save()
            return Response(self.get_serializer(post).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def retrieve(self, request, pk=None):
        post = self.get_object()
        serializer = self.get_serializer(post)
        return Response(serializer.data)

    def update(self, request, pk=None):
        post = self.get_object()
        changing = {
            'author': request.user.id,
            **request.data
        }
        serializer = self.get_serializer(post, data=changing)
        if serializer.is_valid():
            updated_post = serializer.save()
            return Response(self.get_serializer(updated_post).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def partial_update(self, request, pk=None):
        post = self.get_object()
        serializer = self.get_serializer(post, data=request.data, partial=True)
        if serializer.is_valid():
            updated_post = serializer.save()
            return Response(self.get_serializer(updated_post).data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def destroy(self, request, pk=None):
        post = self.get_object()
        post.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
    @action(detail=True, methods=['post'])
    def like(self, request, pk=None):
        post = self.get_object()
        user = request.user
        like = request.data.get('like', None)
        if like:
            post.likes.add(user)
        else:
            post.likes.remove(user)
        return Response(status=status.HTTP_200_OK)
class FriendViewSet(viewsets.ModelViewSet):
    """
    ViewSet for managing friend relationships.
    """
    queryset = Friend.objects.all()
    serializer_class = FriendSerializer
    
    def list(self, request):
        friends = Friend.objects.filter(Q(user=request.user) | Q(friend=request.user))
        serializer = self.get_serializer(friends, many=True)
        return Response(serializer.data)
    
    def create(self, request):
        adding = {
            'user': request.user.id,
            'friend' : request.data.get('friend'),
            'status': False
        }
        print('adding',adding)
        serializer = self.get_serializer(data=adding)
        if serializer.is_valid():
            friend = serializer.save()
            return Response(self.get_serializer(friend).data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def destroy(self, request, pk=None):
        friend = self.get_object()
        friend.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
    def update(self, request, pk = None):
        friend_instance = self.get_object()
        if friend_instance.status:
            return Response({"detail": "Friend request already accepted."}, status=status.HTTP_400_BAD_REQUEST)
        friend_instance.status = True
        friend_instance.save()
        return Response({"detail": "Friend request accepted."}, status=status.HTTP_200_OK)

    @action(detail=False, methods=['get'])
    def mutual_friends(self, request):
        """
        Custom action to get mutual friends between the current user and another user.
        """
        user = request.user
        other_user_id = request.query_params.get('other_user_id')
        if not other_user_id:
            return Response({"detail": "other_user_id is required as a query parameter."}, status=status.HTTP_400_BAD_REQUEST)

        try:
            other_user = User.objects.get(pk=other_user_id)
        except User.DoesNotExist:
            return Response({"detail": "Other user not found."}, status=status.HTTP_404_NOT_FOUND)

        user_friends = Friend.objects.filter(user=user, status=True).values_list('friend', flat=True)
        other_user_friends = Friend.objects.filter(user=other_user, status=True).values_list('friend', flat=True)
        mutual_friend_ids = set(user_friends).intersection(set(other_user_friends))

        mutual_friends = User.objects.filter(id__in=mutual_friend_ids)
        return Response(
            {"mutual_friends": [{"id": mf.id, "username": mf.username} for mf in mutual_friends]},
            status=status.HTTP_200_OK
        )
        
    @action(detail=False, methods=['get'])
    def get_receive(self, request):
        """
        Custom action to get all pending friend requests for the current user.
        """
        pending_requests = Friend.objects.get_pending_requests(request.user)
        serializer = self.get_serializer(pending_requests, many=True)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def get_sent(self, request):
        """
        Custom action to get all sent friend requests by the current user.
        """
        sent_requests = Friend.objects.get_sent_requests(request.user)
        serializer = self.get_serializer(sent_requests, many=True)
        return Response(serializer.data)
    
class InviteCalendarViewSet(viewsets.ModelViewSet):
    queryset = InviteCalendar.objects.all()
    serializer_class = InviteCalendarSerializer
    
    def list(self, request):
        invite_calendars = InviteCalendar.objects.filter(invite = request.user)
        serializer = self.get_serializer(invite_calendars, many=True)
        return Response(serializer.data)
    
    def create(self, request):
        
        adding = {
            'invite': request.data.get('invite'),
            'owner': request.user.id,
            'calendar' : request.data.get('calendar'),
            'status': False
        }
        serializer = self.get_serializer(data=adding)
        if serializer.is_valid():
            print("Serializer is valid")
            invite_calendar = serializer.save()
            return Response(self.get_serializer(invite_calendar).data, status=status.HTTP_201_CREATED)
        print("Serializer is invalid")
        print("Errors:", serializer.errors)  
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def destroy(self, request, pk=None):
        invite_calendar = self.get_object()
        invite_calendar.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
    def update(self, request, pk = None):
        invite_calendar_instance = self.get_object()
        if invite_calendar_instance.status:
            return Response({"detail": "Friend request already accepted."}, status=status.HTTP_400_BAD_REQUEST)
        invite_calendar_instance.status = True
        invite_calendar_instance.save()
        return Response({"detail": "Friend request accepted."}, status=status.HTTP_200_OK)
    
    @action(detail=False, methods=['get'])
    def calendar(self, request):
        """
        Custom action to get all friends invited by the current user.
        """
        invited_friends = InviteCalendar.objects.filter(calendar=request.GET.get('calendar'))
        serializer = self.get_serializer(invited_friends, many=True)
        print(request.GET.get('calendar'), serializer.data)
        return Response(serializer.data)
