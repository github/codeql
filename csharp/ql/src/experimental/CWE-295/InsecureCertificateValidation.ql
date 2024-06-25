/**
 * @name Unsafe `CertificateValidationCallback` use.
 * @description Using a `CertificateValidationCallback` that always returns `true` is insecure, as it allows any certificate to be accepted as valid.
 * @kind alert
 * @problem.severity error
 * @precision high
 * @id cs/unsafe-certificate-validation
 * @tags security
 *       external/cwe/cwe-295
 *       external/cwe/cwe-297
 */

import csharp

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
Callable getActualCallable(Expr e) {
  exists(Expr dcArg | dcArg = e.(DelegateCreation).getArgument() |
    result = dcArg.(CallableAccess).getTarget() or result = dcArg.(AnonymousFunctionExpr)
  )
  or
  result = e.(Callable)
}

from Expr e, Callable c
where
  [
    any(SslStreamCreation yy).getServerCertificateValidationCallback(),
    any(CertificateValidationProperty xx).getAnAssignedValue()
  ] = e and
  getActualCallable(e) = c and
  alwaysReturnsTrue(c)
select e, "$@ that is defined $@ and accepts any certificate as valid, is used here.", e,
  "This certificate callback", c, "here"
