from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    TravellerViewSet,
    ActivityViewSet,
    CalendarViewSet,
    ChosenActivityViewSet,
)

# Create a router and register our viewsets with it.
router = DefaultRouter()
router.register(r'travellers', TravellerViewSet)
router.register(r'activities', ActivityViewSet)
router.register(r'calendars', CalendarViewSet)
router.register(r'chosen-activities', ChosenActivityViewSet)

# The API URLs are now determined automatically by the router.
urlpatterns = [
    path('', include(router.urls)),
]
