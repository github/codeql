import pkg # $ use=moduleImport("pkg")

async def foo():
    coro = pkg.async_func() # $ use=moduleImport("pkg").getMember("async_func").getReturn()
    coro # $ use=moduleImport("pkg").getMember("async_func").getReturn()
    result = await coro # $ use=moduleImport("pkg").getMember("async_func").getReturn().getAwaited() awaited=moduleImport("pkg").getMember("async_func").getReturn()
    result # $ use=moduleImport("pkg").getMember("async_func").getReturn().getAwaited() awaited=moduleImport("pkg").getMember("async_func").getReturn()
    return result # $ use=moduleImport("pkg").getMember("async_func").getReturn().getAwaited() awaited=moduleImport("pkg").getMember("async_func").getReturn()

async def bar():
    result = await pkg.async_func() # $ use=moduleImport("pkg").getMember("async_func").getReturn().getAwaited() awaited=moduleImport("pkg").getMember("async_func").getReturn()
    return result # $ use=moduleImport("pkg").getMember("async_func").getReturn().getAwaited() awaited=moduleImport("pkg").getMember("async_func").getReturn()

async def test_async_with():
    async with pkg.async_func() as result: # $ use=moduleImport("pkg").getMember("async_func").getReturn().getAwaited() awaited=moduleImport("pkg").getMember("async_func").getReturn()
        return result # $ use=moduleImport("pkg").getMember("async_func").getReturn().getAwaited() awaited=moduleImport("pkg").getMember("async_func").getReturn()

async def test_async_for():
    async for _ in pkg.async_func(): # $ use=moduleImport("pkg").getMember("async_func").getReturn() awaited=moduleImport("pkg").getMember("async_func").getReturn()
        pass

    coro = pkg.async_func() # $ use=moduleImport("pkg").getMember("async_func").getReturn()
    async for _ in coro: # $ use=moduleImport("pkg").getMember("async_func").getReturn() MISSING: awaited=moduleImport("pkg").getMember("async_func").getReturn()
        pass

def check_annotations():
    # Just to make sure how annotations should look like :)
    result = pkg.sync_func() # $ use=moduleImport("pkg").getMember("sync_func").getReturn()
    return result # $ use=moduleImport("pkg").getMember("sync_func").getReturn()
