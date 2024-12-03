from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ActivityViewSet,
    CalendarViewSet,
    ChosenActivityViewSet,
    UserRecordView,
    CustomAuthToken,
    PostViewSet,
    FriendViewSet
)

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'activities', ActivityViewSet)
router.register(r'calendars', CalendarViewSet)
router.register(r'chosen-activities', ChosenActivityViewSet)
router.register(r'posts', PostViewSet)
router.register(r'friends', FriendViewSet)

# The API URLs are now determined automatically by the router.
app_name = 'api'
urlpatterns = [
    path('token-auth', CustomAuthToken.as_view(), name='api_token_auth'),
    path('user/', UserRecordView.as_view(), name='users'),
    path('user/<int:user_id>/', UserRecordView.as_view(), name='user_detail'),  
    path('', include(router.urls)),
]
