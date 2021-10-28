import django.http


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure=False,
                    httponly=False, samesite='None')
    return resp


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure=False,
                    httponly=False, samesite='None')
    return resp
