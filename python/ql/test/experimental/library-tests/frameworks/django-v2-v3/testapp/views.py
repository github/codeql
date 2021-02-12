from django.http import HttpRequest, HttpResponse
from django.views.generic import View, RedirectView
from django.views.decorators.csrf import csrf_exempt


def foo(request: HttpRequest):  # $requestHandler
    return HttpResponse("foo")  # $HttpResponse


def bar_baz(request: HttpRequest):  # $requestHandler
    return HttpResponse("bar_baz")  # $HttpResponse


def deprecated(request: HttpRequest):  # $requestHandler
    return HttpResponse("deprecated")  # $HttpResponse


class MyBasicViewHandler(View):
    def get(self, request: HttpRequest): # $ requestHandler
        return HttpResponse("MyViewHandler: GET") # $ HttpResponse

    def post(self, request: HttpRequest): # $ requestHandler
        return HttpResponse("MyViewHandler: POST") # $ HttpResponse


class MyCustomViewBaseClass(View):
    def post(self, request: HttpRequest): # $ requestHandler
        return HttpResponse("MyCustomViewBaseClass: POST") # $ HttpResponse


class MyViewHandlerWithCustomInheritance(MyCustomViewBaseClass):
    def get(self, request: HttpRequest): # $ requestHandler
        print(self.request.GET)
        return HttpResponse("MyViewHandlerWithCustomInheritance: GET") # $ HttpResponse

# RedirectView
# See docs at https://docs.djangoproject.com/en/3.1/ref/class-based-views/base/#redirectview
class CustomRedirectView(RedirectView):

    def get_redirect_url(self, foo): # $ requestHandler routedParameter=foo
        next = "https://example.com/{}".format(foo)
        return next # $ HttpResponse HttpRedirectResponse redirectLocation=next


class CustomRedirectView2(RedirectView):

    url = "https://example.com/%(foo)s"
