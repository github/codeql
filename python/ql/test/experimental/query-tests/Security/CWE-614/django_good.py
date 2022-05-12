import django.http


def django_response(request):
    resp = django.http.HttpResponse()
    resp['Set-Cookie'] = "name=value; Secure; HttpOnly; SameSite=Lax;"
    return resp


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure=True,
                    httponly=True, samesite='Lax')
    return resp


def indeterminate(secure):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure)
    return resp
