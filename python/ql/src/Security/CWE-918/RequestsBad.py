from django.conf.urls import url
import requests 

def unsafe(url):
    # BAD: The request isn't checked against an authorized list of URI's
    return requests.get(url)

urlpatterns = [
    url(r'^(?P<object>.*)$', unsafe)
]
