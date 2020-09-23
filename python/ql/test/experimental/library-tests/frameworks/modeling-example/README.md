This test illustrates that you need to be very careful when adding additional taint-steps or dataflow steps using `TypeTracker`.

The basic setup is that we're modeling the behavior of a (fictitious) external library class `MyClass`, and (fictitious) source of such an instance (the `source` function).

```py3
class MyClass:
    def __init__(self, value):
        self.value = value

    def get_value(self):
        return self.value
```

We want to extend our analysis to `obj.get_value()` is also tainted if `obj` is a tainted instance of `MyClass`.

The actual type-tracking is done in `SharedCode.qll`, but it's the _way_ we use it that matters.

In `NaiveModel.ql` we add an additional taint step from an instance of `MyClass` to calls of the bound method `get_value` (that we have tracked). It provides us with the correct results, but the path explanations are not very useful, since we are now able to cross functions in _one step_.

In `ProperModel.ql` we split the additional taint step in two:

1. from tracked `obj` that is instance of `MyClass`, to `obj.get_value` **but only** exactly where the attribute is accessed (by an `AttrNode`). This is important, since if we allowed `<any tracked qualifier>.get_value` we would again be able to cross functions in one step.
2. from tracked `get_value` bound method to calls of it, **but only** exactly where the call is (by a `CallNode`). for same reason as above.

**Try running the queries in VS Code to see the difference**

### Possible improvements

Using `AttrNode` directly in the code here means there is no easy way to add `getattr` support too all such predicates. Not really sure how to handle this in a generalized way though :|
