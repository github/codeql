from django.http import HttpRequest, HttpResponse

def foo(request: HttpRequest):  # $f-:routeHandler
    return HttpResponse("foo")

def bar_baz(request: HttpRequest):  # $f-:routeHandler
    return HttpResponse("bar_baz")
