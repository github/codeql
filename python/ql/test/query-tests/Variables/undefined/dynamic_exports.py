__all__ = ["available_lazily", "also_available_lazily"]


def __getattr__(name):
    if name in __all__:
        return object()
    raise AttributeError(name)
