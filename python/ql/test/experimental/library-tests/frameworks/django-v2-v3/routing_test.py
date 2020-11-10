"""testing views for Django 2.x and 3.x"""
from django.urls import path, re_path
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse, HttpResponseNotFound
from django.views import View


def url_match_xss(request, foo, bar, no_taint=None):  # $routeHandler routedParameter=foo routedParameter=bar
    return HttpResponse('url_match_xss: {} {}'.format(foo, bar))  # $HttpResponse


def get_params_xss(request):  # $routeHandler
    return HttpResponse(request.GET.get("untrusted"))  # $HttpResponse


def post_params_xss(request):  # $routeHandler
    return HttpResponse(request.POST.get("untrusted"))  # $HttpResponse


def http_resp_write(request):  # $routeHandler
    rsp = HttpResponse()  # $HttpResponse
    rsp.write(request.GET.get("untrusted"))  # $HttpResponse
    return rsp


class Foo(object):
    # Note: since Foo is used as the super type in a class view, it will be able to handle requests.


    def post(self, request, untrusted):  # $ MISSING: routeHandler routedParameter=untrusted
        return HttpResponse('Foo post: {}'.format(untrusted))  # $HttpResponse


class ClassView(View, Foo):

    def get(self, request, untrusted):  # $ MISSING: routeHandler routedParameter=untrusted
        return HttpResponse('ClassView get: {}'.format(untrusted))  # $HttpResponse


def show_articles(request, page_number=1):  # $routeHandler routedParameter=page_number
    page_number = int(page_number)
    return HttpResponse('articles page: {}'.format(page_number))  # $HttpResponse


def xxs_positional_arg(request, arg0, arg1, no_taint=None):  # $routeHandler routedParameter=arg0 routedParameter=arg1
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

def re_path_kwargs(request):  # $routeHandler
    return HttpResponse('re_path_kwargs')  # $HttpResponse


urlpatterns = [
    re_path(view=re_path_kwargs, route=r"^specifying-as-kwargs-is-not-a-problem")  # $routeSetup="^specifying-as-kwargs-is-not-a-problem"
]

################################################################################
# Using path
################################################################################

# saying page_number is an externally controlled *string* is a bit strange, when we have an int converter :O
def page_number(request, page_number=1):  # $routeHandler routedParameter=page_number
    return HttpResponse('page_number: {}'.format(page_number))  # $HttpResponse

def foo_bar_baz(request, foo, bar, baz):  # $routeHandler routedParameter=foo routedParameter=bar routedParameter=baz
    return HttpResponse('foo_bar_baz: {} {} {}'.format(foo, bar, baz))  # $HttpResponse

def path_kwargs(request, foo, bar):  # $routeHandler routedParameter=foo routedParameter=bar
    return HttpResponse('path_kwargs: {} {} {}'.format(foo, bar))  # $HttpResponse

def not_valid_identifier(request):  # $routeHandler
    return HttpResponse('<foo!>')  # $HttpResponse

urlpatterns = [
    path("articles/", page_number),  # $routeSetup="articles/"
    path("articles/page-<int:page_number>", page_number),  # $routeSetup="articles/page-<int:page_number>"
    path("<int:foo>/<str:bar>/<baz>", foo_bar_baz, name='foo-bar-baz'),  # $routeSetup="<int:foo>/<str:bar>/<baz>"

    path(view=path_kwargs, route="<foo>/<bar>"),  # $routeSetup="<foo>/<bar>"

    # We should not report there is a request parameter called `not_valid!`
    path("not_valid/<not_valid!>", not_valid_identifier),  # $routeSetup="not_valid/<not_valid!>"
]

# This version 1.x way of defining urls is deprecated in Django 3.1, but still works
from django.conf.urls import url

def deprecated(request):  # $routeHandler
    return HttpResponse('deprecated')  # $HttpResponse

urlpatterns = [
    url(r"^deprecated/", deprecated),  # $routeSetup="^deprecated/"
]
