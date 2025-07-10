/**
 * @name Local scope variable shadows member
 * @description A local scope variable that shadows a member with the same name can be confusing,
 *              and can result in logic errors.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cs/local-shadows-member
 * @tags maintainability
 *       readability
 */

import csharp

pragma[noinline]
private string localVarInType(ValueOrRefType t, LocalScopeVariable v) {
  v.getCallable().getDeclaringType() = t and
  result = v.getName() and
  not v instanceof ImplicitAccessorParameter
}

private string memberInType(ValueOrRefType t, Member m) {
  t.hasMember(m) and
  result = m.getName() and
  not m instanceof Method and
  not m instanceof Constructor and
  not m instanceof NestedType and
  t.isSourceDeclaration()
}

private predicate acceptableShadowing(LocalScopeVariable v, Member m) {
  exists(ValueOrRefType t | localVarInType(t, v) = memberInType(t, m) |
    // If the callable declaring the local also accesses the shadowed member
    // using an explicit `this` qualifier, the shadowing is likely deliberate.
    exists(MemberAccess ma | ma.getTarget() = m |
      ma.getEnclosingCallable() = v.getCallable() and
      ma.targetIsLocalInstance() and
      not ma.getQualifier().isImplicit()
    )
    or
    t.getAConstructor().getAParameter() = v
    or
    // Record types have auto-generated Deconstruct methods, which declare an out parameter
    // with the same name as the property field(s).
    t.(RecordType).getAMethod("Deconstruct").getAParameter() = v
  )
}

private predicate shadowing(ValueOrRefType t, LocalScopeVariable v, Member m) {
  localVarInType(t, v) = memberInType(t, m) and
  not acceptableShadowing(v, m)
}

from LocalScopeVariable v, Callable c, ValueOrRefType t, Member m
where
  c = v.getCallable() and
  shadowing(t, v, m) and
  (c.(Modifiable).isStatic() implies m.isStatic())
select v, "Local scope variable '" + v.getName() + "' shadows $@.", m,
  t.getName() + "." + m.getName()
