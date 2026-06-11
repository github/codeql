"""Async/await evaluation order tests.

Coroutine bodies are lazy — like generators, the body runs only when
awaited (or driven by the event loop).  asyncio.run() drives the
coroutine to completion synchronously from the caller's perspective.
"""

import asyncio
from contextlib import asynccontextmanager
from timer import test


@test
def test_simple_async(t):
    """Simple async function: body runs inside asyncio.run()."""
    async def coro():
        x = 1 @ t[4]
        return x @ t[5]

    result = ((asyncio @ t[0]).run @ t[1])((coro @ t[2])() @ t[3]) @ t[6]


@test
def test_await_expression(t):
    """await suspends the caller until the inner coroutine completes."""
    async def helper():
        return 1 @ t[4]

    async def main():
        x = await helper() @ t[5]
        return x @ t[6]

    result = ((asyncio @ t[0]).run @ t[1])((main @ t[2])() @ t[3]) @ t[7]


@test
def test_async_for(t):
    """async for iterates an async generator."""
    async def agen():
        yield 1 @ t[5]
        yield 2 @ t[7]

    async def main():
        async for val in agen() @ t[4]:
            val @ t[6, 8]

    ((asyncio @ t[0]).run @ t[1])((main @ t[2])() @ t[3]) @ t[9]


@test
def test_async_with(t):
    """async with enters/exits an async context manager."""
    @asynccontextmanager
    async def ctx():
        yield 1 @ t[5]

    async def main():
        async with ctx() @ t[4] as val:
            val @ t[6]

    ((asyncio @ t[0]).run @ t[1])((main @ t[2])() @ t[3]) @ t[7]


@test
def test_multiple_awaits(t):
    """Sequential awaits in one coroutine."""
    async def task_a():
        return 10 @ t[4]

    async def task_b():
        return 20 @ t[6]

    async def main():
        a = await task_a() @ t[5]
        b = await task_b() @ t[7]
        return (a @ t[8] + b @ t[9]) @ t[10]

    result = ((asyncio @ t[0]).run @ t[1])((main @ t[2])() @ t[3]) @ t[11]


@test
def test_gather(t):
    """asyncio.gather schedules coroutines as concurrent tasks."""
    async def task_a():
        return 1 @ t[6]

    async def task_b():
        return 2 @ t[7]

    async def main():
        results = await asyncio.gather(
            task_a() @ t[4],
            task_b() @ t[5],
        ) @ t[8]
        return results @ t[9]

    result = ((asyncio @ t[0]).run @ t[1])((main @ t[2])() @ t[3]) @ t[10]
