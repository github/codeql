__all__ = ["available_lazily"]


class DynamicAttributes:
    def __call__(self, name):
        return object()


__getattr__ = DynamicAttributes()
