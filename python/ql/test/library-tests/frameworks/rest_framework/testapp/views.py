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

class EntrypointViewSet(viewsets.ModelViewSet):
    queryset = Bar.objects.all()
    serializer_class = BarSerializer

    def create(self, request, *args, **kwargs): # $ requestHandler
        return Response("create") # $ HttpResponse

    def retrieve(self, request, *args, **kwargs): # $ requestHandler
        return Response("retrieve") # $ HttpResponse

    def update(self, request, *args, **kwargs): # $ requestHandler
        return Response("update") # $ HttpResponse

    def partial_update(self, request, *args, **kwargs): # $ requestHandler
        return Response("partial_update") # $ HttpResponse

    def destroy(self, request, *args, **kwargs): # $ requestHandler
        return Response("destroy") # $ HttpResponse

    def list(self, request, *args, **kwargs): # $ requestHandler
        return Response("list") # $ HttpResponse

# class based view
# see https://www.django-rest-framework.org/api-guide/views/#class-based-views

class MyClass(APIView):
    def initial(self, request, *args, **kwargs): # $ requestHandler
        # this method will be called before processing any request
        super().initial(request, *args, **kwargs)

    def get(self, request): # $ requestHandler
        return Response("GET request") # $ HttpResponse

    def post(self, request): # $ requestHandler
        return Response("POST request") # $ HttpResponse


# function based view
# see https://www.django-rest-framework.org/api-guide/views/#function-based-views


@api_view(["GET", "POST"])
def function_based_view(request: Request): # $ requestHandler
    return Response({"message": "Hello, world!"}) # $ HttpResponse


@api_view(["GET", "POST"])
def cookie_test(request: Request): # $ requestHandler
    resp = Response("wat") # $ HttpResponse
    resp.set_cookie("key", "value") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.set_cookie(key="key4", value="value") # $ CookieWrite CookieName="key4" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.headers["Set-Cookie"] = "key2=value2" # $ headerWriteName="Set-Cookie" headerWriteValue="key2=value2" CookieWrite CookieRawHeader="key2=value2" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.cookies["key3"] = "value3" # $ CookieWrite CookieName="key3" CookieValue="value3"
    return resp

@api_view(["GET", "POST"])
def exception_test(request: Request): # $ requestHandler
    # see https://www.django-rest-framework.org/api-guide/exceptions/
    # note: `code details` not exposed by default
    raise APIException("exception details", "code details") # $ HttpResponse
