__all__ = ["still_missing"]


class DynamicObject:
    def __getattr__(self, name):
        return name
