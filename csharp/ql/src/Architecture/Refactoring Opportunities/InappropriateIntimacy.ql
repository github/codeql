/**
 * @name Inappropriate intimacy
 * @description Two otherwise unrelated classes that share too much information about each other are
 *              difficult to maintain, change and understand.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/coupled-types
 * @tags maintainability
 *       modularity
 */

import csharp

predicate enclosingRefType(Variable v, RefType type) {
  v.(Field).getDeclaringType() = type or
  v.(LocalScopeVariable).getDeclaringType() = type
}

predicate remoteVarAccess(RefType source, RefType target, VariableAccess va) {
  va.getEnclosingCallable().getDeclaringType() = source and
  enclosingRefType(va.getTarget(), target) and
  source != target
}

predicate remoteFunAccess(RefType source, RefType target, Call fc) {
  fc.getEnclosingCallable().getDeclaringType() = source and
  target = fc.getTarget().getDeclaringType()
}

predicate candidateTypePair(RefType source, RefType target) {
  remoteVarAccess(source, target, _) or remoteFunAccess(source, target, _)
}

predicate variableDependencyCount(RefType source, RefType target, int res) {
  candidateTypePair(source, target) and
  res = count(VariableAccess va | remoteVarAccess(source, target, va))
}

predicate functionDependencyCount(RefType source, RefType target, int res) {
  candidateTypePair(source, target) and
  res = count(Call fc | remoteFunAccess(source, target, fc))
}

predicate dependencyCount(RefType source, RefType target, int res) {
  exists(int varCount, int funCount |
    variableDependencyCount(source, target, varCount) and
    functionDependencyCount(source, target, funCount) and
    res = varCount + funCount and
    res > 15
  )
}

from RefType a, RefType b, int ca, int cb
where
  dependencyCount(a, b, ca) and
  dependencyCount(b, a, cb) and
  ca > 15 and
  cb > 15 and
  ca >= cb and
  a != b
select a,
  "Type " + a.getName() + " is too closely tied to $@ (" + ca.toString() +
    " dependencies one way and " + cb.toString() + " the other).", b, b.getName()
