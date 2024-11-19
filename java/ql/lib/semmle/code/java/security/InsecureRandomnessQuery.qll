/** Provides classes and predicates for reasoning about insecure randomness. */

import java
private import semmle.code.java.frameworks.OpenSaml
private import semmle.code.java.frameworks.Servlets
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSinks
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.security.Cookies
private import semmle.code.java.security.RandomQuery
private import semmle.code.java.security.SensitiveActions
private import semmle.code.java.security.SensitiveApi

/**
 * A node representing a source of insecure randomness.
 *
 * For example, use of `java.util.Random` or `java.lang.Math.random`.
 */
abstract class InsecureRandomnessSource extends DataFlow::Node { }

private class RandomMethodSource extends InsecureRandomnessSource {
  RandomMethodSource() {
    exists(RandomDataSource s | this.asExpr() = s.getOutput() |
      not s.getSourceOfRandomness() instanceof SafeRandomImplementation
    )
  }
}

/**
 * A type which is an implementation of `java.util.Random` but considered to be safe.
 *
 * For example, `java.security.SecureRandom`.
 */
abstract private class SafeRandomImplementation extends RefType { }

private class TypeSecureRandom extends SafeRandomImplementation instanceof SecureRandomNumberGenerator
{ }

private class TypeHadoopOsSecureRandom extends SafeRandomImplementation {
  TypeHadoopOsSecureRandom() {
    this.hasQualifiedName("org.apache.hadoop.crypto.random", "OsSecureRandom")
  }
}

/**
 * A node representing an operation which should not use an insecurely random value.
 */
abstract class InsecureRandomnessSink extends DataFlow::Node { }

/**
 * A node which sets the value of a cookie.
 */
private class CookieSink extends InsecureRandomnessSink, ApiSinkNode {
  CookieSink() { this.asExpr() instanceof SetCookieValue }
}

private class SensitiveActionSink extends InsecureRandomnessSink {
  SensitiveActionSink() { this.asExpr() instanceof SensitiveExpr }
}

private class CredentialsSink extends InsecureRandomnessSink instanceof CredentialsSinkNode { }

/**
 * A taint-tracking configuration for Insecure randomness.
 */
module InsecureRandomnessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof InsecureRandomnessSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof InsecureRandomnessSink }

  predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  predicate isBarrierOut(DataFlow::Node n) { isSink(n) }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    n1.asExpr() = n2.asExpr().(BinaryExpr).getAnOperand()
    or
    n1.asExpr() = n2.asExpr().(UnaryExpr).getExpr()
    or
    exists(MethodCall mc, string methodName |
      mc.getMethod().hasQualifiedName("org.owasp.esapi", "Encoder", methodName) and
      methodName.matches("encode%")
    |
      n1.asExpr() = mc.getArgument(0) and
      n2.asExpr() = mc
    )
    or
    // TODO: Once we have a default sanitizer for UUIDs, we can convert these to global summaries.
    exists(Call c |
      c.(ClassInstanceExpr).getConstructedType().hasQualifiedName("java.util", "UUID") and
      n1.asExpr() = c.getAnArgument() and
      n2.asExpr() = c
      or
      c.(MethodCall).getMethod().hasQualifiedName("java.util", "UUID", "toString") and
      n1.asExpr() = c.getQualifier() and
      n2.asExpr() = c
    )
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

/**
 * Taint-tracking flow of a Insecurely random value into a sensitive sink.
 */
module InsecureRandomnessFlow = TaintTracking::Global<InsecureRandomnessConfig>;
