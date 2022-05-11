# Add taintlib to PATH so it can be imported during runtime without any hassle
import sys; import os; sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from taintlib import *

# This has no runtime impact, but allows autocomplete to work
from typing import TYPE_CHECKING
if TYPE_CHECKING:
    from ..taintlib import *


# Actual tests

async def tainted_coro():
    return TAINTED_STRING

async def test_await():
    coro = tainted_coro()
    taint(coro)
    s = await coro
    ensure_tainted(coro, s) # $ tainted


class AsyncContext:
    async def __aenter__(self):
        return TAINTED_STRING

    async def __aexit__(self, exc_type, exc, tb):
        pass

async def test_async_with():
    ctx = AsyncContext()
    taint(ctx)
    async with ctx as tainted:
        ensure_tainted(tainted) # $ tainted


class AsyncIter:
    def __aiter__(self):
        return self

    async def __anext__(self):
        raise StopAsyncIteration

async def test_async_for():
    iter = AsyncIter()
    taint(iter)
    async for tainted in iter:
        ensure_tainted(tainted) # $ tainted



# Make tests runable
import asyncio

asyncio.run(test_await())
asyncio.run(test_async_with())
asyncio.run(test_async_for())
