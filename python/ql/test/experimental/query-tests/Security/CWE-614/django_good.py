import django.http


def django_response(request):
    resp = django.http.HttpResponse()
    resp['Set-Cookie'] = "name=value; Secure;"
    return resp


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure=True)
    return resp


def indeterminate(secure):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure)
    return resp
