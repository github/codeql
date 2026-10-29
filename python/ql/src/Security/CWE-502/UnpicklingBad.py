
from django.conf.urls import url
import pickle

def unsafe(pickled):
    return pickle.loads(pickled)

urlpatterns = [
    url(r'^(?P<object>.*)$', unsafe)
]