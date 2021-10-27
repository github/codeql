from .models import Foo, Bar
from .serializers import FooSerializer, BarSerializer

from rest_framework import viewsets


class FooViewSet(viewsets.ModelViewSet):
    queryset = Foo.objects.all()
    serializer_class = FooSerializer


class BarViewSet(viewsets.ModelViewSet):
    queryset = Bar.objects.all()
    serializer_class = BarSerializer


# this is pure django
from django.http import HttpResponse, HttpRequest
def example(request: HttpRequest):
    return HttpResponse("example")
