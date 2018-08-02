/**
 * @name Use of default ToString()
 * @description Calling the default implementation of 'ToString' returns a value
 *              that is unlikely to be what you expect.
 * @kind problem
 * @problem.severity warning
 * @precision very-high
 * @id cs/call-to-object-tostring
 * @tags reliability
 *       maintainability
 */
import csharp
import semmle.code.csharp.commons.Strings
import semmle.code.csharp.frameworks.System

/**
 * Holds if expression `e`, of type `t`, invokes `ToString()` either explicitly
 * or implicitly.
 */
predicate invokesToString(Expr e, ValueOrRefType t) {
  // Explicit invocation
  exists(MethodCall mc |
    mc.getQualifier() = e |
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
  exists(AssignableDefinitions::ImplicitParameterDefinition def, Parameter p, ParameterRead pr |
    e = p.getAnAssignedArgument() |
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
  exists(ToStringMethod m |
    t.hasMethod(m) |
    m.getDeclaringType() instanceof SystemObjectClass or
    m.getDeclaringType() instanceof SystemValueTypeClass
  )
  and
  not exists(RefType overriding |
    overriding.getAMethod() instanceof ToStringMethod and
    overriding.getABaseType+() = t
  )
}

from Expr e, ValueOrRefType t
where invokesToString(e, t)
  and alwaysDefaultToString(t)
select e, "Default 'ToString()': $@ inherits 'ToString()' from 'Object', and so is not suitable for printing.", t, t.getName()
