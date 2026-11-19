import asyncio


async def returns_value():
    return 42


async def await_task_result():
    task = asyncio.create_task(returns_value())
    await task


async def await_coroutine_result():
    coroutine = returns_value()
    await coroutine
