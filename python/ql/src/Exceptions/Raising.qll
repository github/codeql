import python

/** Whether the raise statement 'r' raises 'type' from origin 'orig' */ 
predicate type_or_typeof_objectapi(Raise r, ClassObject type, AstNode orig) {
     exists(Expr exception |
        exception = r.getRaised() |
        exception.refersTo(type, _, orig)
        or
        not exists(ClassObject exc_type | exception.refersTo(exc_type)) and
        not type = theTypeType() and // First value is an unknown exception type
        exception.refersTo(_, type, orig)
    )

}

/** Whether the raise statement 'r' raises 'type' from origin 'orig' */ 
predicate type_or_typeof(Raise r, ClassValue type, AstNode orig) {
     exists(Expr exception |
        exception = r.getRaised() |
        exception.pointsTo(type, orig)
        or
        not exists(ClassValue exc_type | exception.pointsTo(exc_type)) and
        not type = ClassValue::type() and // First value is an unknown exception type
        exists(Value val | exception.pointsTo(val, orig) |
          val.getClass() = type
        )
    )

}
