import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import expects

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"


def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j


def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)


def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")

def test_as_binding():
    try:
        e_with_source = Exception()
        e_with_source.a = SOURCE
        raise e_with_source
    except* Exception as eg:
        SINK(eg.exceptions[0].a) # $ MISSING: flow

@expects(4)
def test_group():
    value_error_with_source = ValueError()
    value_error_with_source.a = SOURCE

    type_error_without_source = TypeError()
    type_error_without_source.a = NONSOURCE

    os_error_without_source = OSError()
    os_error_without_source.a = NONSOURCE

    eg = ExceptionGroup(
        "one",
        [
            type_error_without_source,
            ExceptionGroup(
                "two",
                    [type_error_without_source, value_error_with_source]
            ),
            ExceptionGroup(
                    "three",
                    [os_error_without_source]
            )
        ]
    )
    try:
        raise eg
    except* (TypeError, OSError) as es:
        # The matched sub-group, represented by `es` is filtered,
        # but the nesting is in place.
        SINK_F(es.exceptions[0].a)
        SINK_F(es.exceptions[1].exceptions[0].a)
        SINK_F(es.exceptions[2].exceptions[0].a)
    except* ValueError as es:
        # The matched sub-group, represented by `es` is filtered,
        # but the nesting is in place.
        # So the ValueError was originally found in
        # `eg.exceptions[1].exceptions[1].a`
        # but now it is found in
        # `es.exceptions[0].exceptions[0].a`
        SINK(es.exceptions[0].exceptions[0].a) # $ MISSING: flow
