def generator():
    try:
        yield  # $ exception-handler=GeneratorExit
    except GeneratorExit:
        return


def load_module():
    try:
        import unavailable_module  # $ exception-handler=ImportError
    except ImportError:
        return None
