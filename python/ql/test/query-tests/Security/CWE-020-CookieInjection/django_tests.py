import django.http
from django.urls import path

def django_response_bad(request): # $ Source
    resp = django.http.HttpResponse()
    resp.set_cookie(request.GET.get("name"), # $ Alert # BAD: Cookie is constructed from user input
                    request.GET.get("value")) # $ Alert
    return resp


def django_response_bad2(request): # $ Source
    response = django.http.HttpResponse()
    response['Set-Cookie'] = f"{request.GET.get('name')}={request.GET.get('value')}; SameSite=None;" # $ Alert # BAD: Cookie header is constructed from user input.
    return response

# fake setup, you can't actually run this
urlpatterns = [
    path("response_bad", django_response_bad),
    path("response_bd2", django_response_bad2)
]
