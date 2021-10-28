/** Provides definitions related to the namespace `Moq`. */

import csharp

/** The `Moq.Language` Namespace. */
class MoqLanguageNamespace extends Namespace {
  MoqLanguageNamespace() { this.hasQualifiedName("Moq.Language") }
}

/**
 * A Moq method that declares a value to be returned by a mock in reaction to an action.
 */
class ReturnsMethod extends Method {
  ReturnsMethod() {
    this.hasName("Returns") and
    this.getDeclaringType().getNamespace() instanceof MoqLanguageNamespace
  }

  /**
   * Gets an expression that may be returned by a call to this `Returns` method.
   */
  Expr getAReturnedExpr() {
    exists(MethodCall mc, Expr arg |
      mc = this.getACall() and
      arg = mc.getArgument(0)
    |
      if arg instanceof LambdaExpr then arg.(LambdaExpr).canReturn(result) else result = arg
    )
  }
}

/** An object creation that is returned by a mock. */
class ReturnedByMockObject extends ObjectCreation {
  ReturnedByMockObject() {
    exists(Variable v | this = v.getAnAssignedValue() |
      v.getAnAccess() = any(ReturnsMethod rm).getAReturnedExpr().getAChild*()
    )
  }

  /**
   * Gets a value used to initialize a member of this object creation.
   */
  Expr getAMemberInitializationValue() {
    result = this.getInitializer().(ObjectInitializer).getAMemberInitializer().getRValue()
  }
}
