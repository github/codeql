TAINTED_STRING = "TAINTED_STRING"
TAINTED_BYTES = b"TAINTED_BYTES"
TAINTED_LIST = ["tainted-{}".format(i) for i in range(5)]
TAINTED_DICT = {"name": TAINTED_STRING, "some key": "foo"}

NOT_TAINTED = "NOT_TAINTED"

def ensure_tainted(*args):
    print("- ensure_tainted")
    for i, arg in enumerate(args):
        print("arg {}: {!r}".format(i, arg))


def ensure_not_tainted(*args):
    print("- ensure_not_tainted")
    for i, arg in enumerate(args):
        print("arg {}: {!r}".format(i, arg))
