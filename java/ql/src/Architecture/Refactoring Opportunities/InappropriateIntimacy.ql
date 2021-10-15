/**
 * @name Inappropriate Intimacy
 * @description Two otherwise unrelated classes that share too much information about each other are
 *              difficult to maintain, change and understand.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/coupled-types
 * @tags maintainability
 *       modularity
 */

import java

predicate enclosingRefType(Variable v, RefType type) {
  v.(Field).getDeclaringType() = type or
  v.(LocalVariableDecl).getCallable().getDeclaringType() = type or
  v.(Parameter).getCallable().getDeclaringType() = type
}

predicate remoteVarAccess(RefType source, RefType target, VarAccess va) {
  va.getEnclosingCallable().getDeclaringType() = source and
  enclosingRefType(va.getVariable(), target) and
  source != target
}

predicate remoteFunAccess(RefType source, RefType target, MethodAccess fc) {
  fc.getEnclosingCallable().getDeclaringType() = source and
  fc.getMethod().getDeclaringType() = target and
  source != target
}

predicate candidateTypePair(RefType source, RefType target) {
  remoteVarAccess(source, target, _) or remoteFunAccess(source, target, _)
}

predicate variableDependencyCount(RefType source, RefType target, int res) {
  candidateTypePair(source, target) and
  res = count(VarAccess va | remoteVarAccess(source, target, va))
}

predicate functionDependencyCount(RefType source, RefType target, int res) {
  candidateTypePair(source, target) and
  res = count(MethodAccess fc | remoteFunAccess(source, target, fc))
}

predicate dependencyCount(RefType source, RefType target, int res) {
  exists(int varCount, int funCount |
    variableDependencyCount(source, target, varCount) and
    functionDependencyCount(source, target, funCount) and
    res = varCount + funCount and
    res > 20
  )
}

from RefType a, RefType b, int ca, int cb
where
  dependencyCount(a, b, ca) and
  dependencyCount(b, a, cb) and
  ca > 20 and
  cb > 20 and
  ca >= cb and
  not exists(CompilationUnit cu | cu = a.getCompilationUnit() and cu = b.getCompilationUnit())
select a,
  "Type " + a.getName() + " is too closely tied to $@ (" + ca.toString() +
    " dependencies one way and " + cb.toString() + " the other).", b, b.getName()
