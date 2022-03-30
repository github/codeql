
class AsyncIterator:
    def __init__(self):
        pass

    def __aiter__(self):
        return self

    async def __anext__(self):
        await asyncio.sleep(5)
        return 1

class MissingAiter:
    def __init__(self, delay, to):
        pass

    async def __anext__(self):
        await asyncio.sleep(5)
        return 1

async def good():
    async for x in AsyncIterator():
        yield x

async def bad():
    async for x in MissingAiter():
        yield x
