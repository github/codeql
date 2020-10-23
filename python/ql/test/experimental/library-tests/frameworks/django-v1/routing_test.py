"""test of views for Django 1.x"""
from django.conf.urls import patterns, url
from django.http.response import HttpResponse
from django.views.generic import View


def url_match_xss(request, foo, bar, no_taint=None):  # $f-:routeHandler $f-:routedParameter=foo $f-:routedParameter=bar
    return HttpResponse('url_match_xss: {} {}'.format(foo, bar))


def get_params_xss(request):  # $f-:routeHandler
    return HttpResponse(request.GET.get("untrusted"))


def post_params_xss(request):  # $f-:routeHandler
    return HttpResponse(request.POST.get("untrusted"))


def http_resp_write(request):  # $f-:routeHandler
    rsp = HttpResponse()
    rsp.write(request.GET.get("untrusted"))
    return rsp


class Foo(object):
    # Note: since Foo is used as the super type in a class view, it will be able to handle requests.


    def post(self, request, untrusted):  # $f-:routeHandler $f-:routedParameter=untrusted
        return HttpResponse('Foo post: {}'.format(untrusted))


class ClassView(View, Foo):

    def get(self, request, untrusted):  # $f-:routeHandler $f-:routedParameter=untrusted
        return HttpResponse('ClassView get: {}'.format(untrusted))


def show_articles(request, page_number=1):  # $f-:routeHandler $f-:routedParameter=page_number
    page_number = int(page_number)
    return HttpResponse('articles page: {}'.format(page_number))


def xxs_positional_arg(request, arg0, arg1, no_taint=None):  # $f-:routeHandler $f-:routedParameter=arg0 $f-:routedParameter=arg1
    return HttpResponse('xxs_positional_arg: {} {}'.format(arg0, arg1))


urlpatterns = [
    url(r"^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)", url_match_xss),  # $f-:routeSetup="^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)"
    url(r"^get_params", get_params_xss),  # $f-:routeSetup="^get_params"
    url(r"^post_params", post_params_xss),  # $f-:routeSetup="^post_params"
    url(r"^http_resp_write", http_resp_write),  # $f-:routeSetup="^http_resp_write"
    url(r"^class_view/(?P<untrusted>.+)", ClassView.as_view()),  # $f-:routeSetup="^class_view/(?P<untrusted>.+)"

    # one pattern to support `articles/page-<n>` and ensuring that articles/ goes to page-1
    url(r"articles/^(?:page-(?P<page_number>\d+)/)?", show_articles),  # $f-:routeSetup="articles/^(?:page-(?P<page_number>\d+)/)?"
    # passing as positional argument is not the recommended way of doing things, but it is certainly
    # possible
    url(r"^([^/]+)/(?:foo|bar)/([^/]+)", xxs_positional_arg, name='xxs_positional_arg'),  # $f-:routeSetup="^([^/]+)/(?:foo|bar)/([^/]+)"
]

################################################################################
# Using patterns() for routing

def show_user(request, username):  # $f-:routeHandler $f-:routedParameter=username
    return HttpResponse('show_user {}'.format(username))


urlpatterns = patterns(url(r"^users/(?P<username>[^/]+)", show_user))  # $f-:routeSetup="^users/(?P<username>[^/]+)"

################################################################################
# Show we understand the keyword arguments to django.conf.urls.url

def kw_args(request):  # $f-:routeHandler
    return HttpResponse('kw_args')

urlpatterns = [
    url(view=kw_args, regex=r"^kw_args")  # $f-:routeSetup="^kw_args"
]
