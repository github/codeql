import django.http


def django_setitem():
    rfs_header = django.http.request.GET.get("rfs_header")
    response = django.http.HttpResponse()
    response.__setitem__('HeaderName', rfs_header)
    return response


def django_response():
    rfs_header = django.http.request.GET.get("rfs_header")
    response = django.http.HttpResponse()
    response['HeaderName'] = rfs_header
    return response
