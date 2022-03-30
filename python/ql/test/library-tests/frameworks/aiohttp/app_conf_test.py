"""
This file is a test of an extra data-flow step that we want to have for
aiohttp.web.Application

We don't really have an established way to test extra data-flow steps in external
libraries right now, so for now I've just used our normal taint-flow testing ¯\_(ツ)_/¯

see https://docs.aiohttp.org/en/stable/web_advanced.html#application-s-config
"""

from aiohttp import web

# to make code runable
TAINTED_STRING = "TAINTED_STRING"
def ensure_tainted(*args, **kwargs):
    pass

ensure_tainted(
    TAINTED_STRING # $ tainted
)


async def example(request: web.Request): # $ requestHandler
    return web.Response(text=f'example {request.app["foo"]=}') # $ HttpResponse


async def also_works(request: web.Request): # $ requestHandler
    return web.Response(text=f'also_works {request.config_dict["foo"]=}') # $ HttpResponse


async def taint_test(request: web.Request): # $ requestHandler
    ensure_tainted(
        request.app["ts"], # $ MISSING: tainted
        request.config_dict["ts"], # $ MISSING: tainted
    )
    return web.Response(text="ok") # $ HttpResponse


app = web.Application()
app.router.add_get("", example) # $ routeSetup=""
app.router.add_get("/also-works", also_works) # $ routeSetup="/also-works"
app.router.add_get("/taint-test", taint_test) # $ routeSetup="/taint-test"
app["foo"] = 42
app["ts"] = TAINTED_STRING


if __name__ == "__main__":
    web.run_app(app)
