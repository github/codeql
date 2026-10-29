private import unified
private import AllDataFlow
private import codeql.unified.internal.typeinference.TypeInference as T
private import codeql.unified.internal.NameBinding as N
private import codeql.unified.internal.ExprPositions

DataFlowCallable viableCallable(DataFlowCall c) {
  result.asSourceCallable() = T::resolveCallTarget(c.asExplicitCall())
  or
  result.asSourceCallable() = resolveAccessor(c.asGetterCall()).(GetterDeclaration)
  or
  result.asSourceCallable() = resolveAccessor(c.asSetterCall()).(SetterDeclaration)
  or
  result.asSummarizedCallable().matchesCall(c.asExplicitCall())
}

bindingset[access]
pragma[inline_late]
private N::NamespaceNode resolveBase(MemberAccessExpr access) {
  result.isInstanceMemberNamespace(T::inferType(access.getBase()).asClass())
}

private AccessorDeclaration resolveAccessor(Expr access) {
  result.getNameNode() = N::getStaticBindingTargetFromRef(access)
  or
  not exists(N::getStaticBindingTargetFromRef(access)) and
  exists(MemberAccessExpr m |
    access = m and
    // TODO: Make type inference own accessor-resolution. It also needs it internally.
    resolveBase(m).getMember(m.getMemberName()).isMember(result)
  )
}
