from django.http import HttpResponse, HttpRequest

def foo(request: HttpRequest):
    return HttpResponse("foo")
