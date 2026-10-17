from functools import lru_cache

__all__ = ["available_lazily"]


@lru_cache
def __getattr__(name):
    return object()
