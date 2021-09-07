"""testing views for Django 2.x and 3.x"""
from django.urls import path
from django.http import HttpRequest
from django.views import View


def test_taint(request: HttpRequest, foo, bar, baz=None):  # $requestHandler routedParameter=foo routedParameter=bar
    ensure_tainted(foo, bar) # $ tainted
    ensure_not_tainted(baz)

    # Manually inspected all fields of the HttpRequest object
    # https://docs.djangoproject.com/en/3.0/ref/request-response/#httprequest-objects

    import django.urls
    django.urls.ResolverMatch

    ensure_tainted(
        request, # $ tainted

        request.body, # $ tainted
        request.path, # $ tainted
        request.path_info, # $ tainted

        # With CSRF middleware disabled, it's possible to use custom methods,
        # for example by `curl -X FOO <url>`
        request.method, # $ tainted

        request.encoding, # $ tainted
        request.content_type, # $ tainted

        # Dict[str, str]
        request.content_params, # $ tainted
        request.content_params["key"], # $ tainted
        request.content_params.get("key"), # $ tainted

        # django.http.QueryDict
        # see https://docs.djangoproject.com/en/3.0/ref/request-response/#querydict-objects
        request.GET, # $ tainted
        request.GET["key"], # $ tainted
        request.GET.get("key"), # $ tainted
        request.GET.getlist("key"), # $ tainted
        request.GET.getlist("key")[0], # $ tainted
        request.GET.pop("key"), # $ tainted
        request.GET.pop("key")[0], # $ tainted
        # key
        request.GET.popitem()[0], # $ tainted
        # values
        request.GET.popitem()[1], # $ tainted
        # values[0]
        request.GET.popitem()[1][0], # $ tainted
        request.GET.lists(), # $ tainted
        request.GET.dict(), # $ tainted
        request.GET.dict()["key"], # $ tainted
        request.GET.urlencode(), # $ tainted

        # django.http.QueryDict (same as above, did not duplicate tests)
        request.POST, # $ tainted

        # Dict[str, str]
        request.COOKIES, # $ tainted
        request.COOKIES["key"], # $ tainted
        request.COOKIES.get("key"), # $ tainted

        # MultiValueDict[str, UploadedFile]
        request.FILES, # $ tainted
        request.FILES["key"], # $ tainted
        request.FILES["key"].content_type, # $ tainted
        request.FILES["key"].content_type_extra, # $ tainted
        request.FILES["key"].content_type_extra["key"], # $ tainted
        request.FILES["key"].charset, # $ tainted
        request.FILES["key"].name, # $ tainted
        request.FILES["key"].file, # $ tainted
        request.FILES["key"].file.read(), # $ tainted

        request.FILES.get("key"), # $ tainted
        request.FILES.get("key").name, # $ tainted
        request.FILES.getlist("key"), # $ tainted
        request.FILES.getlist("key")[0], # $ tainted
        request.FILES.getlist("key")[0].name, # $ tainted
        request.FILES.dict(), # $ tainted
        request.FILES.dict()["key"], # $ tainted
        request.FILES.dict()["key"].name, # $ tainted
        request.FILES.dict().get("key").name, # $ tainted

        # Dict[str, Any]
        request.META, # $ tainted
        request.META["HTTP_USER_AGENT"], # $ tainted
        request.META.get("HTTP_USER_AGENT"), # $ tainted

        # HttpHeaders (case insensitive dict-like)
        request.headers, # $ tainted
        request.headers["user-agent"], # $ tainted
        request.headers["USER_AGENT"], # $ tainted

        # django.urls.ResolverMatch
        request.resolver_match, # $ tainted
        request.resolver_match.args, # $ tainted
        request.resolver_match.args[0], # $ tainted
        request.resolver_match.kwargs, # $ tainted
        request.resolver_match.kwargs["key"], # $ tainted

        request.get_full_path(), # $ tainted
        request.get_full_path_info(), # $ tainted
        # build_absolute_uri handled below
        # get_signed_cookie handled below

        request.read(), # $ tainted
        request.readline(), # $ tainted
        request.readlines(), # $ tainted
        request.readlines()[0], # $ tainted
        [line for line in request], # $ tainted
    )

    # django.urls.ResolverMatch also supports iterable unpacking
    _view, args, kwargs = request.resolver_match
    ensure_tainted(
        args, # $ tainted
        args[0], # $ tainted
        kwargs, # $ tainted
        kwargs["key"], # $ tainted
    )

    ensure_not_tainted(
        request.current_app,

        # Django has `ALLOWED_HOSTS` to ensure the HOST value cannot be tampered with.
        # It is possible to remove this protection, but it seems reasonable to assume
        # people don"t do this by default.
        request.get_host(),
        request.get_port(),
    )

    ####################################
    # build_absolute_uri
    ####################################
    ensure_tainted(
        request.build_absolute_uri(), # $ tainted
        request.build_absolute_uri(request.GET["key"]), # $ tainted
        request.build_absolute_uri(location=request.GET["key"]), # $ tainted
    )
    ensure_not_tainted(
        request.build_absolute_uri("/hardcoded/"),
        request.build_absolute_uri("https://example.com"),
    )

    ####################################
    # get_signed_cookie
    ####################################
    # We don't consider user to be able to tamper with cookies that are signed
    ensure_not_tainted(
        request.get_signed_cookie("key"),
        request.get_signed_cookie("key", salt="salt"),
        request.get_signed_cookie("key", max_age=60),
    )
    # However, providing tainted default value might result in taint
    ensure_tainted(
        request.get_signed_cookie("key", request.COOKIES["key"]), # $ MISSING: tainted
        request.get_signed_cookie("key", default=request.COOKIES["key"]), # $ MISSING: tainted
    )


class ClassView(View):
    def some_method(self):
        ensure_tainted(
            self.request, # $ tainted
            self.request.GET["key"], # $ tainted

            self.args, # $ tainted
            self.args[0], # $ tainted

            self.kwargs, # $ tainted
            self.kwargs["key"], # $ tainted
        )


# fake setup, you can't actually run this
urlpatterns = [
    path("test-taint/<foo>/<bar>", test_taint),  # $ routeSetup="test-taint/<foo>/<bar>"
    path("ClassView/", ClassView.as_view()), # $ routeSetup="ClassView/"
]
