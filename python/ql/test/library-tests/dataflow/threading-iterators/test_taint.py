import threading


def serialized_taint():
    iterator = threading.serialize_iterator(TAINTED_LIST)
    ensure_tainted(iterator) # $ tainted
    ensure_tainted(next(iterator)) # $ tainted


def tee_taint():
    first, second = threading.concurrent_tee(TAINTED_LIST)
    ensure_tainted(first) # $ tainted
    ensure_tainted(second) # $ tainted
    ensure_tainted(next(first)) # $ tainted
    ensure_tainted(next(second)) # $ tainted


def nested_contents():
    iterator = threading.serialize_iterator([{"tainted": TAINTED_STRING, "clean": "safe"}])
    value = next(iterator)
    ensure_tainted(value["tainted"]) # $ tainted
    ensure_not_tainted(value["clean"])

    first, second = threading.concurrent_tee([{"tainted": TAINTED_STRING, "clean": "safe"}])
    value = next(second)
    ensure_tainted(value["tainted"]) # $ tainted
    ensure_not_tainted(value["clean"])


def count_is_not_data():
    copies = threading.concurrent_tee(["clean"], n=taint(2))
    ensure_not_tainted(next(copies[0]))
