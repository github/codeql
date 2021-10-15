from aiohttp import web


routes = web.RouteTableDef()


@routes.get("/raw_text") # $ routeSetup="/raw_text"
async def raw_text(request): # $ requestHandler
    return web.Response(text="foo") # $ HttpResponse mimetype=text/plain responseBody="foo"


@routes.get("/raw_body") # $ routeSetup="/raw_body"
async def raw_body(request): # $ requestHandler
    return web.Response(body=b"foo") # $ HttpResponse mimetype=application/octet-stream responseBody=b"foo"


@routes.get("/html_text") # $ routeSetup="/html_text"
async def html_text(request): # $ requestHandler
    return web.Response(text="foo", content_type="text/html") # $ HttpResponse mimetype=text/html responseBody="foo"


@routes.get("/html_body") # $ routeSetup="/html_body"
async def html_body(request): # $ requestHandler
    return web.Response(body=b"foo", content_type="text/html") # $ HttpResponse mimetype=text/html responseBody=b"foo"


@routes.get("/html_body_set_later") # $ routeSetup="/html_body_set_later"
async def html_body_set_later(request): # $ requestHandler
    resp = web.Response(body=b"foo") # $ HttpResponse mimetype=application/octet-stream responseBody=b"foo"
    resp.content_type = "text/html" # $ MISSING: mimetype=text/html
    return resp

# Each HTTP status code has an exception
# see https://docs.aiohttp.org/en/stable/web_quickstart.html#exceptions

@routes.get("/through_200_exception") # $ routeSetup="/through_200_exception"
async def through_200_exception(request): # $ requestHandler
    raise web.HTTPOk(text="foo") # $ HttpResponse mimetype=text/plain responseBody="foo"


@routes.get("/through_200_exception_html") # $ routeSetup="/through_200_exception_html"
async def through_200_exception(request): # $ requestHandler
    exception = web.HTTPOk(text="foo") # $ HttpResponse mimetype=text/plain responseBody="foo"
    exception.content_type = "text/html" # $ MISSING: mimetype=text/html
    raise exception


@routes.get("/through_404_exception") # $ routeSetup="/through_404_exception"
async def through_404_exception(request): # $ requestHandler
    raise web.HTTPNotFound(text="foo") # $ HttpResponse mimetype=text/plain responseBody="foo"


@routes.get("/redirect_301") # $ routeSetup="/redirect_301"
async def redirect_301(request): # $ requestHandler
    if not "kwarg" in request.url.query:
        raise web.HTTPMovedPermanently("/login") # $ HttpResponse HttpRedirectResponse mimetype=application/octet-stream redirectLocation="/login"
    else:
        raise web.HTTPMovedPermanently(location="/logout") # $ HttpResponse HttpRedirectResponse mimetype=application/octet-stream redirectLocation="/logout"


@routes.get("/redirect_302") # $ routeSetup="/redirect_302"
async def redirect_302(request): # $ requestHandler
    if not "kwarg" in request.url.query:
        raise web.HTTPFound("/login") # $ HttpResponse HttpRedirectResponse mimetype=application/octet-stream redirectLocation="/login"
    else:
        raise web.HTTPFound(location="/logout") # $ HttpResponse HttpRedirectResponse mimetype=application/octet-stream redirectLocation="/logout"

################################################################################
# Cookies
################################################################################

@routes.get("/setting_cookie") # $ routeSetup="/setting_cookie"
async def setting_cookie(request): # $ requestHandler
    resp = web.Response(text="foo") # $ HttpResponse mimetype=text/plain responseBody="foo"
    resp.cookies["key"] = "value" # $ CookieWrite CookieName="key" CookieValue="value"
    resp.headers["Set-Cookie"] = "key2=value2" # $ MISSING: CookieWrite CookieRawHeader="key2=value2"
    resp.set_cookie("key3", "value3") # $ CookieWrite CookieName="key3" CookieValue="value3"
    resp.set_cookie(name="key3", value="value3") # $ CookieWrite CookieName="key3" CookieValue="value3"
    resp.del_cookie("key4") # $ CookieWrite CookieName="key4"
    return resp


if __name__ == "__main__":
    app = web.Application()
    app.add_routes(routes)
    web.run_app(app)
