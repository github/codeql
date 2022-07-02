import csharp
import DataFlow

/**
 * An abstract PropertyWrite for `TokenValidationParameters`.
 * Not really necessary anymore, but keeping it in case we want to extend the queries to check on other properties.
 */
abstract class TokenValidationParametersPropertyWrite extends PropertyWrite { }

/**
 * An access to a sensitive property for `TokenValidationParameters` that updates the underlying value.
 */
class TokenValidationParametersPropertyWriteToBypassSensitiveValidation extends TokenValidationParametersPropertyWrite {
  TokenValidationParametersPropertyWriteToBypassSensitiveValidation() {
    exists(Property p, Class c |
      c.hasQualifiedName("Microsoft.IdentityModel.Tokens.TokenValidationParameters")
    |
      p.getAnAccess() = this and
      c.getAProperty() = p and
      p.getName() in [
          "ValidateIssuer", "ValidateAudience", "ValidateLifetime", "RequireExpirationTime", "RequireAudience"
        ]
    )
  }
}

/**
 * A dataflow from a `false` value to a write sensitive property for `TokenValidationParameters`.
 */
class FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation extends TaintTracking::Configuration {
  FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidation() {
    this = "FlowsToTokenValidationResultIsValidCall"
  }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr().getValue() = "false" and
    source.asExpr().getType() instanceof BoolType
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Assignment a | 
      sink.asExpr() = a.getRValue()
      and a.getLValue() instanceof TokenValidationParametersPropertyWrite
    )
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
    this.hasQualifiedName("Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken") or
    this.hasQualifiedName("Microsoft.AzureAD.DeviceIdentification.Common.Tokens.JwtValidator.ValidateEncryptedToken")
    //// TODO: ValidateEncryptedToken has the same behavior than ValidateToken, but it will be changed in a future release
    ////       The line below would allow to check if the ValidateEncryptedToken version used meets the minimum requirement
    ////       Once we have the fixed assembly version we can uncomment the line below
    // and isAssemblyOlderVersion("Microsoft.AzureAD.DeviceIdentification", "0.0.0")
  }
}

/**
 * A Call to `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken`
 */
class JsonWebTokenHandlerValidateTokenCall extends MethodCall {
  JsonWebTokenHandlerValidateTokenCall() {
    exists(JsonWebTokenHandlerValidateTokenMethod m | m.getACall() = this)
  }
}

/**
 * A read access for properties `IsValid` or `Exception` for `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken`
 */
class TokenValidationResultIsValidCall extends PropertyRead {
  TokenValidationResultIsValidCall() {
    exists(Property p | p.getAnAccess().(PropertyRead) = this |
      p.hasName("IsValid") or
      p.hasName("Exception")
    )
  }
}

/**
 * Dataflow from the output of `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken` call to access the `IsValid` or `Exception` property
 */
private class FlowsToTokenValidationResultIsValidCall extends TaintTracking::Configuration {
  FlowsToTokenValidationResultIsValidCall() { this = "FlowsToTokenValidationResultIsValidCall" }

  override predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof JsonWebTokenHandlerValidateTokenCall
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(TokenValidationResultIsValidCall call | sink.asExpr() = call.getQualifier())
  }
}

/**
 * Holds if the call to `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken` flows to any `IsValid` or `Exception` property access
 */
predicate hasAFlowToTokenValidationResultIsValidCall(JsonWebTokenHandlerValidateTokenCall call) {
  exists(FlowsToTokenValidationResultIsValidCall config, DataFlow::Node source |
    call = source.asExpr()
  |
    config.hasFlow(source, _)
  )
}

/**
 * A property write for security-sensitive properties for `Microsoft.IdentityModel.Tokens.TokenValidationParameters`
 */
