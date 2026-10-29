registry = {}


def make_type(name):
    if name in registry:
        return registry[name]

    class Created(str):
        pass

    registry[name] = Created
    return Created


InTyping = make_type("InTyping")