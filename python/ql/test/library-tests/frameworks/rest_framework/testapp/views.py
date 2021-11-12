from .models import Foo, Bar
from .serializers import FooSerializer, BarSerializer

from rest_framework import viewsets
from rest_framework.decorators import api_view
from rest_framework.views import APIView
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.exceptions import APIException

# Viewsets
# see https://www.django-rest-framework.org/tutorial/quickstart/
class FooViewSet(viewsets.ModelViewSet):
    queryset = Foo.objects.all()
    serializer_class = FooSerializer


class BarViewSet(viewsets.ModelViewSet):
    queryset = Bar.objects.all()
    serializer_class = BarSerializer

# class based view
# see https://www.django-rest-framework.org/api-guide/views/#class-based-views

class MyClass(APIView):
    def initial(self, request, *args, **kwargs):
        # this method will be called before processing any request
        super().initial(request, *args, **kwargs)

    def get(self, request):
        return Response("GET request")

    def post(self, request):
        return Response("POST request")


# function based view
# see https://www.django-rest-framework.org/api-guide/views/#function-based-views


@api_view(["GET", "POST"])
def function_based_view(request: Request):
    return Response({"message": "Hello, world!"})


@api_view(["GET", "POST"])
def cookie_test(request: Request):
    resp = Response("wat")
    resp.set_cookie("key", "value") # $ CookieWrite CookieName="key" CookieValue="value"
    resp.set_cookie(key="key4", value="value") # $ CookieWrite CookieName="key" CookieValue="value"
    resp.headers["Set-Cookie"] = "key2=value2" # $ MISSING: CookieWrite CookieRawHeader="key2=value2"
    resp.cookies["key3"] = "value3" # $ CookieWrite CookieName="key3" CookieValue="value3"
    return resp

@api_view(["GET", "POST"])
def exception_test(request: Request):
    # see https://www.django-rest-framework.org/api-guide/exceptions/
    # note: `code details` not exposed by default
    raise APIException("exception details", "code details")
