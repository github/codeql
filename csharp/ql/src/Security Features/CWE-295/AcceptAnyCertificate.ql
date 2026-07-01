/**
 * @name Accepting any TLS certificate during validation
 * @description A certificate validation callback that always accepts any certificate
 *              allows an attacker to perform a machine-in-the-middle attack.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.5
 * @precision high
 * @id cs/accept-any-certificate
 * @tags security
 *       external/cwe/cwe-295
 */

import csharp
import semmle.code.csharp.dataflow.DataFlow::DataFlow
import AcceptAnyCertificate::PathGraph

/**
 * Holds if `c` always returns `true` and never returns `false`, i.e. it accepts
 * every input it is given.
 */
predicate alwaysReturnsTrue(Callable c) {
  c.getReturnType() instanceof BoolType and
  // There is at least one returned value, and every returned value is the
  // constant `true`.
  forex(Expr ret | c.canReturn(ret) | ret.getValue() = "true")
}

/**
 * A delegate type used as a TLS/SSL certificate validation callback. Such a
 * delegate returns a `bool` (whether the certificate is trusted) and takes a
 * `System.Net.Security.SslPolicyErrors` parameter describing any validation
 * errors that were found. This covers `RemoteCertificateValidationCallback` as
 * well as the `Func<..., SslPolicyErrors, bool>` callbacks used by, for example,
 * `HttpClientHandler.ServerCertificateCustomValidationCallback`.
 */
class CertificateValidationCallbackType extends DelegateType {
  CertificateValidationCallbackType() {
    this.getReturnType() instanceof BoolType and
    this.getAParameter().getType().hasFullyQualifiedName("System.Net.Security", "SslPolicyErrors")
  }
}

/**
 * Gets a callable that always accepts any certificate, referenced by the
 * delegate-producing expression `e`.
 */
Callable getAcceptingCallable(Expr e) {
  // A lambda or anonymous method, e.g. `(sender, cert, chain, errors) => true`.
  result = e and
  alwaysReturnsTrue(e)
  or
  // A method group, e.g. `AcceptAllCertificates`, possibly wrapped in an
  // (implicit or explicit) delegate creation.
  result = e.(DelegateCreation).getArgument().(CallableAccess).getTarget() and
  alwaysReturnsTrue(result)
  or
  result = e.(CallableAccess).getTarget() and
  alwaysReturnsTrue(result)
}

module AcceptAnyCertificateConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(getAcceptingCallable(source.asExpr()))
    or
    // `HttpClientHandler.DangerousAcceptAnyServerCertificateValidator` is a
    // built-in callback that accepts every certificate.
    source
        .asExpr()
        .(PropertyAccess)
        .getTarget()
        .hasName("DangerousAcceptAnyServerCertificateValidator")
  }

  predicate isSink(DataFlow::Node sink) {
    // The value assigned to a property, field or local of certificate
    // validation callback type.
    exists(Assignable a |
      a.getType() instanceof CertificateValidationCallbackType and
      sink.asExpr() = a.getAnAssignedValue()
    )
    or
    // The value passed as a certificate validation callback argument, e.g. to
    // the `SslStream` constructor.
    exists(Call call, Parameter p |
      p = call.getTarget().getAParameter() and
      p.getType() instanceof CertificateValidationCallbackType and
      sink.asExpr() = call.getArgumentForParameter(p)
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module AcceptAnyCertificate = DataFlow::Global<AcceptAnyCertificateConfig>;

from AcceptAnyCertificate::PathNode source, AcceptAnyCertificate::PathNode sink
where AcceptAnyCertificate::flowPath(source, sink)
select sink.getNode(), source, sink,
  "This TLS certificate validation $@, which trusts any certificate.", source.getNode(),
  "uses a callback"
