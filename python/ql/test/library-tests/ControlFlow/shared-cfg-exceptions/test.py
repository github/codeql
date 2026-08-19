def generator():
    try:
        yield  # $ MISSING: exception-handler=GeneratorExit
    except GeneratorExit:
        return


def load_module():
    try:
        import unavailable_module  # $ MISSING: exception-handler=ImportError
    except ImportError:
        return None
