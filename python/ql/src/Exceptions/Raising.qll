import python

/** Whether the raise statement 'r' raises 'type' from origin 'orig' */
predicate type_or_typeof(Raise r, ClassValue type, AstNode orig) {
  exists(Expr exception | exception = r.getRaised() |
    exception.pointsTo(type, orig)
    or
    not exists(ClassValue exc_type | exception.pointsTo(exc_type)) and
    not type = ClassValue::type() and // First value is an unknown exception type
    exists(Value val | exception.pointsTo(val, orig) | val.getClass() = type)
  )
}