class TokenValidationParametersPropertyWriteToValidationDelegated extends PropertyWrite {
  TokenValidationParametersPropertyWriteToValidationDelegated() {
    exists(Property p, Class c |
      c.hasQualifiedName("Microsoft.IdentityModel.Tokens.TokenValidationParameters")
    |
      p.getAnAccess() = this and
      c.getAProperty() = p and
      p.getName() in [
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
  c.getReturnType().toString() = "Boolean" and
  forall(ReturnStmt rs | rs.getEnclosingCallable() = c |
    rs.getChildExpr(0).(BoolLiteral).getBoolValue() = true
  ) and
  exists(ReturnStmt rs | rs.getEnclosingCallable() = c)
}

/**
 * Holds if the lambda expression `le` always returns true
 */
predicate lambdaExprReturnsOnlyLiteralTrue(LambdaExpr le) {
  le.getExpressionBody().(BoolLiteral).getBoolValue() = true
}

class CallableAlwaysReturnsTrue extends Callable {
  CallableAlwaysReturnsTrue() {
    callableHasAReturnStmtAndAlwaysReturnsTrue(this)
    or
    lambdaExprReturnsOnlyLiteralTrue(this)
    or
    exists(LambdaExpr le, Call call, CallableAlwaysReturnsTrue cat | this = le |
      call = le.getExpressionBody() and
      cat.getACall() = call
    )
  }
}

/**
 * Holds if any exception being thrown by the callable is of type `System.ArgumentNullException`
 * It will also hold if no exceptions are thrown by the callable
 */
predicate callableOnlyThrowsArgumentNullException(Callable c) {
  forall(ThrowElement thre | c = thre.getEnclosingCallable() |
    thre.getThrownExceptionType().hasQualifiedName("System.ArgumentNullException")
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
      exists(LambdaExpr le, Call call, CallableAlwaysReturnsTrueHigherPrecision cat | this = le |
        call = le.getExpressionBody() and
        cat.getACall() = call
      )
    )
  }
}

/**
 * A property Write for the `IssuerValidator` property for `Microsoft.IdentityModel.Tokens.TokenValidationParameters`
 */
class TokenValidationParametersPropertyWriteToValidationDelegatedIssuerValidator extends PropertyWrite {
  TokenValidationParametersPropertyWriteToValidationDelegatedIssuerValidator() {
    exists(Property p, Class c |
      c.hasQualifiedName("Microsoft.IdentityModel.Tokens.TokenValidationParameters")
    |
      p.getAnAccess() = this and
      c.getAProperty() = p and
      p.hasName("IssuerValidator")
    )
  }
}

/**
 * A callable that returns a `string` and has a `string` as 1st argument
 */
private class CallableReturnsStringAndArg0IsString extends Callable {
  CallableReturnsStringAndArg0IsString() {
    this.getReturnType() instanceof StringType and
    this.getParameter(0).getType().toString() = "String"
  }
}

/**
 * A Callable that always return the 1st argument, both of `string` type
 */
class CallableAlwaysReturnsParameter0 extends CallableReturnsStringAndArg0IsString {
  CallableAlwaysReturnsParameter0() {
    forall(ReturnStmt rs | rs.getEnclosingCallable() = this |
      rs.getChild(0) = this.getParameter(0).getAnAccess()
    ) and
    exists(ReturnStmt rs | rs.getEnclosingCallable() = this)
    or
    exists(LambdaExpr le, Call call, CallableAlwaysReturnsParameter0 cat | this = le |
      call = le.getExpressionBody() and
      cat.getACall() = call
    )
    or
    this.getBody() = this.getParameter(0).getAnAccess()
  }
}

/**
 * A Callable that always return the 1st argument, both of `string` type. Higher precision
 */
class CallableAlwaysReturnsParameter0MayThrowExceptions extends CallableReturnsStringAndArg0IsString {
  CallableAlwaysReturnsParameter0MayThrowExceptions() {
    callableOnlyThrowsArgumentNullException(this) and
    forall(ReturnStmt rs | rs.getEnclosingCallable() = this |
      rs.getChild(0) = this.getParameter(0).getAnAccess()
    ) and
    exists(ReturnStmt rs | rs.getEnclosingCallable() = this)
    or
    exists(LambdaExpr le, Call call, CallableAlwaysReturnsParameter0MayThrowExceptions cat |
      this = le
    |
      call = le.getExpressionBody() and
      cat.getACall() = call and
      callableOnlyThrowsArgumentNullException(le) and
      callableOnlyThrowsArgumentNullException(cat)
    )
    or
    this.getBody() = this.getParameter(0).getAnAccess()
  }
}
