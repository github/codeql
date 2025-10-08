import csharp
import DataFlow

/**
 * Abstract PropertyWrite for `TokenValidationParameters`.
 * Not really necessary anymore, but keeping it in case we want to extend the queries to check on other properties.
 */
abstract class TokenValidationParametersPropertyWrite extends PropertyWrite { }

/**
 * An access to a sensitive property for `TokenValidationParameters` that updates the underlying value.
 */
class TokenValidationParametersPropertyWriteToBypassSensitiveValidation extends TokenValidationParametersPropertyWrite {
  TokenValidationParametersPropertyWriteToBypassSensitiveValidation() {
    exists(Property p, Class c |
      c.hasFullyQualifiedName("Microsoft.IdentityModel.Tokens", "TokenValidationParameters")
    |
      p.getAnAccess() = this and
      c.getAProperty() = p and
      p.getName() in [
          "ValidateIssuer", "ValidateAudience", "ValidateLifetime", "RequireExpirationTime"
        ]
    )
  }
}

/**
 * Dataflow from a `false` value to an to a write sensitive property for `TokenValidationParameters`.
 */
private module FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr().(BoolLiteral).getValue() = "false"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(TokenValidationParametersPropertyWrite pw, Assignment a | a.getLValue() = pw |
      sink.asExpr() = a.getRValue()
    )
  }
}
module FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidationTT = TaintTracking::Global<FalseValueFlowsToTokenValidationParametersPropertyWriteToBypassValidationConfig>;

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
 * Method `ValidateToken` for `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler` or other Token handler that shares the same behavior characteristics
 */
class JsonWebTokenHandlerValidateTokenMethod extends Method {
  JsonWebTokenHandlerValidateTokenMethod() {
    this.hasFullyQualifiedName("Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler", "ValidateToken") or
    this.hasFullyQualifiedName("Microsoft.AzureAD.DeviceIdentification.Common.Tokens.JwtValidator", "ValidateEncryptedToken")
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
 * Read access for properties `IsValid` or `Exception` for `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken`
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
private module FlowsToTokenValidationResultIsValidCallConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.asExpr() instanceof JsonWebTokenHandlerValidateTokenCall
  }

  predicate isSink(DataFlow::Node sink) {
    exists(TokenValidationResultIsValidCall call | sink.asExpr() = call.getQualifier())
  }
}
private module FlowsToTokenValidationResultIsValidCallTT = TaintTracking::Global<FlowsToTokenValidationResultIsValidCallConfig>;

/**
 * Holds if the call to `Microsoft.IdentityModel.JsonWebTokens.JsonWebTokenHandler.ValidateToken` flows to any `IsValid` or `Exception` property access
 */
predicate hasAFlowToTokenValidationResultIsValidCall(JsonWebTokenHandlerValidateTokenCall call) {
  exists(DataFlow::Node source | call = source.asExpr() |
    FlowsToTokenValidationResultIsValidCallTT::flow(source, _)
  )
}

/**
 * Property write for security-sensitive properties for `Microsoft.IdentityModel.Tokens.TokenValidationParameters`
 */
