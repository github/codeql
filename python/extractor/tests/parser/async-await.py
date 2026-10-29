async def foo():
    await bar() + await baz()

    async with foo() as bar, baz() as quux:
        pass

    async for spam in eggs:
        pass
