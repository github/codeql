from rest_framework.decorators import api_view, parser_classes
from rest_framework.views import APIView
from rest_framework.viewsets import ModelViewSet
from rest_framework.request import Request
from rest_framework.response import Response
from rest_framework.parsers import JSONParser

from django.urls import path

ensure_tainted = ensure_not_tainted = print

# function based view
# see https://www.django-rest-framework.org/api-guide/views/#function-based-views


@api_view(["POST"])
@parser_classes([JSONParser])
def test_taint(request: Request, routed_param): # $ requestHandler routedParameter=routed_param
    ensure_tainted(routed_param) # $ tainted

    ensure_tainted(request) # $ tainted

    # Has all the standard attributes of a django HttpRequest
    # see https://github.com/encode/django-rest-framework/blob/00cd4ef864a8bf6d6c90819a983017070f9f08a5/rest_framework/request.py#L410-L418
    ensure_tainted(request.resolver_match.args) # $ tainted

    # special new attributes added, see https://www.django-rest-framework.org/api-guide/requests/
    ensure_tainted(
        request.data, # $ tainted
        request.data["key"], # $ tainted

        # alias for .GET
        request.query_params, # $ tainted
        request.query_params["key"], # $ tainted
        request.query_params.get("key"), # $ tainted
        request.query_params.getlist("key"), # $ tainted
        request.query_params.getlist("key")[0], # $ tainted
        request.query_params.pop("key"), # $ tainted
        request.query_params.pop("key")[0], # $ tainted

        # see more detailed tests of `request.user` below
        request.user, # $ tainted

        request.auth, # $ tainted

        # seems much more likely attack vector than .method, so included
        request.content_type, # $ tainted

        # file-like
        request.stream, # $ tainted
        request.stream.read(), # $ tainted
    )

    ensure_not_tainted(
        # although these could technically be user-controlled, it seems more likely to lead to FPs than interesting results.
        request.accepted_media_type,

        # In normal Django, if you disable CSRF middleware, you're allowed to use custom
        # HTTP methods, like `curl -X FOO <url>`.
        # However, with Django REST framework, doing that will yield:
        # `{"detail":"Method \"FOO\" not allowed."}`
        #
        # In the end, since we model a Django REST framework request entirely as a
        # extension of a Django request, we're not easily able to remove the taint from
        # `.method`.
        request.method, # $ SPURIOUS: tainted
    )

    # --------------------------------------------------------------------------
    # request.user
    # --------------------------------------------------------------------------
    #
    # This will normally be an instance of django.contrib.auth.models.User
    # (authenticated) so we assume that normally user-controlled fields such as
    # username/email is user-controlled, but that password isn't (since it's a hash).
    # see https://docs.djangoproject.com/en/3.2/ref/contrib/auth/#fields
    ensure_tainted(
        request.user.username, # $ tainted
        request.user.first_name, # $ tainted
        request.user.last_name, # $ tainted
        request.user.email, # $ tainted
    )
    ensure_not_tainted(request.user.password)

    return Response("ok") # $ HttpResponse


# class based view
# see https://www.django-rest-framework.org/api-guide/views/#class-based-views


class MyClass(APIView):
    def initial(self, request, *args, **kwargs): # $ requestHandler routedParameter=kwargs
        # this method will be called before processing any request
        ensure_tainted(request) # $ tainted

    def get(self, request: Request, routed_param): # $ requestHandler routedParameter=routed_param
        ensure_tainted(routed_param) # $ tainted

        # request taint is the same as in function_based_view above
        ensure_tainted(
            request, # $ tainted
            request.data # $ tainted
        )

        # same as for standard Django view
        ensure_tainted(self.args, self.kwargs) # $ tainted

        return Response("ok") # $ HttpResponse

# Viewsets
# see https://www.django-rest-framework.org/api-guide/viewsets/

class MyModelViewSet(ModelViewSet):
    def retrieve(self, request, routed_param): # $ requestHandler routedParameter=routed_param
        ensure_tainted(
            request, # $ tainted
            request.GET, # $ tainted
            request.GET.get("pk"), # $ tainted
            request.data # $ tainted
        )

        ensure_tainted(routed_param) # $ tainted

        # same as for standard Django view
        ensure_tainted(self.args, self.kwargs) # $ tainted

        return Response("retrieve") # $ HttpResponse


# fake setup, you can't actually run this
urlpatterns = [
    path("test-taint/<routed_param>", test_taint),  # $ routeSetup="test-taint/<routed_param>"
    path("ClassView/<routed_param>", MyClass.as_view()), # $ routeSetup="ClassView/<routed_param>"
    path("MyModelViewSet/<routed_param>", MyModelViewSet.as_view()) # $ routeSetup="MyModelViewSet/<routed_param>"
]

# tests with no route-setup, but we can still tell that these are using Django REST
# framework

@api_view(["POST"])
def function_based_no_route(request: Request, possible_routed_param): # $ requestHandler routedParameter=possible_routed_param
    ensure_tainted(
        request, # $ tainted
        possible_routed_param, # $ tainted
    )


class ClassBasedNoRoute(APIView):
    def get(self, request: Request, possible_routed_param): # $ requestHandler routedParameter=possible_routed_param
        ensure_tainted(request, possible_routed_param) # $ tainted
