"""test of views for Django 1.x"""
from django.conf.urls import patterns, url
from django.http.response import HttpResponse
from django.views.generic import View


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
    url(r"^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)", url_match_xss),  # $routeSetup="^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)"
    url(r"^get_params", get_params_xss),  # $routeSetup="^get_params"
    url(r"^post_params", post_params_xss),  # $routeSetup="^post_params"
    url(r"^http_resp_write", http_resp_write),  # $routeSetup="^http_resp_write"
    url(r"^class_view/(?P<untrusted>.+)", ClassView.as_view()),  # $routeSetup="^class_view/(?P<untrusted>.+)"

    # one pattern to support `articles/page-<n>` and ensuring that articles/ goes to page-1
    url(r"articles/^(?:page-(?P<page_number>\d+)/)?", show_articles),  # $routeSetup="articles/^(?:page-(?P<page_number>\d+)/)?"
    # passing as positional argument is not the recommended way of doing things, but it is certainly
    # possible
    url(r"^([^/]+)/(?:foo|bar)/([^/]+)", xxs_positional_arg, name='xxs_positional_arg'),  # $routeSetup="^([^/]+)/(?:foo|bar)/([^/]+)"
]

################################################################################
# Using patterns() for routing

def show_user(request, username):  # $routeHandler routedParameter=username
    return HttpResponse('show_user {}'.format(username))  # $HttpResponse


urlpatterns = patterns(url(r"^users/(?P<username>[^/]+)", show_user))  # $routeSetup="^users/(?P<username>[^/]+)"

################################################################################
# Show we understand the keyword arguments to django.conf.urls.url

def kw_args(request):  # $routeHandler
    return HttpResponse('kw_args')  # $HttpResponse

urlpatterns = [
    url(view=kw_args, regex=r"^kw_args")  # $routeSetup="^kw_args"
]
