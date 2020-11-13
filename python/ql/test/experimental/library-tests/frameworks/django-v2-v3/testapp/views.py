from django.http import HttpRequest, HttpResponse

def foo(request: HttpRequest):  # $routeHandler
    return HttpResponse("foo")  # $HttpResponse

def bar_baz(request: HttpRequest):  # $routeHandler
    return HttpResponse("bar_baz")  # $HttpResponse

def deprecated(request: HttpRequest):  # $routeHandler
    return HttpResponse("deprecated")  # $HttpResponse
