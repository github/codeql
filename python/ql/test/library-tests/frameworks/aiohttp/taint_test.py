from aiohttp import web

async def test_taint(request: web.Request): # $ requestHandler

    ensure_tainted(
        request, # $ tainted

        # yarl.URL instances
        # https://yarl.readthedocs.io/en/stable/api.html#yarl.URL
        # see below
        request.url, # $ tainted
        request.rel_url, # $ tainted

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

        request.url.join(yarl.URL("wat.html")), # $ tainted

        request.url.human_repr(), # $ MISSING: tainted
    )


app = web.Application()
app.router.add_get(r"/test_taint/{name}/{number:\d+}", test_taint)  # $ routeSetup="/test_taint/{name}/{number:\d+}"


if __name__ == "__main__":
    web.run_app(app)
