from django.urls import path, include
from rest_framework import routers

from . import views


router = routers.DefaultRouter()
router.register(r"foos", views.FooViewSet)
router.register(r"bars", views.BarViewSet)

urlpatterns = [
    path("", include(router.urls)),
    path("api-auth/", include("rest_framework.urls", namespace="rest_framework")),
    path("class-based-view/", views.MyClass.as_view()),  # $routeSetup="lcass-based-view/"
    path("function-based-view/", views.function_based_view),  # $routeSetup="function-based-view/"
    path("cookie-test/", views.cookie_test),  # $routeSetup="function-based-view/"
    path("exception-test/", views.exception_test),  # $routeSetup="exception-test/"
]
