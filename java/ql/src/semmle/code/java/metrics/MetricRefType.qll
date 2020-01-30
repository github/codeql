/**
 * Provides classes and predicates for computing metrics on Java classes and interfaces.
 */

import semmle.code.java.Type
import MetricElement
import semmle.code.java.Dependency
import semmle.code.java.UnitTests

/** This class provides access to metrics information for reference types. */
class MetricRefType extends RefType, MetricElement {
  /** Gets the percentage of lines in this reference type that consist of comments. */
  override float getPercentageOfComments() {
    exists(float n |
      n = this.getTotalNumberOfLines() and
      n > 0 and
      result = 100 * (this.getNumberOfCommentLines() / n)
    )
  }

  /** Gets the number of callables declared in this type. */
  int getNumberOfCallables() { result = count(this.getACallable()) }

  /** Gets the number of fields declared in this type. */
  int getNumberOfFields() { result = count(this.getAField()) }

  /**
   * Gets the number of fields declared in this type, excluding enum constants.
   */
  int getNumberOfExplicitFields() {
    result = count(Field f | f = this.getAField() and not f instanceof EnumConstant | f)
  }

  /**
   * Gets the number of immediate descendants of a reference type.
   */
  int getNumberOfChildren() { result = count(this.getASubtype()) }

  /**
   * The number of public methods gives an indication of the size of
   * an API provided by a type.
   */
  int getNumberOfPublicCallables() {
    result = count(Callable m | m.getDeclaringType() = this and m.isPublic())
  }

  /**
   * The afferent coupling of a type is the number of types that
   * directly depend on it.
   *
   * This may also be referred to as the number of
   * (direct) "incoming dependencies" of a type.
   */
  int getAfferentCoupling() { result = count(RefType t | depends(t, this)) }

  /**
   * The efferent coupling of a type is the number of types that
   * it directly depends on.
   *
   * This may also be referred to as the number of
   * (direct) "outgoing dependencies" of a type.
   */
  int getEfferentCoupling() { result = count(RefType t | depends(this, t)) }

  /**
   * The efferent source coupling of a type is the number of source
   * types that it directly depends on.
   */
  int getEfferentSourceCoupling() {
    result = count(RefType t | t.fromSource() and depends(this, t))
  }

  /**
   * Gets a dependency of this element, for use with John Lakos's "level metric".
   */
  override MetricElement getADependency() { depends(this, result) and this != result }

  /**
   * Holds if method `m` accesses field `f`
   * and both are declared in this type.
   */
  predicate accessesLocalField(Method m, Field f) {
    m.accesses(f) and
    m.getDeclaringType() = this and
    f.getDeclaringType() = this
  }

  /** Any method declared in this type that accesses a field declared in this type. */
  Method getAccessingMethod() { exists(Field f | this.accessesLocalField(result, f)) }

  /** Any field declared in this type that is accessed by a method declared in this type. */
  Field getAccessedField() { exists(Method m | this.accessesLocalField(m, result)) }

  /**
   * Gets the Henderson-Sellers lack of cohesion metric.
   *
   * The aim of this metric is to try to determine whether a class
   * represents one abstraction (good) or multiple abstractions (bad).
   * If a class represents multiple abstractions, it should be split
   * up into multiple classes.
   *
   * In the Henderson-Sellers method, this is measured as follows:
   *
   * ```
   *    M = set of methods in class
   *    F = set of fields in class
   *    r(f) = number of methods that access field f
   *    <r> = mean of r(f) over f in F
   * ```
   *
   * The lack of cohesion is then given by
   *
   * ```
   *   (<r> - |M|) / (1 - |M|)
   * ```
   *
   * We follow the Eclipse metrics plugin by restricting `M` to methods
   * that access some field in the same class, and restrict `F` to
   * fields that are read by methods in the same class.
   *
   * High values of this metric indicate a lack of cohesion.
   */
  float getLackOfCohesionHS() {
    exists(int m, float r |
      // m = number of methods that access some field
      m = count(this.getAccessingMethod()) and
      // r = average (over f) of number of methods that access field f
      r =
        avg(Field f | f = this.getAccessedField() | count(Method x | this.accessesLocalField(x, f))) and
      // avoid division by zero
      m != 1 and
      // compute LCOM
      result = ((r - m) / (1 - m))
    )
  }

