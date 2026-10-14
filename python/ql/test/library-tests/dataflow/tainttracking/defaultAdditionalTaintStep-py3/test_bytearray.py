# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import TAINTED_BYTES, TAINTED_STRING, ensure_tainted, ensure_not_tainted, taint


def constructors():
    import builtins
    from builtins import bytearray as make_buffer

    ensure_tainted(
        bytearray(TAINTED_BYTES), # $ tainted
        bytearray(source=TAINTED_BYTES), # $ tainted
        bytearray(TAINTED_STRING, "utf-8"), # $ tainted
        bytearray(source=TAINTED_STRING, encoding="utf-8"), # $ tainted
        builtins.bytearray(TAINTED_BYTES), # $ tainted
        make_buffer(TAINTED_BYTES), # $ tainted
    )
    ensure_not_tainted(bytearray(b"safe"))


def shadowed_constructor():
    def bytearray(source):
        return b"safe"

    ensure_not_tainted(bytearray(TAINTED_BYTES))


def take_bytes():
    ensure_tainted(
        bytearray(TAINTED_BYTES).take_bytes(), # $ tainted
        bytearray(TAINTED_BYTES).take_bytes(None), # $ tainted
        bytearray(source=TAINTED_STRING, encoding="utf-8").take_bytes().decode(), # $ tainted
        bytearray.take_bytes(bytearray(TAINTED_BYTES)), # $ tainted
    )

    buffer = bytearray(TAINTED_BYTES)
    take = buffer.take_bytes
    ensure_tainted(take()) # $ tainted

    ensure_not_tainted(bytearray(b"safe").take_bytes())
    ensure_not_tainted(bytearray().take_bytes())


def take_partial_bytes():
    buffer = bytearray(TAINTED_BYTES)
    ensure_tainted(buffer.take_bytes(1)) # $ tainted
    ensure_tainted(buffer) # $ tainted
    ensure_tainted(buffer.take_bytes(-1)) # $ tainted
    ensure_tainted(buffer) # $ tainted

    size = 1
    taint(size)
    ensure_not_tainted(bytearray(b"safe").take_bytes(size))


def empty_results():
    buffer = bytearray(TAINTED_BYTES)
    # Whole-buffer taint does not distinguish empty slices.
    ensure_not_tainted(buffer[:0]) # $ SPURIOUS: tainted
    ensure_not_tainted(buffer.take_bytes(0)) # $ SPURIOUS: tainted


def consumed_buffer():
    buffer = bytearray(b"abc")
    taint(buffer)
    result = buffer.take_bytes()
    ensure_tainted(result) # $ tainted

    # Whole-buffer taint is not removed when the buffer is emptied.
    ensure_not_tainted(buffer) # $ SPURIOUS: tainted
    ensure_not_tainted(buffer.take_bytes()) # $ SPURIOUS: tainted


def cleared_buffer():
    buffer = bytearray(b"abc")
    taint(buffer)
    buffer.clear()
    ensure_not_tainted(buffer) # $ SPURIOUS: tainted


constructors()
shadowed_constructor()
cleared_buffer()
if sys.version_info >= (3, 15):
    take_bytes()
    take_partial_bytes()
    empty_results()
    consumed_buffer()
