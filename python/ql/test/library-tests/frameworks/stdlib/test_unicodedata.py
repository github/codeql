import unicodedata
from unicodedata import iter_graphemes as graphemes


def string_iteration():
    for character in TAINTED_STRING:
        ensure_tainted(character) # $ tainted


def grapheme_iteration():
    iterator = unicodedata.iter_graphemes(TAINTED_STRING)
    ensure_tainted(iterator) # $ tainted
    for grapheme in iterator:
        ensure_tainted(grapheme) # $ tainted
        ensure_tainted(str(grapheme)) # $ tainted
        ensure_not_tainted(grapheme.start, grapheme.end)


def next_grapheme():
    grapheme = next(unicodedata.iter_graphemes(TAINTED_STRING))
    ensure_tainted(str(grapheme)) # $ tainted


def bounded_iteration():
    for grapheme in unicodedata.iter_graphemes(TAINTED_STRING, 1, 10):
        ensure_tainted(str(grapheme)) # $ tainted


def aliases():
    ensure_tainted(str(next(graphemes(TAINTED_STRING)))) # $ tainted
    split = unicodedata.iter_graphemes
    ensure_tainted(str(next(split(TAINTED_STRING)))) # $ tainted


def callback():
    iterator = next(map(unicodedata.iter_graphemes, [TAINTED_STRING]))
    ensure_tainted(str(next(iterator))) # $ tainted


def clean_inputs():
    start, end = 0, 10
    taint(start, end)
    iterator = unicodedata.iter_graphemes("a\u0301bc", start, end)
    ensure_not_tainted(iterator)
    for grapheme in iterator:
        ensure_not_tainted(str(grapheme))
    ensure_not_tainted(str(next(graphemes("clean"))))


def shadowed_function():
    def iter_graphemes(unistr):
        return iter(["clean"])

    ensure_not_tainted(str(next(iter_graphemes(TAINTED_STRING))))
