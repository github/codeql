/** Provides classes and predicates for reasoning about weak randomness. */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.security.SensitiveActions
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.RandomQuery

/**
 * The `java.util.Random` class.
 */
class TypeRandom extends RefType {
  TypeRandom() { this.hasQualifiedName("java.util", "Random") }
}

/**
 * A node representing a source of weak randomness.
 *
 * For example, use of `java.util.Random` or `java.lang.Math.random`.
 */
abstract class WeakRandomnessSource extends DataFlow::Node { }

/**
 * A node representing a call to a constructor of `java.util.Random`.
 */
private class JavaRandomSource extends WeakRandomnessSource {
  JavaRandomSource() {
    this.asExpr().getType() instanceof TypeRandom and this.asExpr() instanceof ConstructorCall
  }
}

private class ApacheRandomStringUtilsMethodAccessSource extends WeakRandomnessSource {
  ApacheRandomStringUtilsMethodAccessSource() {
    exists(MethodAccess ma | this.asExpr() = ma |
      ma.getMethod()
          .hasName([
              "random", "randomAlphabetic", "randomAlphanumeric", "randomAscii", "randomGraph",
              "randomNumeric", "randomPrint"
            ]) and
      ma.getMethod()
          .getDeclaringType()
          .hasQualifiedName("org.apache.commons.lang", "RandomStringUtils")
    )
  }
}

/**
 * The `random` method of `java.lang.Math`.
 */
private class MathRandomMethodAccess extends WeakRandomnessSource {
  MathRandomMethodAccess() {
    exists(MethodAccess ma | this.asExpr() = ma |
      ma.getMethod().hasName("random") and
      ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "Math")
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
    this.asExpr().getType() instanceof TypeCookie and
    exists(MethodAccess ma | ma.getMethod().hasName("addCookie") |
      ma.getArgument(0) = this.asExpr()
    )
  }
}

private class SensitiveActionSink extends WeakRandomnessSink {
  SensitiveActionSink() { this.asExpr() instanceof SensitiveExpr }
}

/**
 * Holds if there is a method access which converts `bytes` to the string `str`.
 */
private predicate covertsBytesToString(DataFlow::Node bytes, DataFlow::Node str) {
  bytes.getType().(Array).getElementType().(PrimitiveType).hasName("byte") and
  str.getType() instanceof TypeString and
  exists(MethodAccess ma | ma = str.asExpr() | bytes.asExpr() = ma.getAnArgument())
}

/**
 * A taint-tracking configuration for weak randomness.
 */
module WeakRandomnessConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof WeakRandomnessSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof WeakRandomnessSink }

  predicate isBarrier(DataFlow::Node n) { n.getTypeBound() instanceof SafeRandomImplementation }

  predicate isBarrierIn(DataFlow::Node n) { isSource(n) }

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
    n1.asExpr() = n2.asExpr().(BinaryExpr).getAnOperand()
    or
    n1.asExpr() = n2.asExpr().(UnaryExpr).getExpr()
    or
    exists(MethodAccess ma, Method m |
      n1.asExpr() = ma.getQualifier() and
      ma.getMethod() = m and
      m.getDeclaringType() instanceof TypeRandom and
      (
        m.hasName(["nextInt", "nextLong", "nextFloat", "nextDouble", "nextBoolean", "nextGaussian"]) and
        n2.asExpr() = ma
        or
        m.hasName("nextBytes") and
        n2.(DataFlow::PostUpdateNode).getPreUpdateNode().asExpr() = ma.getArgument(0)
      )
    )
    or
    covertsBytesToString(n1, n2)
  }
}

/**
 * Taint-tracking flow of a weakly random value into a sensitive sink.
 */
module WeakRandomnessFlow = TaintTracking::Global<WeakRandomnessConfig>;
