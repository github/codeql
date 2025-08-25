

#PEP 525

async def ticker(delay, to):
    """Yield numbers from 0 to *to* every *delay* seconds."""
    for i in range(to):
        yield i
        await asyncio.sleep(delay)

#PEP 530

async def f():
    a = [i async for i in aiter() if i % 2]
    b = [await fun() for fun in funcs if await condition()]
    c = {i async for i in aiter() if i % 2}
    d = {await fun() for fun in funcs if await condition()}

# Not async versions

def g():
    a = [i for i in iter() if i % 2]
    b = [fun() for fun in funcs if condition()]
    c = {i for i in iter() if i % 2}
    d = {fun() for fun in funcs if condition()}

