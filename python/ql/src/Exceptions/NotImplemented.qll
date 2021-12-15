import python

/** Holds if `notimpl` refers to `NotImplemented` or `NotImplemented()` in the `raise` statement */
predicate use_of_not_implemented_in_raise(Raise raise, Expr notimpl) {
  notimpl.pointsTo(Value::named("NotImplemented")) and
  (
    notimpl = raise.getException() or
    notimpl = raise.getException().(Call).getFunc()
  )
}
