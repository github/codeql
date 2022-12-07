import csharp
import DataFlow

/**
 * A sensitive property for `TokenValidationParameters` that updates the underlying value.
 */
class TokenValidationParametersPropertySensitiveValidation extends Property {
  TokenValidationParametersPropertySensitiveValidation() {
    exists(Class c |
      c.hasQualifiedName("Microsoft.IdentityModel.Tokens", "TokenValidationParameters")
    |
      c.getAProperty() = this and
      this.getName() in [
          "ValidateIssuer", "ValidateAudience", "ValidateLifetime", "RequireExpirationTime",
          "RequireAudience"
        ]
    )
  }
}

/**
 * A dataflow from a `false` value to a write sensitive property for `TokenValidationParameters`.
 */
class FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation extends DataFlow::Configuration {
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation() {
    this = "FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation"
  }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().getValue() = "false" and
    source.asExpr().getType() instanceof BoolType
  }

  override predicate isSink(DataFlow::Node sink) {
    sink.asExpr() = any(TokenValidationParametersPropertySensitiveValidation p).getAnAssignedValue()
  }
}

/**
 * Holds if `assemblyName` is older than version `ver`
 */
bindingset[ver]
predicate isAssemblyOlderVersion(string assemblyName, string ver) {
  exists(Assembly a |
    a.getName() = assemblyName and
    a.getVersion().isEarlierThan(ver)
  )
}

/**
 * A method `ValidateToken` for `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler` or other Token handler that shares the same behavior characteristics
 */
class JsonWebTokenHandlerValidateTokenMethod extends Method {
  JsonWebTokenHandlerValidateTokenMethod() {
    this.hasQualifiedName("Microsoft.IdentityModel.JsonWebTokens", "JsonWebTokenHandler",
      "ValidateToken") or
    this.hasQualifiedName("Microsoft.AzureAD.DeviceIdentification.Common.Tokens", "JwtValidator",
      "ValidateEncryptedToken")
  }
}

/**
 * A Call to `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken`
 */
class JsonWebTokenHandlerValidateTokenCall extends MethodCall {
  JsonWebTokenHandlerValidateTokenCall() {
    this.getTarget() instanceof JsonWebTokenHandlerValidateTokenMethod
  }
}

/**
 * A read access for properties `IsValid` or `Exception` for `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken`
 */
private class TokenValidationResultIsValidCall extends PropertyRead {
  TokenValidationResultIsValidCall() {
    exists(Property p | p.getAnAccess() = this |
      p.hasName("IsValid") or
      p.hasName("Exception")
    )
  }
}

/**
 * Dataflow from the output of `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken` call to access the `IsValid` or `Exception` property
 */
private class FlowsToTokenValidationResultIsValidCall extends DataFlow::Configuration {
  FlowsToTokenValidationResultIsValidCall() { this = "FlowsToTokenValidationResultIsValidCall" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof JsonWebTokenHandlerValidateTokenCall
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(TokenValidationResultIsValidCall call | sink.asExpr() = call.getQualifier())
  }
}

/**
 * A security-sensitive property for `Microsoft.IdentityModel.Tokens.TokenValidationParameters`
 */
class TokenValidationParametersProperty extends Property {
  TokenValidationParametersProperty() {
    exists(Class c |
      c.hasQualifiedName("Microsoft.IdentityModel.Tokens", "TokenValidationParameters")
    |
      c.getAProperty() = this and
      this.getName() in [
          "SignatureValidator", "TokenReplayValidator", "AlgorithmValidator", "AudienceValidator",
          "IssuerSigningKeyValidator", "LifetimeValidator"
        ]
    )
  }
}

/**
 * Holds if the callable has a return statement and it always returns true for all such statements
 */
predicate callableHasAReturnStmtAndAlwaysReturnsTrue(Callable c) {
  c.getReturnType() instanceof BoolType and
  not callableMayThrowException(c) and
  forall(ReturnStmt rs | rs.getEnclosingCallable() = c |
    rs.getNumberOfChildren() = 1 and
    isExpressionAlwaysTrue(rs.getChildExpr(0))
  ) and
  exists(ReturnStmt rs | rs.getEnclosingCallable() = c)
}

/**
 * Holds if the lambda expression `le` always returns true
 */
predicate lambdaExprReturnsOnlyLiteralTrue(AnonymousFunctionExpr le) {
  le.getExpressionBody().(BoolLiteral).getBoolValue() = true
  or
  // special scenarios where the expression is not a `BoolLiteral`, but it will evaluatue to `true`
  exists(Expr e | le.getExpressionBody() = e |
    not e instanceof Call and
    not e instanceof Literal and
    e.getType() instanceof BoolType and
    e.getValue() = "true"
  )
}

