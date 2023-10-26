/** Provides classes and predicates for reasoning about weak randomness. */

import java
private import semmle.code.java.frameworks.Servlets
private import semmle.code.java.security.SensitiveActions
private import semmle.code.java.security.SensitiveApi
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.security.RandomQuery

/**
 * A node representing a source of weak randomness.
 *
 * For example, use of `java.util.Random` or `java.lang.Math.random`.
 */
abstract class WeakRandomnessSource extends DataFlow::Node { }

private class RandomMethodSource extends WeakRandomnessSource {
  RandomMethodSource() {
    exists(RandomDataSource s | this.asExpr() = s.getOutput() |
      not s.getQualifier().getType() instanceof SafeRandomImplementation
    )
  }
}

/**
 * A type which is an implementation of `java.util.Random` but considered to be safe.
 *
 * For example, `java.security.SecureRandom`.
 */
abstract private class SafeRandomImplementation extends RefType { }

private class TypeSecureRandom extends SafeRandomImplementation {
  TypeSecureRandom() { this.hasQualifiedName("java.security", "SecureRandom") }
}

private class TypeHadoopOsSecureRandom extends SafeRandomImplementation {
  TypeHadoopOsSecureRandom() {
    this.hasQualifiedName("org.apache.hadoop.crypto.random", "OsSecureRandom")
  }
}

/**
 * A node representing an operation which should not use a weakly random value.
 */
abstract class WeakRandomnessSink extends DataFlow::Node { }

/**
 * A node which creates a cookie.
 */
private class CookieSink extends WeakRandomnessSink {
  CookieSink() {
    this.getType() instanceof TypeCookie and
    exists(MethodCall mc |
      mc.getMethod().hasQualifiedName("javax.servlet.http", "HttpServletResponse", "addCookie")
    |
      mc.getArgument(0) = this.asExpr()
    )
  }
}

private class SensitiveActionSink extends WeakRandomnessSink {
  SensitiveActionSink() { this.asExpr() instanceof SensitiveExpr }
}

private class CredentialsSink extends WeakRandomnessSink instanceof CredentialsSinkNode { }

/**
 * A taint-tracking configuration for weak randomness.
 */
module WeakRandomnessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof WeakRandomnessSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof WeakRandomnessSink }

  predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    n1.asExpr() = n2.asExpr().(BinaryExpr).getAnOperand()
    or
    n1.asExpr() = n2.asExpr().(UnaryExpr).getExpr()
  }
}

/**
 * Taint-tracking flow of a weakly random value into a sensitive sink.
 */
module WeakRandomnessFlow = TaintTracking::Global<WeakRandomnessConfig>;
