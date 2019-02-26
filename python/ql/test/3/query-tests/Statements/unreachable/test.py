
#Yield may raise -- E.g. in a context manager
def yield_from_in_try():
    resources = get_resources()
    try:
        yield from resources
    except Exception as exc:
        log(exc)
