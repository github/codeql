from aiohttp import web

async def test_taint(request: web.Request): # $ requestHandler

    ensure_tainted(
        request, # $ tainted

        # yarl.URL instances
        # https://yarl.readthedocs.io/en/stable/api.html#yarl.URL
        # see below
        request.url, # $ MISSING: tainted
        request.rel_url, # $ MISSING: tainted

        request.forwarded, # $ MISSING: tainted

        request.host, # $ MISSING: tainted
        request.remote, # $ MISSING: tainted
        request.path, # $ MISSING: tainted
        request.path_qs, # $ MISSING: tainted
        request.raw_path, # $ MISSING: tainted

        # multidict.MultiDictProxy[str]
        # see https://multidict.readthedocs.io/en/stable/multidict.html#multidict.MultiDictProxy
        # TODO: Should have a better way to capture that we in fact _do_ model this as a
        # an instance of the right class, and have the actual taint_test for that in a
        # different file!
        request.query, # $ MISSING: tainted
        request.query["key"], # $ MISSING: tainted
        request.query.get("key"), # $ MISSING: tainted
        request.query.getone("key"), # $ MISSING: tainted
        request.query.getall("key"), # $ MISSING: tainted
        request.query.keys(), # $ MISSING: tainted
        request.query.values(), # $ MISSING: tainted
        request.query.items(), # $ MISSING: tainted
        request.query.copy(), # $ MISSING: tainted
        list(request.query), # $ MISSING: tainted
        iter(request.query), # $ MISSING: tainted

        # multidict.CIMultiDictProxy[str]
        # see https://multidict.readthedocs.io/en/stable/multidict.html#multidict.CIMultiDictProxy
        # TODO: Should have a better way to capture that we in fact _do_ model this as a
        # an instance of the right class, and have the actual taint_test for that in a
        # different file!
        request.headers, # $ MISSING: tainted
        request.query.getone("key"), # $ MISSING: tainted

        # https://docs.python.org/3/library/asyncio-protocol.html#asyncio-transport
        # TODO
        request.transport, # $ MISSING: tainted
        request.transport.get_extra_info("key"), # $ MISSING: tainted

        # dict-like (readonly)
        request.cookies, # $ MISSING: tainted
        request.cookies["key"], # $ MISSING: tainted
        request.cookies.get("key"), # $ MISSING: tainted
        request.cookies.keys(), # $ MISSING: tainted
        request.cookies.values(), # $ MISSING: tainted
        request.cookies.items(), # $ MISSING: tainted
        list(request.cookies), # $ MISSING: tainted
        iter(request.cookies), # $ MISSING: tainted


        # aiohttp.StreamReader
        # see https://docs.aiohttp.org/en/stable/streams.html#aiohttp.StreamReader
        # TODO
        request.content, # $ MISSING: tainted
        request._payload, # $ MISSING: tainted

        request.body_exists, # $ MISSING: tainted
        request.has_body, # $ MISSING: tainted

        request.content_type, # $ MISSING: tainted
        request.charset, # $ MISSING: tainted

        request.http_range, # $ MISSING: tainted

        # Optional[datetime]
        request.if_modified_since, # $ MISSING: tainted
        request.if_unmodified_since, # $ MISSING: tainted
        request.if_range, # $ MISSING: tainted

        request.clone(scheme="https"), # $ MISSING: tainted

        # TODO: like request.transport.get_extra_info
        request.get_extra_info("key"), # $ MISSING: tainted

        # bytes
        await request.read(), # $ MISSING: tainted

        # str
        await request.text(), # $ MISSING: tainted

        # obj
        await request.json(), # $ MISSING: tainted

        # aiohttp.multipart.MultipartReader
        await request.multipart(), # $ MISSING: tainted

        # multidict.MultiDictProxy[str]
        await request.post(), # $ MISSING: tainted
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
    )

    ensure_not_tainted(
        request.loop,

        request.match_info,
        request.app,
        request.config_dict,
    )

    # TODO: Should have a better way to capture that we in fact _do_ model this as a
    # an instance of the right class, and have the actual taint_test for that in a
    # different file!
    import yarl

    ensure_tainted(
        request.url.user, # $ MISSING: tainted
        request.url.raw_user, # $ MISSING: tainted

        request.url.password, # $ MISSING: tainted
        request.url.raw_password, # $ MISSING: tainted

        request.url.host, # $ MISSING: tainted
        request.url.raw_host, # $ MISSING: tainted

        request.url.port, # $ MISSING: tainted
        request.url.explicit_port, # $ MISSING: tainted

        request.url.authority, # $ MISSING: tainted
        request.url.raw_authority, # $ MISSING: tainted

        request.url.path, # $ MISSING: tainted
        request.url.raw_path, # $ MISSING: tainted

        request.url.path_qs, # $ MISSING: tainted
        request.url.raw_path_qs, # $ MISSING: tainted

        request.url.query_string, # $ MISSING: tainted
        request.url.raw_query_string, # $ MISSING: tainted

        request.url.fragment, # $ MISSING: tainted
        request.url.raw_fragment, # $ MISSING: tainted

        request.url.parts, # $ MISSING: tainted
        request.url.raw_parts, # $ MISSING: tainted

        request.url.name, # $ MISSING: tainted
        request.url.raw_name, # $ MISSING: tainted

        # multidict.MultiDictProxy[str]
        request.url.query, # $ MISSING: tainted
        request.url.query.getone("key"), # $ MISSING: tainted

        request.url.with_scheme("foo"), # $ MISSING: tainted
        request.url.with_user("foo"), # $ MISSING: tainted
        request.url.with_password("foo"), # $ MISSING: tainted
        request.url.with_host("foo"), # $ MISSING: tainted
        request.url.with_port("foo"), # $ MISSING: tainted
        request.url.with_path("foo"), # $ MISSING: tainted
        request.url.with_query({"foo": 42}), # $ MISSING: tainted
        request.url.with_query(foo=42), # $ MISSING: tainted
        request.url.update_query({"foo": 42}), # $ MISSING: tainted
        request.url.update_query(foo=42), # $ MISSING: tainted
        request.url.with_fragment("foo"), # $ MISSING: tainted
        request.url.with_name("foo"), # $ MISSING: tainted

        request.url.join(yarl.URL("wat.html")), # $ MISSING: tainted

        request.url.human_repr(), # $ MISSING: tainted
    )


app = web.Application()
app.router.add_get(r"/test_taint/{name}/{number:\d+}", test_taint)  # $ routeSetup="/test_taint/{name}/{number:\d+}"


if __name__ == "__main__":
    web.run_app(app)
