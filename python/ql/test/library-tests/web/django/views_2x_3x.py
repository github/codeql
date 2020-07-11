"""testing views for Django 2.x and 3.x"""
from django.urls import path, re_path
from django.http import HttpResponse, HttpResponseRedirect, JsonResponse, HttpResponseNotFound
from django.views import View


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
    re_path(r'^url_match/(?P<foo>[^/]+)/(?P<bar>[^/]+)$', url_match_xss),
    re_path(r'^get_params$', get_params_xss),
    re_path(r'^post_params$', post_params_xss),
    re_path(r'^http_resp_write$', http_resp_write),
    re_path(r'^class_view/(?P<untrusted>.+)$', ClassView.as_view()),

    # one pattern to support `articles/page-<n>` and ensuring that articles/ goes to page-1
    re_path(r'articles/^(?:page-(?P<page_number>\d+)/)?$', show_articles),
    # passing as positional argument is not the recommended way of doing things, but it is certainly
    # possible
    re_path(r'^([^/]+)/(?:foo|bar)/([^/]+)$', xxs_positional_arg, name='xxs_positional_arg'),
]


# Show we understand the keyword arguments to from django.urls.re_path

def re_path_kwargs(request):
    return HttpResponse('re_path_kwargs')


urlpatterns = [
    re_path(view=re_path_kwargs, regex=r'^specifying-as-kwargs-is-not-a-problem$')
]

################################################################################
# Using path
################################################################################

# saying page_number is an externally controlled *string* is a bit strange, when we have an int converter :O
def page_number(request, page_number=1):
    return HttpResponse('page_number: {}'.format(page_number))

def foo_bar_baz(request, foo, bar, baz):
    return HttpResponse('foo_bar_baz: {} {} {}'.format(foo, bar, baz))

def path_kwargs(request, foo, bar):
    return HttpResponse('path_kwargs: {} {} {}'.format(foo, bar))

def not_valid_identifier(request):
    return HttpResponse('<foo!>')

urlpatterns = [
    path('articles/', page_number),
    path('articles/page-<int:page_number>', page_number),
    path('<int:foo>/<str:bar>/<baz>', foo_bar_baz, name='foo-bar-baz'),

    path(view=path_kwargs, route='<foo>/<bar>'),

    # We should not report there is a request parameter called `not_valid!`
    path('not_valid/<not_valid!>', not_valid_identifier),
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
