class D:
    def __hash__(self):
        # BAD: Use `__hash__ = None` instead.
        raise NotImplementedError(f"{self.__class__} is unhashable.")