"""testing views for Django 2.x and 3.x"""
from django.urls import path, re_path
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse, HttpResponseNotFound
from django.views import View
import django.views.generic.base
from django.views.decorators.http import require_GET


def url_match_xss(request, foo, bar, no_taint=None):  # $requestHandler routedParameter=foo routedParameter=bar
    return HttpResponse('url_match_xss: {} {}'.format(foo, bar))  # $HttpResponse


def get_params_xss(request):  # $requestHandler
    return HttpResponse(request.GET.get("untrusted"))  # $HttpResponse


def post_params_xss(request):  # $requestHandler
    return HttpResponse(request.POST.get("untrusted"))  # $HttpResponse


def http_resp_write(request):  # $requestHandler
    rsp = HttpResponse()  # $HttpResponse
    rsp.write(request.GET.get("untrusted"))  # $HttpResponse
    return rsp


class Foo(object):
    # Note: since Foo is used as the super type in a class view, it will be able to handle requests.


    def post(self, request, untrusted):  # $ MISSING: requestHandler routedParameter=untrusted
        return HttpResponse('Foo post: {}'.format(untrusted))  # $HttpResponse


class ClassView(View, Foo):

    def get(self, request, untrusted):  # $ requestHandler routedParameter=untrusted
        return HttpResponse('ClassView get: {}'.format(untrusted))  # $HttpResponse


# direct import with full path to `View` class
class ClassView2(django.views.generic.base.View):
    def get(self, request): # $ requestHandler
        pass


def show_articles(request, page_number=1):  # $requestHandler routedParameter=page_number
    page_number = int(page_number)
    return HttpResponse('articles page: {}'.format(page_number))  # $HttpResponse


def xxs_positional_arg(request, arg0, arg1, no_taint=None):  # $requestHandler routedParameter=arg0 routedParameter=arg1
    return HttpResponse('xxs_positional_arg: {} {}'.format(arg0, arg1))  # $HttpResponse


urlpatterns = [
    re_path(r"^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)", url_match_xss),  # $routeSetup="^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)"
    re_path(r"^get_params", get_params_xss),  # $routeSetup="^get_params"
    re_path(r"^post_params", post_params_xss),  # $routeSetup="^post_params"
    re_path(r"^http_resp_write", http_resp_write),  # $routeSetup="^http_resp_write"
    re_path(r"^class_view/(?P<untrusted>.+)", ClassView.as_view()),  # $routeSetup="^class_view/(?P<untrusted>.+)"

    # one pattern to support `articles/page-<n>` and ensuring that articles/ goes to page-1
    re_path(r"articles/^(?:page-(?P<page_number>\d+)/)?", show_articles),  # $routeSetup="articles/^(?:page-(?P<page_number>\d+)/)?"
    # passing as positional argument is not the recommended way of doing things, but it is certainly
    # possible
    re_path(r"^([^/]+)/(?:foo|bar)/([^/]+)", xxs_positional_arg, name='xxs_positional_arg'),  # $routeSetup="^([^/]+)/(?:foo|bar)/([^/]+)"
]


# Show we understand the keyword arguments to django.urls.re_path

def re_path_kwargs(request):  # $requestHandler
    return HttpResponse('re_path_kwargs')  # $HttpResponse


urlpatterns = [
    re_path(view=re_path_kwargs, route=r"^specifying-as-kwargs-is-not-a-problem")  # $routeSetup="^specifying-as-kwargs-is-not-a-problem"
]

################################################################################
# Using path
################################################################################

# saying page_number is an externally controlled *string* is a bit strange, when we have an int converter :O
def page_number(request, page_number=1):  # $requestHandler routedParameter=page_number
    return HttpResponse('page_number: {}'.format(page_number))  # $HttpResponse

def foo_bar_baz(request, foo, bar, baz):  # $requestHandler routedParameter=foo routedParameter=bar routedParameter=baz
    return HttpResponse('foo_bar_baz: {} {} {}'.format(foo, bar, baz))  # $HttpResponse