class TokenValidationParametersPropertyWriteToValidationDelegated extends PropertyWrite {
  TokenValidationParametersPropertyWriteToValidationDelegated() {
    exists(Property p, Class c |
      c.hasFullyQualifiedName("Microsoft.IdentityModel.Tokens", "TokenValidationParameters")
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
predicate callableHasARetrunStmtAndAlwaysReturnsTrue(Callable c) {
  c.getReturnType().toString() = "Boolean" and
  forex(ReturnStmt rs | rs.getEnclosingCallable() = c |
    rs.getChildExpr(0).(BoolLiteral).getBoolValue() = true
  )
}

/**
 * Holds if the lambda expression `le` always returns true
 */
predicate lambdaExprReturnsOnlyLiteralTrue(LambdaExpr le) {
  le.getExpressionBody().(BoolLiteral).getBoolValue() = true
}

class CallableAlwaysReturnsTrue extends Callable {
  CallableAlwaysReturnsTrue() {
    callableHasARetrunStmtAndAlwaysReturnsTrue(this)
    or
    lambdaExprReturnsOnlyLiteralTrue(this)
  }
}

/**
 * Holds if any exception being thrown by the callable is of type `System.ArgumentNullException`
 * It will also hold if no exceptions are thrown by the callable
 */
class OnlyNullExceptionThrowingCallable extends Callable{
  OnlyNullExceptionThrowingCallable(){
    forall(ThrowElement thre | this = thre.getEnclosingCallable() |
      thre.getThrownExceptionType().hasFullyQualifiedName("System", "ArgumentNullException")
    ) and
    // Implicitly-called throws in callstack
    forall(Call call, Callable callable | this.getAChild*() = call and call.getTarget() = callable |
      callable instanceof OnlyNullExceptionThrowingCallable
    )
  }
}

/**
 * Holds if the callable can throw an exception of type `System.Exception` or subclass.
 * It will *not* hold if no exceptions are thrown by the callable.
 */
predicate callableThrowsException(Callable c) {
  exists(ThrowElement thre | c = thre.getEnclosingCallable() |
    thre.getThrownExceptionType().getABaseType*().hasFullyQualifiedName("System", "Exception")
  )
}

abstract class AbstractCallableAlwaysReturnsTrueHigherPrecision extends Callable{}

/**
 * A superset of of `CallableAlwaysReturnsTrue` that takes into account aliases and nested callgraphs, and exceptions.
 */
class CallableAlwaysReturnsTrueHigherPrecision extends AbstractCallableAlwaysReturnsTrueHigherPrecision, OnlyNullExceptionThrowingCallable {
  CallableAlwaysReturnsTrueHigherPrecision() {
    this instanceof CallableAlwaysReturnsTrue
    or
    forex(Call call, Callable callable | call.getEnclosingCallable() = this and callable.getACall() = call |
      callable instanceof AbstractCallableAlwaysReturnsTrueHigherPrecision
    )
    or
    exists(LambdaExpr le, Call call, AbstractCallableAlwaysReturnsTrueHigherPrecision cat | this = le and call = le.getExpressionBody() |
      cat.getACall() = call
    )
  }
}

/**
 * Property Write for the `IssuerValidator` property for `Microsoft.IdentityModel.Tokens.TokenValidationParameters`
 */
class TokenValidationParametersPropertyWriteToValidationDelegatedIssuerValidator extends PropertyWrite {
  TokenValidationParametersPropertyWriteToValidationDelegatedIssuerValidator() {
    this.getProperty().hasFullyQualifiedName("Microsoft.IdentityModel.Tokens.TokenValidationParameters", "IssuerValidator")
  }
}

/**
 * Property Write for the `SignatureValidator` property for `Microsoft.IdentityModel.Tokens.TokenValidationParameters`
 */
class TokenValidationParametersPropertyWriteToValidationDelegatedSignatureValidator extends PropertyWrite {
  TokenValidationParametersPropertyWriteToValidationDelegatedSignatureValidator() {
    this.getProperty().hasFullyQualifiedName("Microsoft.IdentityModel.Tokens.TokenValidationParameters", "SignatureValidator")
  }
}

/**
 * A callable that returns a `string` and has a `string` as 1st argument
 */
private class CallableReturnsStringAndArg0IsString extends Callable {
  CallableReturnsStringAndArg0IsString() {
    this.getReturnType().toString() = "String" and
    this.getParameter(0).getType().toString() = "String"
  }
}

/**
 * A Callable that always retrun the 1st argument, both of `string` type
 */
class CallableAlwatsReturnsParameter0 extends CallableReturnsStringAndArg0IsString {
  CallableAlwatsReturnsParameter0() {
    forex(ReturnStmt rs | rs.getEnclosingCallable() = this |
      rs.getChild(0) = this.getParameter(0).getAnAccess()
    )
    or
    exists(LambdaExpr le, Call call, CallableAlwatsReturnsParameter0 cat |
      this = le and
      call = le.getExpressionBody() and
      cat.getACall() = call
    )
    or
    this.getBody() = this.getParameter(0).getAnAccess()
  }
}

/**
 * A Callable that always retrun the 1st argument, both of `string` type. Higher precision
 */
class CallableAlwaysReturnsParameter0MayThrowExceptions extends CallableReturnsStringAndArg0IsString {
  CallableAlwaysReturnsParameter0MayThrowExceptions() {
    this instanceof OnlyNullExceptionThrowingCallable and
    forex(ReturnStmt rs | rs.getEnclosingCallable() = this |
      rs.getChild(0) = this.getParameter(0).getAnAccess()
    )
    or
    exists(LambdaExpr le, Call call, CallableAlwaysReturnsParameter0MayThrowExceptions cat |
      this = le and
      call = le.getExpressionBody() and
      cat.getACall() = call and
      le instanceof OnlyNullExceptionThrowingCallable and
      cat instanceof OnlyNullExceptionThrowingCallable
    )
    or
    this.getBody() = this.getParameter(0).getAnAccess()
  }
}

/**
 * Returns the fully qualified name of the given element, with a period `.` between the namespace and the identifier.
 */
pragma[inline]
string getFullyQualifiedName(NamedElement e) {
  exists(string a, string b |
    e.hasFullyQualifiedName(a, b) and
    if a = "" then result = b else result = a + "." + b
  )
}