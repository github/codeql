import django.http


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie("name", "value", secure=False,
                    httponly=False, samesite='None')
    return resp


def django_response():
    response = django.http.HttpResponse()
    response['Set-Cookie'] = "name=value; SameSite=None;"
    return response


def django_response(request):
    resp = django.http.HttpResponse()
    resp.set_cookie(django.http.request.GET.get("name"),
                    django.http.request.GET.get("value"),
                    secure=False, httponly=False, samesite='None')
    return resp


def django_response():
    response = django.http.HttpResponse()
    response['Set-Cookie'] = f"{django.http.request.GET.get('name')}={django.http.request.GET.get('value')}; SameSite=None;"
    return response
