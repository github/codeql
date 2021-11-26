from .models import Foo, Bar
from rest_framework import serializers


class FooSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Foo
        fields = ["title"]


class BarSerializer(serializers.HyperlinkedModelSerializer):
    class Meta:
        model = Bar
        fields = ["n", "foo"]
