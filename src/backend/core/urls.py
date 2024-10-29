from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ActivityViewSet,
    CalendarViewSet,
    ChosenActivityViewSet,
    UserRecordView,
)

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'activities', ActivityViewSet)
router.register(r'calendars', CalendarViewSet)
router.register(r'chosen-activities', ChosenActivityViewSet)

# The API URLs are now determined automatically by the router.
app_name = 'api'
urlpatterns = [
    path('user/', UserRecordView.as_view(), name='users'),
    path('', include(router.urls)),
]
