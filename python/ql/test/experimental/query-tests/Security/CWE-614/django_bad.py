import django.http


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure=None)
    return resp


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure=False)
    return resp
