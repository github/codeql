# Inspired by https://docs.aiohttp.org/en/stable/web_quickstart.html
# and https://docs.aiohttp.org/en/stable/web_quickstart.html#resources-and-routes

from aiohttp import web


app = web.Application()


## ================================= ##
## Ways to specify routes / handlers ##
## ================================= ##

## Using coroutines
if True:

    # `app.add_routes` with list
    async def foo(request):  # $ requestHandler
        return web.Response(text="foo") # $ HttpResponse

    async def foo2(request):  # $ requestHandler
        return web.Response(text="foo2") # $ HttpResponse

    async def foo3(request):  # $ requestHandler
        return web.Response(text="foo3") # $ HttpResponse

    app.add_routes([
        web.get("/foo", foo),  # $ routeSetup="/foo"
        web.route("*", "/foo2", foo2), # $ routeSetup="/foo2"
        web.get(path="/foo3", handler=foo3), # $ routeSetup="/foo3"
    ])


    # using decorator
    routes = web.RouteTableDef()

    @routes.get("/bar")  # $ routeSetup="/bar"
    async def bar(request):  # $ requestHandler
        return web.Response(text="bar") # $ HttpResponse

    @routes.route("*", "/bar2")  # $ routeSetup="/bar2"
    async def bar2(request):  # $ requestHandler
        return web.Response(text="bar2") # $ HttpResponse

    @routes.get(path="/bar3")  # $ routeSetup="/bar3"
    async def bar3(request):  # $ requestHandler
        return web.Response(text="bar3") # $ HttpResponse

    app.add_routes(routes)


    # `app.router.add_get` / `app.router.add_route`
    async def baz(request):  # $ requestHandler
        return web.Response(text="baz") # $ HttpResponse

    app.router.add_get("/baz", baz)  # $ routeSetup="/baz"

    async def baz2(request):  # $ requestHandler
        return web.Response(text="baz2") # $ HttpResponse

    app.router.add_route("*", "/baz2", baz2)  # $ routeSetup="/baz2"

    async def baz3(request):  # $ requestHandler
        return web.Response(text="baz3") # $ HttpResponse

    app.router.add_get(path="/baz3", handler=baz3)  # $ routeSetup="/baz3"


## Using classes / views
if True:
    # see https://docs.aiohttp.org/en/stable/web_quickstart.html#organizing-handlers-in-classes

    class MyCustomHandlerClass:

        async def foo_handler(self, request):  # $ MISSING: requestHandler
            return web.Response(text="MyCustomHandlerClass.foo") # $ HttpResponse

    my_custom_handler = MyCustomHandlerClass()
    app.router.add_get("/MyCustomHandlerClass/foo", my_custom_handler.foo_handler)   # $ routeSetup="/MyCustomHandlerClass/foo"

    # Using `web.View`
    # ---------------

    # `app.add_routes` with list
    class MyWebView1(web.View):
        async def get(self):  # $ requestHandler
            return web.Response(text="MyWebView1.get") # $ HttpResponse

    app.add_routes([
        web.view("/MyWebView1", MyWebView1)   # $ routeSetup="/MyWebView1"
    ])


    # using decorator
    routes = web.RouteTableDef()

    @routes.view("/MyWebView2")  # $ routeSetup="/MyWebView2"
    class MyWebView2(web.View):
        async def get(self):  # $ requestHandler
            return web.Response(text="MyWebView2.get") # $ HttpResponse

    app.add_routes(routes)


    # `app.router.add_view`
    class MyWebView3(web.View):
        async def get(self):  # $ requestHandler
            return web.Response(text="MyWebView3.get") # $ HttpResponse

    app.router.add_view("/MyWebView3", MyWebView3)  # $ routeSetup="/MyWebView3"

    # no route-setup
    class MyWebViewNoRoute(web.View):
        async def get(self):  # $ requestHandler
            return web.Response(text="MyWebViewNoRoute.get") # $ HttpResponse

    if len(__name__) < 0: # avoid running, but fool analysis to not consider dead code
        # no explicit-view subclass (but route-setup)
        class MyWebViewNoSubclassButRoute(somelib.someclass):
            async def get(self):  # $ requestHandler
                return web.Response(text="MyWebViewNoSubclassButRoute.get") # $ HttpResponse

        app.router.add_view("/MyWebViewNoSubclassButRoute", MyWebViewNoSubclassButRoute)  # $ routeSetup="/MyWebViewNoSubclassButRoute"


# Apparently there is no enforcement that `add_view` is only for views, and vice-versa
# for `add_get` only being for async functions.
if True:
    async def no_rules(request): # $ requestHandler
        return web.Response(text="no_rules") # $ HttpResponse

    app.router.add_view("/no_rules", no_rules) # $ routeSetup="/no_rules"


    class NoRulesView(web.View):
        async def get(self):  # $ requestHandler
            return web.Response(text="NoRulesView.get") # $ HttpResponse

    app.router.add_get("/NoRulesView", NoRulesView) # $ routeSetup="/NoRulesView"


## =================== ##
## "Routed parameters" ##
## =================== ##

if True:
    # see https://docs.aiohttp.org/en/stable/web_quickstart.html#variable-resources

    async def matching(request: web.Request):  # $ requestHandler
        name = request.match_info['name']
        number = request.match_info['number']
        return web.Response(text="matching name={} number={}".format(name, number)) # $ HttpResponse

    app.router.add_get(r"/matching/{name}/{number:\d+}", matching)  # $ routeSetup="/matching/{name}/{number:\d+}"

## ======= ##
## subapps ##
## ======= ##

if True:
    subapp = web.Application()

    async def subapp_handler(request):  # $ requestHandler
        return web.Response(text="subapp_handler") # $ HttpResponse

    subapp.router.add_get("/subapp_handler", subapp_handler)  # $ routeSetup="/subapp_handler"

    app.add_subapp("/my_subapp", subapp)

    # similar behavior is possible with `app.add_domain`, but since I don't think we'll have special handling
    # for any kind of subapps, I have not created a test for this.


## ================================ ##
## Constructing UrlDispatcher first ##
## ================================ ##

if True:
    async def manual_dispatcher_instance(request):  # $ requestHandler
        return web.Response(text="manual_dispatcher_instance") # $ HttpResponse

    url_dispatcher = web.UrlDispatcher()
    url_dispatcher.add_get("/manual_dispatcher_instance", manual_dispatcher_instance)  # $ routeSetup="/manual_dispatcher_instance"

    subapp2 = web.Application(router=url_dispatcher)
    app.add_subapp("/manual_dispatcher_instance_app", subapp2)


## =========== ##
## Run the app ##
## =========== ##

if __name__ == "__main__":
    print("For auto-reloading server you can use:")
    print(f"aiohttp-devtools runserver {__file__}")
    print("after doing `pip install aiohttp-devtools`")
    print()

    web.run_app(app)
