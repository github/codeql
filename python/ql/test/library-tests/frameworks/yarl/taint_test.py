import yarl


url = yarl.URL(TAINTED_STRING)


ensure_tainted(
    url, # $ tainted

    # see https://yarl.readthedocs.io/en/stable/api.html#yarl.URL
    url.user, # $ tainted
    url.raw_user, # $ tainted

    url.password, # $ tainted
    url.raw_password, # $ tainted

    url.host, # $ tainted
    url.raw_host, # $ tainted

    url.port, # $ tainted
    url.explicit_port, # $ tainted

    url.authority, # $ tainted
    url.raw_authority, # $ tainted

    url.path, # $ tainted
    url.raw_path, # $ tainted

    url.path_qs, # $ tainted
    url.raw_path_qs, # $ tainted

    url.query_string, # $ tainted
    url.raw_query_string, # $ tainted

    url.fragment, # $ tainted
    url.raw_fragment, # $ tainted

    url.parts, # $ tainted
    url.raw_parts, # $ tainted

    url.name, # $ tainted
    url.raw_name, # $ tainted

    # multidict.MultiDictProxy[str]
    url.query, # $ tainted
    url.query.getone("key"), # $ tainted

    url.with_scheme("foo"), # $ tainted
    url.with_user("foo"), # $ tainted
    url.with_password("foo"), # $ tainted
    url.with_host("foo"), # $ tainted
    url.with_port("foo"), # $ tainted
    url.with_path("foo"), # $ tainted
    url.with_query({"foo": 42}), # $ tainted
    url.with_query(foo=42), # $ tainted
    url.update_query({"foo": 42}), # $ tainted
    url.update_query(foo=42), # $ tainted
    url.with_fragment("foo"), # $ tainted
    url.with_name("foo"), # $ tainted

    url.join(yarl.URL("wat.html")), # $ tainted

    url.human_repr(), # $ tainted
)
