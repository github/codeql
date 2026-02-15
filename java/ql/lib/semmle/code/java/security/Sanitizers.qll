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
 * Use this if you want to define a derived `DataFlow::BarrierGuard` without
 * make the type recursive. Otherwise use `RegexpCheckBarrier`.
 */
predicate regexpMatchGuardChecks(Guard guard, Expr e, boolean branch) {
  exists(RegexMatch rm | not rm instanceof Annotation |
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
    or
    // Annotations don't fit into the model of barrier guards because the
    // annotation doesn't dominate the sanitized expression, so we instead
    // treat them as barriers directly.
    exists(RegexMatch rm | rm instanceof Annotation | this.asExpr() = rm.getString())
  }
}
