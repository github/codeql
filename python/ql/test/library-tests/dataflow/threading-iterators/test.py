import threading
from threading import concurrent_tee, serialize_iterator


def serialized_list():
    iterator = threading.serialize_iterator([SOURCE])
    SINK(next(iterator)) # $ flow="SOURCE, l:-1 -> next(..)"
    SINK_F(iterator)


def serialized_tuple():
    iterator = serialize_iterator(iterable=(SOURCE,))
    SINK(next(iterator)) # $ flow="SOURCE, l:-1 -> next(..)"


def serialized_set():
    wrap = serialize_iterator
    iterator = wrap({SOURCE})
    SINK(next(iterator)) # $ flow="SOURCE, l:-1 -> next(..)"


def serialized_generator():
    iterator = serialize_iterator(value for value in [SOURCE])
    for value in iterator:
        SINK(value) # $ flow="SOURCE, l:-2 -> value"


def serialized_contents():
    iterator = serialize_iterator([{"tainted": SOURCE, "clean": NONSOURCE}])
    value = next(iterator)
    SINK(value["tainted"]) # $ flow="SOURCE, l:-2 -> value['tainted']"
    SINK_F(value["clean"])


def serialized_callback():
    iterator = next(map(serialize_iterator, [[SOURCE]]))
    SINK(next(iterator)) # $ flow="SOURCE, l:-1 -> next(..)"


def tee_list():
    first, second = threading.concurrent_tee([SOURCE])
    SINK(next(first)) # $ flow="SOURCE, l:-1 -> next(..)"
    SINK(next(second)) # $ flow="SOURCE, l:-2 -> next(..)"
    SINK_F(first)


def tee_tuple():
    copies = concurrent_tee(iterable=(SOURCE,), n=3)
    SINK(next(copies[0])) # $ flow="SOURCE, l:-1 -> next(..)"
    SINK(next(copies[2])) # $ flow="SOURCE, l:-2 -> next(..)"


def tee_set():
    split = concurrent_tee
    first, second = split({SOURCE}, 2)
    SINK(next(first)) # $ flow="SOURCE, l:-1 -> next(..)"
    SINK(next(second)) # $ flow="SOURCE, l:-2 -> next(..)"


def tee_many():
    copies = concurrent_tee([SOURCE], n=10)
    SINK(next(copies[9])) # $ flow="SOURCE, l:-1 -> next(..)"
    SINK(next(copies[-1])) # $ flow="SOURCE, l:-2 -> next(..)"


def tee_generator():
    copies = concurrent_tee(value for value in [SOURCE])
    for iterator in copies:
        SINK(next(iterator)) # $ flow="SOURCE, l:-2 -> next(..)"


def tee_contents():
    first, second = concurrent_tee([{"tainted": SOURCE, "clean": NONSOURCE}])
    value = next(second)
    SINK(value["tainted"]) # $ flow="SOURCE, l:-2 -> value['tainted']"
    SINK_F(value["clean"])


def tee_callback():
    copies = next(map(concurrent_tee, [[SOURCE]]))
    SINK(next(copies[0])) # $ flow="SOURCE, l:-1 -> next(..)"


# The decorator form is already handled without a dedicated model.
@threading.synchronized_iterator
def decorated_generator(value):
    yield {"tainted": value, "clean": NONSOURCE}


def synchronized_generator():
    value = next(decorated_generator(SOURCE))
    SINK(value["tainted"]) # $ flow="SOURCE, l:-1 -> value['tainted']"
    SINK_F(value["clean"])


def clean_inputs():
    SINK_F(next(serialize_iterator([NONSOURCE])))
    SINK_F(next(concurrent_tee([NONSOURCE])[0]))
    SINK_F(next(concurrent_tee([NONSOURCE], n=SOURCE)[0]))


def shadowed_functions():
    def serialize_iterator(iterable):
        return iter([NONSOURCE])

    def concurrent_tee(iterable, n=2):
        return iter([NONSOURCE]), iter([NONSOURCE])

    SINK_F(next(serialize_iterator([SOURCE])))
    SINK_F(next(concurrent_tee([SOURCE])[0]))
