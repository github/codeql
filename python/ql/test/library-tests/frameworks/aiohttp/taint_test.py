from aiohttp import web

async def test_taint(request: web.Request): # $ requestHandler

    ensure_tainted(
        request, # $ tainted

        # yarl.URL instances, see tests under `yarl` framework tests
        # https://yarl.readthedocs.io/en/stable/api.html#yarl.URL
        request.url, # $ tainted
        request.url.human_repr(), # $ tainted
        request.rel_url, # $ tainted
        request.rel_url.human_repr(), # $ tainted

        request.forwarded, # $ tainted

        request.host, # $ tainted
        request.remote, # $ tainted
        request.path, # $ tainted
        request.path_qs, # $ tainted
        request.raw_path, # $ tainted

        # dict-like for captured parts of the URL
        request.match_info, # $ tainted
        request.match_info["key"], # $ tainted
        request.match_info.get("key"), # $ tainted

        # multidict.MultiDictProxy[str]
        # see https://multidict.readthedocs.io/en/stable/multidict.html#multidict.MultiDictProxy
        # TODO: Should have a better way to capture that we in fact _do_ model this as a
        # an instance of the right class, and have the actual taint_test for that in a
        # different file!
        request.query, # $ tainted
        request.query["key"], # $ tainted
        request.query.get("key"), # $ tainted
        request.query.getone("key"), # $ tainted
        request.query.getall("key"), # $ tainted
        request.query.keys(), # $ MISSING: tainted
        request.query.values(), # $ tainted
        request.query.items(), # $ tainted
        request.query.copy(), # $ tainted
        list(request.query), # $ tainted
        iter(request.query), # $ tainted

        # multidict.CIMultiDictProxy[str]
        # see https://multidict.readthedocs.io/en/stable/multidict.html#multidict.CIMultiDictProxy
        # TODO: Should have a better way to capture that we in fact _do_ model this as a
        # an instance of the right class, and have the actual taint_test for that in a
        # different file!
        request.headers, # $ tainted
        request.headers.getone("key"), # $ tainted

        # https://docs.python.org/3/library/asyncio-protocol.html#asyncio-transport
        # TODO
        request.transport, # $ tainted
        request.transport.get_extra_info("key"), # $ MISSING: tainted

        # dict-like (readonly)
        request.cookies, # $ tainted
        request.cookies["key"], # $ tainted
        request.cookies.get("key"), # $ tainted
        request.cookies.keys(), # $ MISSING: tainted
        request.cookies.values(), # $ tainted
        request.cookies.items(), # $ tainted
        list(request.cookies), # $ tainted
        iter(request.cookies), # $ tainted


        # aiohttp.StreamReader
        # see https://docs.aiohttp.org/en/stable/streams.html#aiohttp.StreamReader
        # TODO
        request.content, # $ tainted
        request._payload, # $ tainted

        request.content_type, # $ tainted
        request.charset, # $ tainted

        request.http_range, # $ tainted

        # Optional[datetime]
        request.if_modified_since, # $ tainted
        request.if_unmodified_since, # $ tainted
        request.if_range, # $ tainted

        request.clone(scheme="https"), # $ tainted

        # TODO: like request.transport.get_extra_info
        request.get_extra_info("key"), # $ tainted

        # bytes
        await request.read(), # $ tainted

        # str
        await request.text(), # $ tainted

        # obj
        await request.json(), # $ tainted

        # aiohttp.multipart.MultipartReader
        await request.multipart(), # $ tainted

        # multidict.MultiDictProxy[str]
        await request.post(), # $ tainted
        (await request.post()).getone("key"), # $ MISSING: tainted
    )

    import yarl
    assert isinstance(request.url, yarl.URL)
    assert isinstance(request.rel_url, yarl.URL)


    # things that are technically controlled by sender of request,
    # but doesn't seem that likely for exploitation.
    ensure_not_tainted(
        request.method,
        request.version,
        request.scheme,
        request.secure,
        request.keep_alive,

        request.content_length,
        request.body_exists,
        request.has_body,
        request.can_read_body,
    )

    ensure_not_tainted(
        request.loop,

        request.app,
        request.config_dict,
    )


class TaintTestClass(web.View):
    def get(self): # $ requestHandler
        ensure_tainted(
            self.request, # $ tainted
            self.request.url # $ tainted
        )


app = web.Application()
app.router.add_get(r"/test_taint/{name}/{number:\d+}", test_taint)  # $ routeSetup="/test_taint/{name}/{number:\d+}"
app.router.add_view(r"/test_taint_class", TaintTestClass)  # $ routeSetup="/test_taint_class"


if __name__ == "__main__":
    web.run_app(app)