  /** Holds if the specified callable should be included in the CK cohesion computation. */
  predicate includeInLackOfCohesionCK(Callable c) {
    not c instanceof TestMethod and
    exists(Field f | c.getDeclaringType() = this and c.accesses(f) and relevantFieldForCohesion(f))
  }

  pragma[noopt]
  private predicate relevantFieldForCohesion(Field f) {
    exists(RefType t |
      t = this.getAnAncestor() and
      f = t.getAField() and
      not f.isFinal() and
      not f.isStatic()
    )
  }

  /** Holds if a (non-ignored) callable reads a field relevant for cohesion. */
  private predicate relevantCallableAndFieldCK(Callable m, Field f) {
    includeInLackOfCohesionCK(m) and
    relevantFieldForCohesion(f) and
    m.accesses(f) and
    m.getDeclaringType() = this
  }

  /**
   * Gets the Chidamber-Kemerer lack of cohesion metric.
   *
   * The aim of this metric is to try and determine whether a class
   * represents one abstraction (good) or multiple abstractions (bad).
   * If a class represents multiple abstractions, it should be split
   * up into multiple classes.
   *
   * In the Chidamber and Kemerer method, this is measured as follows:
   *
   * -  n1 = number of pairs of distinct methods in a reftype that do *not*
   *         have at least one commonly accessed field
   * -  n2 = number of pairs of distinct methods in a reftype that do
   *         have at least one commonly accessed field
   * -  lcom = ((n1 - n2)/2 max 0)
   *
   * We divide by 2 because each pair (m1,m2) is counted twice in n1 and n2.
   *
   * High values of `lcom` indicate a lack of cohesion.
   */
  float getLackOfCohesionCK() {
    exists(int callables, int linked, float n |
      callables = count(Callable m | includeInLackOfCohesionCK(m)) and
      linked =
        count(Callable m1, Callable m2 |
          exists(Field f |
            relevantCallableAndFieldCK(m1, f) and
            relevantCallableAndFieldCK(m2, f) and
            m1 != m2
          )
        ) and
      // 1. The number of pairs of callables without a field in common is
      // the same as the number of pairs of callables minus the number
      // of pairs of callables _with_ a field in common.
      // 2. The number of pairs of callables, if the number of callables
      // is `C`, is `(C - 1) * C`.
      n = (((callables - 1) * callables) - (2 * linked)) / 2.0 and
      (
        n < 0 and result = 0
        or
        n >= 0 and result = n
      )
    )
  }

  /** Gets the length of _some_ path to the root of the hierarchy. */
  int getADepth() {
    this.hasQualifiedName("java.lang", "Object") and result = 0
    or
    not cyclic() and result = this.getASupertype().(MetricRefType).getADepth() + 1
  }

  /**
   * Gets the depth of the inheritance tree.
   *
   * This metric measures the maximum distance from `Object` in the type
   * hierarchy. It is sometimes considered that classes that are very
   * deeply nested may be difficult to maintain.
   *
   * Note that definitions of "depth of inheritance tree" vary among systems
   * for computing metrics. This implementation uses the definition from Spinellis's
   * book and tool (ckjm). A different tool, NDepend, defines the inheritance
   * depth to be the total number of supertypes, which is implemented using
   * the `getNumberofAncestors()` method.
   */
  int getInheritanceDepth() { result = max(this.getADepth()) }

  /** Gets the length of _some_ path to the specified reference type. */
  int getADepth(RefType reference) {
    this = reference and result = 0
    or
    not cyclic() and result = this.getASupertype().(MetricRefType).getADepth(reference) + 1
  }

