
from django.conf.urls import url
import json

def safe(pickled):
    return json.loads(pickled)

urlpatterns = [
    url(r'^(?P<object>.*)$', safe)
]
