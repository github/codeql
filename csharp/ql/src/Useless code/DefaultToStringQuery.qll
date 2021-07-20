import csharp
import semmle.code.csharp.commons.Strings
import semmle.code.csharp.frameworks.System

/**
 * Holds if expression `e`, of type `t`, invokes `ToString()` either explicitly
 * or implicitly.
 */
predicate invokesToString(Expr e, ValueOrRefType t) {
  // Explicit invocation
  exists(MethodCall mc | mc.getQualifier() = e |
    mc.getTarget() instanceof ToStringMethod and
    t = mc.getQualifier().getType()
  )
  or
  // Explicit or implicit invocation
  e instanceof ImplicitToStringExpr and
  t = e.stripCasts().getType()
  or
  // Implicit invocation via forwarder method
  t = e.stripCasts().getType() and
  not t instanceof StringType and
  exists(Parameter p |
    alwaysInvokesToStringOnParameter(p) and
    e = p.getAnAssignedArgument()
  )
}

pragma[noinline]
private predicate alwaysInvokesToStringOnParameter(Parameter p) {
  exists(AssignableDefinitions::ImplicitParameterDefinition def, ParameterRead pr |
    def.getParameter() = p and
    pr = def.getAReachableRead() and
    pr.getAControlFlowNode().postDominates(p.getCallable().getEntryPoint()) and
    invokesToString(pr, _)
  )
}

/**
 * Holds if `t`, or any sub type of `t`, inherits the default `ToString()`
 * method from `System.Object` or `System.ValueType`.
 */
predicate alwaysDefaultToString(ValueOrRefType t) {
  exists(ToStringMethod m | t.hasMethod(m) |
    m.getDeclaringType() instanceof SystemObjectClass or
    m.getDeclaringType() instanceof SystemValueTypeClass
  ) and
  not exists(RefType overriding |
    overriding.getAMethod() instanceof ToStringMethod and
    overriding.getABaseType+() = t
  ) and
  ((t.isAbstract() or t instanceof Interface) implies not t.isEffectivelyPublic())
}

class DefaultToStringType extends ValueOrRefType {
  DefaultToStringType() { alwaysDefaultToString(this) }
}

query predicate problems(Expr e, string s, DefaultToStringType t, string name) {
  invokesToString(e, t) and
  s =
    "Default 'ToString()': $@ inherits 'ToString()' from 'Object', and so is not suitable for printing." and
  name = t.getName()
}
