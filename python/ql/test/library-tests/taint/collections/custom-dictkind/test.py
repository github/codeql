def test_custom_kind():
    # see CustomKinds.ql for explanation
    tainted_dict = TAINTED_DICT
    foo_dict = FOO_DICT
    bar_dict = BAR_DICT

    test(
        tainted_dict['key'],
        tainted_dict.get('key'),
        tainted_dict.foo,
        tainted_dict.bar,
    )

    test(
        foo_dict['key'],
        foo_dict.get('key'),
        foo_dict.foo,
        foo_dict.bar,
    )

    test(
        bar_dict['key'],
        bar_dict.get('key'),
        bar_dict.foo,
        bar_dict.bar,
    )