def path_kwargs(request, foo, bar):  # $requestHandler routedParameter=foo routedParameter=bar
    return HttpResponse('path_kwargs: {} {} {}'.format(foo, bar))  # $HttpResponse

def not_valid_identifier(request):  # $requestHandler
    return HttpResponse('<foo!>')  # $HttpResponse

urlpatterns = [
    path("articles/", page_number),  # $routeSetup="articles/"
    path("articles/page-<int:page_number>", page_number),  # $routeSetup="articles/page-<int:page_number>"
    path("<int:foo>/<str:bar>/<baz>", foo_bar_baz, name='foo-bar-baz'),  # $routeSetup="<int:foo>/<str:bar>/<baz>"

    path(view=path_kwargs, route="<foo>/<bar>"),  # $routeSetup="<foo>/<bar>"

    # We should not report there is a request parameter called `not_valid!`
    path("not_valid/<not_valid!>", not_valid_identifier),  # $routeSetup="not_valid/<not_valid!>"
]

################################################################################
# Deprecated django.conf.urls.url
################################################################################

# This version 1.x way of defining urls is deprecated in Django 3.1, but still works
from django.conf.urls import url

def deprecated(request):  # $requestHandler
    return HttpResponse('deprecated')  # $HttpResponse

urlpatterns = [
    url(r"^deprecated/", deprecated),  # $routeSetup="^deprecated/"
]


################################################################################
# Special stuff
################################################################################

class PossiblyNotRouted(View):
    # Even if our analysis can't find a route-setup for this class, we should still
    # consider it to be a handle incoming HTTP requests

    def get(self, request, possibly_not_routed=42):  # $ requestHandler routedParameter=possibly_not_routed
        return HttpResponse('PossiblyNotRouted get: {}'.format(possibly_not_routed))  # $HttpResponse


@require_GET
def with_decorator(request, foo):  # $ requestHandler routedParameter=foo
    pass

urlpatterns = [
    path("with_decorator/<foo>", with_decorator),  # $ routeSetup="with_decorator/<foo>"
]

class UnknownViewSubclass(UnknownViewSuperclass):
    # Although we don't know for certain that this class is a django view class, the fact that it's
    # used with `as_view()` in the routing setup should be enough that we treat it as such.
    def get(self, request): # $ requestHandler
        pass

urlpatterns = [
    path("UnknownViewSubclass/", UnknownViewSubclass.as_view()),  # $ routeSetup="UnknownViewSubclass/"
]

################################################################################
# Routing to *args and **kwargs
################################################################################

def kwargs_param(request, **kwargs): # $ requestHandler routedParameter=kwargs
    ensure_tainted(
        kwargs, # $ tainted
        kwargs["foo"], # $ tainted
        kwargs["bar"]  # $ tainted
    )

    ensure_tainted(request) # $ tainted


def star_args_param(request, *args): # $ requestHandler routedParameter=args
    ensure_tainted(
        args, # $ tainted
        args[0], # $ tainted
        args[1], # $ tainted
    )
    ensure_tainted(request) # $ tainted


def star_args_param_check(request, foo, bar): # $ requestHandler routedParameter=foo routedParameter=bar
    ensure_tainted(
        foo, # $ tainted
        bar, # $ tainted
    )
    ensure_tainted(request) # $ tainted


urlpatterns = [
    path("test-kwargs_param/<foo>/<bar>", kwargs_param),  # $ routeSetup="test-kwargs_param/<foo>/<bar>"
    re_path("test-star_args_param/([^/]+)/(.+)", star_args_param),  # $ routeSetup="test-star_args_param/([^/]+)/(.+)"
    re_path("test-star_args_param_check/([^/]+)/(.+)", star_args_param_check),  # $ routeSetup="test-star_args_param_check/([^/]+)/(.+)"
]
