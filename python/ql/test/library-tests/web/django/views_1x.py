"""test of views for Django 1.x"""
from django.conf.urls import patterns, url
from django.http.response import HttpResponse, HttpResponseRedirect, JsonResponse, HttpResponseNotFound
from django.views.generic import View


def url_match_xss(request, foo, bar, no_taint=None):
    return HttpResponse('url_match_xss: {} {}'.format(foo, bar))


def get_params_xss(request):
    return HttpResponse(request.GET.get("untrusted"))


def post_params_xss(request):
    return HttpResponse(request.POST.get("untrusted"))


def http_resp_write(request):
    rsp = HttpResponse()
    rsp.write(request.GET.get("untrusted"))
    return rsp


class Foo(object):
    # Note: since Foo is used as the super type in a class view, it will be able to handle requests.


    def post(self, request, untrusted):
        return HttpResponse('Foo post: {}'.format(untrusted))


class ClassView(View, Foo):

    def get(self, request, untrusted):
        return HttpResponse('ClassView get: {}'.format(untrusted))


def show_articles(request, page_number=1):
    page_number = int(page_number)
    return HttpResponse('articles page: {}'.format(page_number))


def xxs_positional_arg(request, arg0, arg1, no_taint=None):
    return HttpResponse('xxs_positional_arg: {} {}'.format(arg0, arg1))


urlpatterns = [
    url(r'^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)$', url_match_xss),
    url(r'^get_params$', get_params_xss),
    url(r'^post_params$', post_params_xss),
    url(r'^http_resp_write$', http_resp_write),
    url(r'^class_view/(?P<untrusted>.+)$', ClassView.as_view()),

    # one pattern to support `articles/page-<n>` and ensuring that articles/ goes to page-1
    url(r'articles/^(?:page-(?P<page_number>\d+)/)?$', show_articles),
    # passing as positional argument is not the recommended way of doing things, but it is certainly
    # possible
    url(r'^([^/]+)/(?:foo|bar)/([^/]+)$', xxs_positional_arg, name='xxs_positional_arg'),
]

################################################################################
# Using patterns() for routing

def show_user(request, username):
    return HttpResponse('show_user {}'.format(username))


urlpatterns = patterns(url(r'^users/(?P<username>[^/]+)$', show_user))

################################################################################
# Show we understand the keyword arguments to django.conf.urls.url

def kw_args(request):
    return HttpResponse('kw_args')

urlpatterns = [
    url(view=kw_args, regex=r'^kw_args$')
]

# Not an XSS sink, since the Content-Type is not "text/html"
# FP reported in https://github.com/github/codeql-python-team/issues/38
def fp_json_response(request):
    # implicitly sets Content-Type to "application/json"
    return JsonResponse({"foo": request.GET.get("foo")})

# Not an XSS sink, since the Content-Type is not "text/html"
def fp_manual_json_response(request):
    json_data = '{"json": "{}"}'.format(request.GET.get("foo"))
    return HttpResponse(json_data, content_type="application/json")

# Not an XSS sink, since the Content-Type is not "text/html"
def fp_manual_content_type(reuqest):
    return HttpResponse('<img src="0" onerror="alert(1)">', content_type="text/plain")

# XSS FP reported in https://github.com/github/codeql/issues/3466
# Note: This should be a open-redirect sink, but not a XSS sink.
def fp_redirect(request):
    return HttpResponseRedirect(request.GET.get("next"))

# Ensure that simple subclasses are still vuln to XSS
def tp_not_found(request):
    return HttpResponseNotFound(request.GET.get("name"))

# Ensure we still have a XSS sink when manually setting the content_type to HTML
def tp_manual_response_type(request):
    return HttpResponse(request.GET.get("name"), content_type="text/html; charset=utf-8")
