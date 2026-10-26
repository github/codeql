/** Classes to represent sanitizers commonly used in dataflow and taint tracking configurations. */
overlay[local?]
module;

import java
private import semmle.code.java.controlflow.Guards
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.frameworks.Regex

/**
 * A node whose type is a simple type unlikely to carry taint, such as primitives and their boxed counterparts,
 * `java.util.UUID` and `java.util.Date`.
 */
class SimpleTypeSanitizer extends DataFlow::Node {
  SimpleTypeSanitizer() {
    this.getType() instanceof PrimitiveType or
    this.getType() instanceof BoxedType or
    this.getType() instanceof NumberType or
    this.getType().(RefType).hasQualifiedName("java.util", "UUID") or
    this.getType().(RefType).getASourceSupertype*().hasQualifiedName("java.util", "Date") or
    this.getType().(RefType).hasQualifiedName("java.util", "Calendar") or
    this.getType().(RefType).hasQualifiedName("java.util", "BitSet") or
    this.getType()
        .(RefType)
        .getASourceSupertype*()
        .hasQualifiedName("java.time.temporal", "TemporalAmount") or
    this.getType()
        .(RefType)
        .getASourceSupertype*()
        .hasQualifiedName("java.time.temporal", "TemporalAccessor") or
    this.getType() instanceof EnumType
  }
}

/**
 * Holds if `guard` holds with branch `branch` if `e` matches a regular expression.
 *
 * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
 *
 * This holds for both method-call and annotation regular-expression matches.
 * Method-call matches yield barrier nodes via ordinary control-flow dominance,
 * while annotation matches are treated as direct barriers by
 * `DataFlow::BarrierGuard`, since an annotation does not dominate the
 * expression it constrains.
 */
predicate regexpMatchGuardChecks(Guard guard, Expr e, boolean branch) {
  exists(RegexMatch rm |
    guard = rm and
    e = rm.getASanitizedExpr() and
    branch = true
  )
}

/**
 * A check against a regular expression, considered as a barrier guard.
 *
 * This is overapproximate: we do not attempt to reason about the correctness of the regexp.
 */
class RegexpCheckBarrier extends DataFlow::Node {
  RegexpCheckBarrier() {
    this = DataFlow::BarrierGuard<regexpMatchGuardChecks/3>::getABarrierNode()
  }
}

/**
 * A method call for encrypting, hashing, or digesting sensitive information. As there are various
 * implementations of encryption (reversible and non-reversible) from both JDK and third parties,
 * this class simply checks the method name to take a best guess to reduce false positives.
 */
class EncryptedSensitiveMethodCall extends MethodCall {
  EncryptedSensitiveMethodCall() {
    this.getMethod().getName().toLowerCase().matches(["%encrypt%", "%hash%", "%digest%"])
  }
}
