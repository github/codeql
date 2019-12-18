from django.conf.urls import patterns, url
from django.http.response import HttpResponse
from django.views.generic import View


def url_match_xss(request, foo, bar, no_taint=None):
    return HttpResponse('url_match_xss: {} {}'.format(foo, bar))


def get_params_xss(request):
    return HttpResponse(request.GET.get("untrusted"))


def post_params_xss(request):
    return HttpResponse(request.POST.get("untrusted"))


class Foo(object):
    # Note: since Foo is used as the super type in a class view, it will be able to handle requests.

    # TODO: Currently we don't flag `untrusted` as a DjangoRequestParameter
    def post(self, request, untrusted):
        return HttpResponse('Foo post: {}'.format(untrusted))


class ClassView(View, Foo):
    # TODO: Currently we don't flag `untrusted` as a DjangoRequestParameter
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
    url(r'^class_view/(?P<untrusted>.+)$', ClassView.as_view()),

    # one pattern to support `articles/page-<n>` and ensuring that articles/ goes to page-1
    url(r'articles/^(?:page-(?P<page_number>\d+)/)?$', show_articles),
    # passing as positional argument is not the recommended way of doing things, but it is certainly
    # possible
    url(r'^([^/]+)/(?:foo|bar)/([^/]+)$', xxs_positional_arg, name='xxs_positional_arg'),
]


# Using patterns() for routing

def show_user(request, username):
    pass


urlpatterns = patterns(url(r'^users/(?P<username>[^/]+)$', show_user))


# Show we understand the keyword arguments to django.conf.urls.url

def we_understand_url_kwargs(request):
    pass


urlpatterns = [
    url(view=we_understand_url_kwargs, regex=r'^specifying-as-kwargs-is-not-a-problem$')
]
