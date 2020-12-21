from django.http import HttpRequest, HttpResponse
from django.views import View
from django.views.decorators.csrf import csrf_exempt


def foo(request: HttpRequest):  # $requestHandler
    return HttpResponse("foo")  # $HttpResponse


def bar_baz(request: HttpRequest):  # $requestHandler
    return HttpResponse("bar_baz")  # $HttpResponse


def deprecated(request: HttpRequest):  # $requestHandler
    return HttpResponse("deprecated")  # $HttpResponse


class MyBasicViewHandler(View):
    def get(self, request: HttpRequest): # $ requestHandler
        return HttpResponse("MyViewHandler: GET") # $ HttpResponse

    def post(self, request: HttpRequest): # $ requestHandler
        return HttpResponse("MyViewHandler: POST") # $ HttpResponse


class MyCustomViewBaseClass(View):
    def post(self, request: HttpRequest): # $ requestHandler
        return HttpResponse("MyCustomViewBaseClass: POST") # $ HttpResponse


class MyViewHandlerWithCustomInheritance(MyCustomViewBaseClass):
    def get(self, request: HttpRequest): # $ requestHandler
        return HttpResponse("MyViewHandlerWithCustomInheritance: GET") # $ HttpResponse
