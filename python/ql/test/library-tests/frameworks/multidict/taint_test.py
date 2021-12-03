import multidict

# TODO: This is an invalid MultiDictProxy construction... but for the purpose of
# taint-test, this should be good enough.
mdp = multidict.MultiDictProxy(TAINTED_STRING)

ensure_tainted(
    # see https://multidict.readthedocs.io/en/stable/multidict.html#multidict.MultiDictProxy

    mdp, # $ tainted
    mdp["key"], # $ tainted
    mdp.get("key"), # $ tainted
    mdp.getone("key"), # $ tainted
    mdp.getall("key"), # $ tainted
    mdp.keys(), # $ MISSING: tainted
    mdp.values(), # $ tainted
    mdp.items(), # $ tainted
    mdp.copy(), # $ tainted
    list(mdp), # $ tainted
    iter(mdp), # $ tainted
)

# TODO: This is an invalid CIMultiDictProxy construction... but for the purpose of
# taint-test, this should be good enough.
ci_mdp = multidict.CIMultiDictProxy(TAINTED_STRING)

ensure_tainted(
    # see https://multidict.readthedocs.io/en/stable/multidict.html#multidict.CIMultiDictProxy

    ci_mdp, # $ tainted
    ci_mdp["key"], # $ tainted
    ci_mdp.get("key"), # $ tainted
    ci_mdp.getone("key"), # $ tainted
    ci_mdp.getall("key"), # $ tainted
    ci_mdp.keys(), # $ MISSING: tainted
    ci_mdp.values(), # $ tainted
    ci_mdp.items(), # $ tainted
    ci_mdp.copy(), # $ tainted
    list(ci_mdp), # $ tainted
    iter(ci_mdp), # $ tainted
)
