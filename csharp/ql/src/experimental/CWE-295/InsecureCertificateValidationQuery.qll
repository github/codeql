/**
 * Provides a taint-tracking configuration for reasoning
 * about insecure certificate validation vulnerabilities.
 */

private import csharp
private import DataFlow
private import semmle.code.csharp.controlflow.Guards

/**
 * A source specific to unsafe certificate validation vulnerabilities.
 */
abstract private class Source extends DataFlow::Node { }

/**
 * A sink specific to unsafe certificate validation vulnerabilities.
 */
abstract private class Sink extends DataFlow::Node { }

/**
 * A sanitizer specific to unsafe certificate validation vulnerabilities.
 */
abstract private class Sanitizer extends DataFlow::ExprNode { }

/**
 * Provides an abstract base class for properties related to certificate validation.
 */
abstract private class CertificateValidationProperty extends Property { }

/**
 * Represents the `ServerCertificateValidationCallback` property of the `ServicePointManager` class.
 */
private class ServicePointManagerServerCertificateValidationCallback extends CertificateValidationProperty
{
  ServicePointManagerServerCertificateValidationCallback() {
    this.getDeclaringType().hasFullyQualifiedName("System.Net", "ServicePointManager") and
    this.hasName("ServerCertificateValidationCallback")
  }
}

/**
 * Represents the `ServerCertificateCustomValidationCallback` property of the `HttpClientHandler` class.
 */
private class HttpClientHandlerServerCertificateCustomValidationCallback extends CertificateValidationProperty
{
  HttpClientHandlerServerCertificateCustomValidationCallback() {
    this.getDeclaringType().hasFullyQualifiedName("System.Net.Http", "HttpClientHandler") and
    this.hasName("ServerCertificateCustomValidationCallback")
  }
}

/**
 * Represents the `ServerCertificateValidationCallback` property of the `HttpWebRequest` class.
 */
private class HttpWebRequestServerCertificateValidationCallback extends CertificateValidationProperty
{
  HttpWebRequestServerCertificateValidationCallback() {
    this.getDeclaringType().hasFullyQualifiedName("System.Net", "HttpWebRequest") and
    this.hasName("ServerCertificateValidationCallback")
  }
}

/**
 * Represents the creation of an `SslStream` object.
 */
private class SslStreamCreation extends ObjectCreation {
  SslStreamCreation() {
    this.getObjectType().hasFullyQualifiedName("System.Net.Security", "SslStream")
  }

  /**
   * Gets the expression used as the server certificate validation callback argument
   * in the creation of the `SslStream` object.
   */
  Expr getServerCertificateValidationCallback() { result = this.getArgument(2) }
}

/**
 * Holds if `c` always returns `true`.
 */
private predicate alwaysReturnsTrue(Callable c) {
  forex(ReturnStmt rs | rs.getEnclosingCallable() = c |
    rs.getExpr().(BoolLiteral).getBoolValue() = true
  )
  or
  c.getBody().(BoolLiteral).getBoolValue() = true
}

/**
 * Gets the actual callable object referred to by expression `e`.
 * This can be a direct reference to a callable, a delegate creation, or an anonymous function.
 */
private Callable getActualCallable(Expr e) {
  exists(Expr dcArg | dcArg = e.(DelegateCreation).getArgument() |
    result = dcArg.(CallableAccess).getTarget() or
    result = dcArg.(AnonymousFunctionExpr)
  )
  or
  result = e
}

private predicate ignoreCertificateValidation(Guard guard, AbstractValue v) {
  guard =
    any(PropertyAccess access |
      access.getProperty().hasFullyQualifiedName("", "Settings", "IgnoreCertificateValidation") and
      v.(AbstractValues::BooleanValue).getValue() = true
    )
}

private class AddIgnoreCheck extends Sanitizer {
  AddIgnoreCheck() {
    exists(Guard g, AbstractValues::BooleanValue v | ignoreCertificateValidation(g, v) |
      g.controlsNode(this.getControlFlowNode(), v)
    )
  }
}

private class CallableAlwaysReturnsTrue extends Callable {
  CallableAlwaysReturnsTrue() { alwaysReturnsTrue(this) }
}

private class AddCallableAlwaysReturnsTrue extends Source {
  AddCallableAlwaysReturnsTrue() {
    getActualCallable(this.asExpr()) instanceof CallableAlwaysReturnsTrue
  }
}

private class AddSinks extends Sink {
  AddSinks() {
    exists(Expr e | e = this.asExpr() |
      e =
        [
          any(CertificateValidationProperty p).getAnAssignedValue(),
          any(SslStreamCreation yy).getServerCertificateValidationCallback()
        ] and
      not e.getFile().getAbsolutePath().matches("example")
    )
  }
}

private module InsecureCertificateValidationConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isBarrier(DataFlow::Node node) { node instanceof Sanitizer }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }
}

/**
 * A taint-tracking module for insecure certificate validation vulnerabilities.
 */
module InsecureCertificateValidation = TaintTracking::Global<InsecureCertificateValidationConfig>;
