class Expr extends @expr {
  string toString() { result = "expr" }
}

class LocalVariableDeclExpr extends @localvariabledeclexpr, Expr { }

class InstanceOfExpr extends @instanceofexpr, Expr { }

class Type extends @type {
  string toString() { result = "type" }
}

class ExprParent extends @exprparent {
  string toString() { result = "exprparent" }
}

// Initialisers of local variable declarations that occur as the 0th child of an instanceof expression should be reparented to be the 0th child of the instanceof itself,
// while the LocalVariableDeclExpr, now without an initialiser, should become its 2nd child.
// This implements a reorganisation of the representation of "o instanceof String s", which used to be InstanceOfExpr -0-> LocalVariableDeclExpr --init-> o
//                                                                                                                                               \-name-> s
// It is now InstanceOfExpr --0-> o
//                          \-2-> LocalVariableDeclExpr -name-> s
//
// Other children are unaffected.
ExprParent getParent(Expr e) { exprs(e, _, _, result, _) }

predicate hasNewParent(Expr e, ExprParent newParent, int newIndex) {
  if
    getParent(e) instanceof LocalVariableDeclExpr and
    getParent(getParent(e)) instanceof InstanceOfExpr
  then (
    // Initialiser moves to hang directly off the instanceof expression
    newParent = getParent(getParent(e)) and newIndex = 0
  ) else (
    if e instanceof LocalVariableDeclExpr and getParent(e) instanceof InstanceOfExpr
    then
      // Variable declaration moves to be the instanceof expression's 2nd child
      newParent = getParent(e) and newIndex = 2
    else exprs(e, _, _, newParent, newIndex) // Other expressions unchanged
  )
}

from Expr e, int kind, Type typeid, ExprParent parent, int index
where
  exprs(e, kind, typeid, _, _) and
  hasNewParent(e, parent, index)
select e, kind, typeid, parent, index
