__all__ = ["available_lazily"]


class DynamicAttribute:
    def __init__(self, name):
        self.name = name


__getattr__ = DynamicAttribute
