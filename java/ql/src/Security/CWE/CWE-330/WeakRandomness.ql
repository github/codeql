/**
 * @name Weak Randomness
 * @description Using a weak source of randomness may allow an attacker to predict the generated values.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 8.6
 * @precision high
 * @id java/weak-randomness
 * @tags security
 *      external/cwe/cwe-330
 *      external/cwe/cwe-338
 */

import java
import semmle.code.java.frameworks.Servlets
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.security.RandomQuery
import WeakRandomnessFlow::PathGraph

/**
 * The `java.util.Random` class.
 */
class TypeRandom extends RefType {
  TypeRandom() { this.hasQualifiedName("java.util", "Random") }
}

abstract class WeakRandomnessSource extends DataFlow::Node { }

private class JavaRandomSource extends WeakRandomnessSource {
  JavaRandomSource() {
    this.asExpr().getType() instanceof TypeRandom and this.asExpr() instanceof ConstructorCall
  }
}

private class MathRandomMethodAccess extends WeakRandomnessSource {
  MathRandomMethodAccess() {
    exists(MethodAccess ma | this.asExpr() = ma |
      ma.getMethod().hasName("random") and
      ma.getMethod().getDeclaringType().hasQualifiedName("java.lang", "Math")
    )
  }
}

abstract private class SafeRandomImplementation extends RefType { }

private class TypeSecureRandom extends SafeRandomImplementation {
  TypeSecureRandom() { this.hasQualifiedName("java.security", "SecureRandom") }
}

private class TypeHadoopOsSecureRandom extends SafeRandomImplementation {
  TypeHadoopOsSecureRandom() {
    this.hasQualifiedName("org.apache.hadoop.crypto.random", "OsSecureRandom")
  }
}

abstract class WeakRandomnessAdditionalTaintStep extends Unit {
  abstract predicate step(DataFlow::Node node1, DataFlow::Node node2);
}

abstract class WeakRandomnessSink extends DataFlow::Node { }

private class CookieSink extends WeakRandomnessSink {
  CookieSink() {
    this.asExpr().getType() instanceof TypeCookie and
    exists(MethodAccess ma | ma.getMethod().hasName("addCookie") |
      ma.getArgument(0) = this.asExpr()
    )
  }
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

  predicate isAdditionalFlowStep(DataFlow::Node n1, DataFlow::Node n2) {
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

module WeakRandomnessFlow = TaintTracking::Global<WeakRandomnessConfig>;

from WeakRandomnessFlow::PathNode source, WeakRandomnessFlow::PathNode sink
where WeakRandomnessFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Potential weak randomness due to a $@.", source.getNode(),
  "weak randomness source."
