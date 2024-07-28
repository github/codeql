import java

query predicate staticMembers(RefType declType, Member m, string kind) {
  m.fromSource() and
  m.isStatic() and
  m.getDeclaringType() = declType and
  kind = m.getAPrimaryQlClass()
}

from Call call, Callable callable, RefType declType, Expr qualifier, string callType
where
  call.getCallee() = callable and
  declType = callable.getDeclaringType() and
  qualifier = call.getQualifier() and
  if callable.isStatic() then callType = "static" else callType = "instance"
select declType, call, qualifier, callType
