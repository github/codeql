from django.urls import path, include
from rest_framework import routers

from . import views


router = routers.DefaultRouter()
router.register(r"foos", views.FooViewSet)
router.register(r"bars", views.BarViewSet)

urlpatterns = [
    path("", include(router.urls)),
    path("api-auth/", include("rest_framework.urls", namespace="rest_framework")),
    path("example/", views.example),  # $routeSetup="example/"
]
