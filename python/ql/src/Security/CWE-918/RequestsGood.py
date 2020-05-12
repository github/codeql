from django.conf.urls import url
import requests 

def unsafe(url):
    # GOOD: The request is checked agains a valid URI
    if url == "valid_url":
        return requests.get(url)

urlpatterns = [
    url(r'^(?P<object>.*)$', unsafe)
]
