/**
 * @name Class predicate doesn't mention `this`
 * @description A class predicate that doesn't use `this` (or a field) could instead be a classless predicate, and may cause a cartesian product.
 * @kind problem
 * @problem.severity warning
 * @id ql/class-predicate-doesnt-use-this
 * @tags performance
 * @precision medium
 */

import ql

predicate usesThis(ClassPredicate pred) {
  exists(ThisAccess th | th.getEnclosingPredicate() = pred)
  or
  exists(Super sup | sup.getEnclosingPredicate() = pred)
  or
  exists(FieldAccess f | f.getEnclosingPredicate() = pred)
  or
  // implicit this
  exists(PredicateCall pc | pc.getEnclosingPredicate() = pred |
    pc.getTarget() instanceof ClassPredicate
  )
}

predicate isLiteralComparison(ComparisonFormula eq) {
  exists(Expr lhs, Expr rhs |
    eq.getOperator() = "=" and
    eq.getAnOperand() = lhs and
    eq.getAnOperand() = rhs and
    (
      lhs instanceof ResultAccess
      or
      lhs instanceof ThisAccess
      or
      lhs instanceof VarAccess
    ) and
    (
      rhs instanceof Literal
      or
      exists(NewTypeBranch nt |
        rhs.(Call).getTarget() = nt and
        count(nt.getField(_)) = 0
      )
    )
  )
}

predicate conjParent(Formula par, Formula child) { child = par.(Conjunction).getAnOperand() }

predicate isLiteralComparisons(Formula f) {
  forex(ComparisonFormula child | conjParent*(f, child) | isLiteralComparison(child))
}

predicate isTrivialImplementation(Predicate pred) {
  not exists(pred.getBody())
  or
  exists(Formula bod | bod = pred.getBody() |
    bod instanceof AnyCall
    or
    bod instanceof NoneCall
    or
    isLiteralComparisons(bod)
  )
}

predicate isSingleton(Type ty) {
  isTrivialImplementation(ty.(ClassType).getDeclaration().getCharPred())
  or
  isSingleton(ty.getASuperType())
  or
  exists(NewTypeBranch br | count(br.getField(_)) = 0 |
    ty.(NewTypeBranchType).getDeclaration() = br
    or
    br = unique(NewTypeBranch br2 | br2 = ty.(NewTypeType).getDeclaration().getABranch())
  )
}

from ClassPredicate pred
where
  not usesThis(pred) and
  not isTrivialImplementation(pred) and
  not isSingleton(pred.getDeclaringType()) and
  not exists(ClassPredicate other | pred.overrides(other) or other.overrides(pred)) and
  not pred.isOverride()
select pred, "This predicate could be a classless predicate, as it doesn't depend on `this`."