  private predicate cyclic() { getASupertype+() = this }

  /** Gets the depth of inheritance metric relative to the specified reference type. */
  int getInheritanceDepth(RefType reference) { result = max(this.getADepth(reference)) }

  /** Gets the number of (direct or indirect) supertypes. */
  int getNumberOfAncestors() { result = count(this.getASupertype+()) }

  /**
   * Gets the response for a type.
   *
   * This estimates the number of different callables that can be executed when
   * a callable is invoked on this type. In an ideal world, one would compute a
   * precise static approximation of the dynamic call graph, and then take
   * the number of reachable callables from each callable. However, there
   * are two problems with such an approach. First, it is incredibly expensive
   * to compute such an approximation. Second, the approximation is likely
   * to be very rough, even when using these expensive algorithms.
   *
   * For that reason, Chidamber and Kemerer suggested in their seminal 1994
   * article that one just counts the number of calls within the callables of
   * a class. Spinellis's ckjm tool does precisely that, and we follow its lead.
   */
  int getResponse() {
    result = sum(Callable c | c.getDeclaringType() = this | count(c.getACallee()))
  }

  /**
   * Exclusions from the number of overriding methods,
   * for use with the specialization index metric.
   */
  predicate ignoreOverride(Method c) {
    c.hasStringSignature("equals(Object)") or
    c.hasStringSignature("hashCode()") or
    c.hasStringSignature("toString()") or
    c.hasStringSignature("finalize()") or
    c.hasStringSignature("clone()")
  }

  /** Gets a method that overrides a non-abstract method in a super type. */
  Method getOverrides() {
    this.getAMethod() = result and
    exists(Method c |
      result.overrides(c) and
      not c.isAbstract()
    ) and
    not this.ignoreOverride(result)
  }

  /** Gets the number of methods that are overridden by this class. */
  int getNumberOverridden() { result = count(this.getOverrides()) }

  /**
   * The specialization index metric measures the extent to which subclasses
   * override (replace) the behavior of their ancestor classes. If they
   * override many methods, it is an indication that the original abstraction
   * in the superclasses may have been inappropriate. On the whole, subclasses
   * should add behavior to their superclasses, but not alter that
   * behavior dramatically.
   */
  float getSpecialisationIndex() {
    this.getNumberOfCallables() != 0 and
    result =
      (this.getNumberOverridden() * this.getInheritanceDepth()) /
        this.getNumberOfCallables().(float)
  }

  /** Gets the Halstead length of a type, estimated as the sum of the Halstead lengths of its callables. */
  override int getHalsteadLength() {
    result =
      sum(Callable c, int toSum |
        c = this.getACallable() and
        toSum = c.getMetrics().getHalsteadLength()
      |
        toSum
      )
  }

  /** Gets the Halstead vocabulary of a type, estimated as the sum of the Halstead vocabularies of its callables. */
  override int getHalsteadVocabulary() {
    result =
      sum(Callable c, int toSum |
        c = this.getACallable() and
        toSum = c.getMetrics().getHalsteadVocabulary()
      |
        toSum
      )
  }

  /** Gets the cyclomatic complexity of a type, estimated as the sum of the cyclomatic complexities of its callables. */
  override int getCyclomaticComplexity() {
    result =
      sum(Callable c, int toSum |
        c = this.getACallable() and
        toSum = c.getMetrics().getCyclomaticComplexity()
      |
        toSum
      )
  }

  /** Gets the number of lines of code in this reference type. */
  override int getNumberOfLinesOfCode() { numlines(this, _, result, _) }

  /** Gets the number of lines of comments in this reference type. */
  override int getNumberOfCommentLines() { numlines(this, _, _, result) }

  /** Gets the total number of lines in this reference type, including code, comments and whitespace-only lines. */
  override int getTotalNumberOfLines() { numlines(this, result, _, _) }
}
