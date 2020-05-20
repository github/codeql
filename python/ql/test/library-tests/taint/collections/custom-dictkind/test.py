def test_custom_kind():
    # see Taint.qll for explanation
    tainted_dict = TAINTED_DICT
    foo_dict = FOO_DICT
    bar_dict = BAR_DICT

    ensure_tainted(
        tainted_dict['key'],
        tainted_dict.get('key'),
    )
    ensure_not_tainted(
        tainted_dict.foo,
        tainted_dict.bar,
    )

    ensure_tainted(
        foo_dict['key'],
        foo_dict.get('key'),
        foo_dict.foo,
    )
    ensure_not_tainted(
        foo_dict.bar,
    )

    ensure_tainted(
        bar_dict['key'],
        bar_dict.get('key'),
        bar_dict.bar,
    )
    ensure_not_tainted(
        bar_dict.foo,
    )

def test_attr_based():
    """representing a dictionary where `dict.key` is the same as `dict['key']` -- bottle.FormsDict"""
    attr_files = ATTR_BASED_FILES
    attr_strings = ATTR_BASED_STRINGS

    ensure_tainted(
        attr_files['key'],
        attr_files.key,
    )

    ensure_tainted(
        attr_strings['key'],
        attr_strings.key,
    )
