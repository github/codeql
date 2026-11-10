/**
 * @name Unused variable
 * @description Unused variables may be an indication that the code is incomplete or has a typo.
 * @kind problem
 * @problem.severity recommendation
 * @id unified/unused-variable
 * @precision high
 */

private import unified

private predicate isUnusedLocal(LocalName local) {
  local.getABinding().fromSource() and // ignore unused implicit locals, and ignore locals in built-ins
  not ignoreDeclaration(local.getABinding().getDeclaration()) and // ignore fields, method, etc
  not local.getName().regexpMatch("_.*") and
  not exists(LocalNameAccess access |
    access = local.getAnAccess() and
    not access instanceof NameBinding
  ) and
  not local = any(UnqualifiedMemberAccess access).getImplicitQualifierVariable()
}

private predicate ignoreDeclaration(AstNode n) {
  // ignore fields and methods etc
  n = any(ClassLikeDeclaration cls).getAMember()
  or
  // ignore top-level statements, which are often exported
  n = any(TopLevel t).getBody().getAStmt()
  or
  // Parameters are often needed to satisfy an interface
  n instanceof Parameter
}

string getKind(LocalName local) {
  if local instanceof LocalVariable then result = "local variable" else result = "declaration"
}

from LocalName local
where isUnusedLocal(local)
select local, "Unused " + getKind(local) + " '" + local.getName() + "'"
