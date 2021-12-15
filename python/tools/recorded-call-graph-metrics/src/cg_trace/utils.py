def better_compare_for_dataclass(cls):
    """When dataclass is used with `order=True`, the comparison methods is only implemented for
    objects of the same class. This decorator extends the functionality to compare class
    name if used against other objects.
    """
    for op in [
        "__lt__",
        "__le__",
        "__gt__",
        "__ge__",
    ]:
        old = getattr(cls, op)

        def new(self, other, op=op, old=old):
            if type(self) == type(other):
                return old(self, other)
            return getattr(str, op)(self.__class__.__name__, other.__class__.__name__)

        setattr(cls, op, new)
    return cls
