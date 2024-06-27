class Expr extends @expr {
  string toString() { result = "expr" }
}

class LocalVariableDeclExpr extends @localvariabledeclexpr, Expr { }

class InstanceOfExpr extends @instanceofexpr, Expr { }

class SimplePatternInstanceOfExpr extends InstanceOfExpr {
  SimplePatternInstanceOfExpr() { getNthChild(this, 2) instanceof LocalVariableDeclExpr }
}

class Type extends @type {
  string toString() { result = "type" }
}

class ExprParent extends @exprparent {
  string toString() { result = "exprparent" }
}

Expr getNthChild(ExprParent parent, int i) { exprs(result, _, _, parent, i) }

// Where an InstanceOfExpr has a 2nd child that is a LocalVariableDeclExpr, that expression should becomes its 0th child and the existing 0th child should become its initialiser.
// Any RecordPatternExpr should be replaced with an error expression, as it can't be represented in the downgraded dbscheme.
// This reverts a reorganisation of the representation of "o instanceof String s", which used to be InstanceOfExpr -0-> LocalVariableDeclExpr --init-> o
//                                                                                                                                               \-name-> s
// It is now InstanceOfExpr --0-> o
//                          \-2-> LocalVariableDeclExpr -name-> s
//
// Other children are unaffected.
predicate hasNewParent(Expr e, ExprParent newParent, int newIndex) {
  exists(SimplePatternInstanceOfExpr oldParent, int oldIndex |
    e = getNthChild(oldParent, oldIndex)
  |
    oldIndex = 0 and newParent = getNthChild(oldParent, 2) and newIndex = 0
    or
    oldIndex = 1 and newParent = oldParent and newIndex = oldIndex
    or
    oldIndex = 2 and newParent = oldParent and newIndex = 0
  )
  or
  not exists(SimplePatternInstanceOfExpr oldParent | e = getNthChild(oldParent, _)) and
  exprs(e, _, _, newParent, newIndex)
}

from Expr e, int oldKind, int newKind, Type typeid, ExprParent parent, int index
where
  exprs(e, oldKind, typeid, _, _) and
  hasNewParent(e, parent, index) and
  (
    if oldKind = /* record pattern */ 89
    then newKind = /* error expression */ 74
    else oldKind = newKind
  )
select e, newKind, typeid, parent, index
