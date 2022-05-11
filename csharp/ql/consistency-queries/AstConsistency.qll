import csharp

query predicate missingLocation(Element e) {
  (
    e instanceof Declaration or
    e instanceof Expr or
    e instanceof Stmt
  ) and
  not e instanceof ImplicitAccessorParameter and
  not e instanceof NullType and
  not e instanceof Parameter and // Bug in Roslyn - params occasionally lack locations
  not e.(Operator).getDeclaringType() instanceof IntType and // Roslyn quirk
  not e instanceof Constructor and
  not e instanceof ArrayType and
  not e instanceof UnknownType and
  not e instanceof ArglistType and
  not exists(TupleType t | e = t or e = t.getAField()) and
  not exists(e.getLocation())
}
