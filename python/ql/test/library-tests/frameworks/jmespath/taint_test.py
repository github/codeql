import jmespath

def test_taint():
    untrusted_data = TAINTED_DICT

    safe_expression = jmespath.compile("foo.bar")

    ensure_tainted(
        jmespath.search("foo.bar", untrusted_data), # $ tainted
        jmespath.search("foo.bar", data=untrusted_data), # $ tainted

        safe_expression.search(untrusted_data), # $ tainted
        safe_expression.search(value=untrusted_data) # $ tainted
    )

    # since ```jmespath.search("{wat: `foo`}", {})``` works (and outputs a dictionary),
    # we _could_ add a taint-step from the search expression to the output. However, it
    # seems more likely to lead to FPs than good results, so these have deliberately not
    # been included.

    ts = TAINTED_STRING
    safe_data = {"foo": "bar"}

    unsafe_expression = jmespath.compile(ts)

    ensure_not_tainted(
        jmespath.search(ts, safe_data),
        jmespath.search(expression=ts, data=safe_data),

        unsafe_expression,
        unsafe_expression.search(safe_data),
        unsafe_expression.search(value=safe_data),
    )