class CallableAlwaysReturnsTrue extends Callable {
  CallableAlwaysReturnsTrue() {
    callableHasAReturnStmtAndAlwaysReturnsTrue(this)
    or
    lambdaExprReturnsOnlyLiteralTrue(this)
    or
    exists(AnonymousFunctionExpr le, Call call, Callable callable | this = le |
      callable.getACall() = call and
      call = le.getExpressionBody() and
      callableHasAReturnStmtAndAlwaysReturnsTrue(callable)
    )
  }
}

/**
 * Holds if any exception being thrown by the callable is of type `System.ArgumentNullException`
 * It will also hold if no exceptions are thrown by the callable
 */
predicate callableOnlyThrowsArgumentNullException(Callable c) {
  forall(ThrowElement thre | c = thre.getEnclosingCallable() |
    thre.getThrownExceptionType().hasQualifiedName("System", "ArgumentNullException")
  )
}

/**
 * A specialization of `CallableAlwaysReturnsTrue` that takes into consideration exceptions being thrown for higher precision.
 */
class CallableAlwaysReturnsTrueHigherPrecision extends CallableAlwaysReturnsTrue {
  CallableAlwaysReturnsTrueHigherPrecision() {
    callableOnlyThrowsArgumentNullException(this) and
    (
      forall(Call call, Callable callable | call.getEnclosingCallable() = this |
        callable.getACall() = call and
        callable instanceof CallableAlwaysReturnsTrueHigherPrecision
      )
      or
      exists(AnonymousFunctionExpr le, Call call, CallableAlwaysReturnsTrueHigherPrecision cat |
        this = le
      |
        le.canReturn(call) and
        cat.getACall() = call
      )
      or
      exists(LambdaExpr le | le = this |
        le.getBody() instanceof CallableAlwaysReturnsTrueHigherPrecision
      )
    )
  }
}

/**
 * A callable that returns a `string` and has a `string` as 1st argument
 */
private class CallableReturnsStringAndArg0IsString extends Callable {
  CallableReturnsStringAndArg0IsString() {
    this.getReturnType() instanceof StringType and
    this.getParameter(0).getType() instanceof StringType
  }
}

/**
 * A Callable that always return the 1st argument, both of `string` type
 */
class CallableAlwaysReturnsParameter0 extends CallableReturnsStringAndArg0IsString {
  CallableAlwaysReturnsParameter0() {
    forex(Expr ret | this.canReturn(ret) |
      ret = this.getParameter(0).getAnAccess()
      or
      exists(CallableAlwaysReturnsParameter0 c |
        ret = c.getACall() and
        ret.(Call).getArgument(0) = this.getParameter(0).getAnAccess()
      )
    )
  }
}

/**
 * A Callable that always return the 1st argument, both of `string` type. Higher precision
 */
class CallableAlwaysReturnsParameter0MayThrowExceptions extends CallableReturnsStringAndArg0IsString {
  CallableAlwaysReturnsParameter0MayThrowExceptions() {
    forex(Expr ret | this.canReturn(ret) |
      ret = this.getParameter(0).getAnAccess()
      or
      exists(CallableAlwaysReturnsParameter0MayThrowExceptions c |
        ret = c.getACall() and
        ret.(Call).getArgument(0) = this.getParameter(0).getAnAccess()
      )
    )
  }
}

/**
 * Hold if the `Expr` e is a `BoolLiteral` with value true,
 * the expression has a predictable value == `true`,
 * or if it is a `ConditionalExpr` where the `then` and `else` expressions meet `isExpressionAlwaysTrue` criteria
 */
predicate isExpressionAlwaysTrue(Expr e) {
  e.(BoolLiteral).getBoolValue() = true
  or
  e.getValue() = "true"
  or
  e instanceof ConditionalExpr and
  isExpressionAlwaysTrue(e.(ConditionalExpr).getThen()) and
  isExpressionAlwaysTrue(e.(ConditionalExpr).getElse())
  or
  exists(Callable callable |
    callableHasAReturnStmtAndAlwaysReturnsTrue(callable) and
    callable.getACall() = e
  )
}

/**
 * Holds if the `Callable` c throws any exception other than `ThrowsArgumentNullException`
 */
predicate callableMayThrowException(Callable c) {
  exists(ThrowStmt thre | c = thre.getEnclosingCallable()) and
  not callableOnlyThrowsArgumentNullException(c)
}
