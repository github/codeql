from django.template import Template, engines
from django.urls import path
from django.http.response import HttpResponse

def a(request):  # $ requestHandler
    t = Template("abc").render() # $ templateConstruction="abc"
    return HttpResponse(t)  # $ HttpResponse

def b(request): # $ requestHandler
    # This case is not currently supported
    t = django.template.engines["django"].from_string("abc") # $ MISSING:templateConstruction="abc"
    return HttpResponse(t)  # $ HttpResponse

urlpatterns = [
    path("a", a),  # $ routeSetup="a"
    path("b", b),  # $ routeSetup="b"
]