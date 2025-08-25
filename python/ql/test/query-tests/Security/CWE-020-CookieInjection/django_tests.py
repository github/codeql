import django.http
from django.urls import path

def django_response_bad(request):
    resp = django.http.HttpResponse()
    resp.set_cookie(request.GET.get("name"), # BAD: Cookie is constructed from user input
                    request.GET.get("value"))
    return resp


def django_response_bad2(request):
    response = django.http.HttpResponse()
    response['Set-Cookie'] = f"{request.GET.get('name')}={request.GET.get('value')}; SameSite=None;" # BAD: Cookie header is constructed from user input.
    return response

# fake setup, you can't actually run this
urlpatterns = [
    path("response_bad", django_response_bad),
    path("response_bd2", django_response_bad2)
]