/**
 * Provides classes and predicates for computing metrics on Java packages.
 */

import semmle.code.java.Package
import MetricElement
import MetricRefType
import semmle.code.java.Dependency
import MetricCallable

/** This class provides access to metrics information for packages. */
class MetricPackage extends Package, MetricElement {
  /** Gets the percentage of lines in this package that consist of comments. */
  override float getPercentageOfComments() {
    exists(float n |
      n = this.getTotalNumberOfLines() and
      n > 0 and
      result = 100 * (this.getNumberOfCommentLines() / n)
    )
  }

  /** Gets the number of lines of code in this package. */
  override int getNumberOfLinesOfCode() {
    // Refer to `numlines(...)` directly to avoid invalid recursive aggregate.
    result =
      sum(CompilationUnit cu, int lines |
        cu.getPackage() = this and numlines(cu, _, lines, _)
      |
        lines
      )
  }

  /** Gets the number of lines of comments in this package. */
  override int getNumberOfCommentLines() {
    result =
      sum(CompilationUnit cu, int lines |
        cu.getPackage() = this and numlines(cu, _, _, lines)
      |
        lines
      )
  }

  /** Gets the total number of lines in this package, including code, comments and whitespace-only lines. */
  override int getTotalNumberOfLines() {
    result =
      sum(CompilationUnit cu, int lines |
        cu.getPackage() = this and numlines(cu, lines, _, _)
      |
        lines
      )
  }

  /** Gets the total number of reference types in this package. */
  int getNumberOfTypes() { result = count(RefType t | t.getPackage() = this) }

  /** Gets the total number of callables declared in a type in this package. */
  int getNumberOfCallables() {
    result = count(Callable m | m.getDeclaringType().getPackage() = this)
  }

  /**
   * Gets the number of public callables declared in a type in this package.
   * This is an indication of the size of the API provided by this package.
   */
  int getNumberOfPublicCallables() {
    result =
      sum(MetricRefType t, int toSum |
        t.getPackage() = this and
        toSum = t.getNumberOfPublicCallables()
      |
        toSum
      )
  }

  /** Gets the total number of fields declared in a type in this package. */
  int getNumberOfFields() { result = count(Field f | f.getDeclaringType().getPackage() = this) }

  /**
   * Afferent Coupling (incoming dependencies).
   *
   * The afferent coupling of a package is the number of types
   * outside this package that depend on types inside this package.
   *
   * A high afferent coupling is an indication that the package
   * has many responsibilities; it may thus be a good idea to
   * consider whether these responsibilities can be separated into
   * separate packages.
   *
   * Afferent coupling of packages is also used to define other
   * package metrics, such as the instability metric.
   */
  int getAfferentCoupling() {
    result =
      count(RefType t |
        t.getPackage() != this and
        exists(RefType s | s.getPackage() = this and depends(t, s))
      )
  }

  /**
   * Efferent Coupling (outgoing dependencies)
   *
   * The efferent coupling of a package is the number of types inside
   * this package that depend on types outside this package.
   *
   * A high efferent coupling indicates that it may be advisable to
   * merge this package with others.
   *
   * Efferent coupling of packages is also used to define other
   * package metrics, such as the instability metric.
   */
  int getEfferentCoupling() {
    result =
      count(RefType t |
        t.getPackage() = this and
        exists(RefType s | s.getPackage() != this and depends(t, s))
      )
  }

  /** Efferent Coupling (outgoing dependencies) to the specified package. */
  int getEfferentCoupling(Package p) {
    p != this and
    result =
      count(RefType t |
        t.getPackage() = this and
        exists(RefType s | s.getPackage() = p and depends(t, s))
      )
  }

  /**
   * Instability metric.
   *
   * Instability is a measure of how likely a package is to be influenced
   * by changes to other packages. If this metric value is high, it is easily
   * influenced, if it is low, the impact is likely to be minimal. Instability
   * is estimated as the number of outgoing dependencies relative to the total
   * number of dependencies.
   *
   * A paradigmatic stable package is `java.lang`: A lot of other packages depend
   * on it, but it does not itself depend on many other packages. Changing
   * other parts of a program is thus highly unlikely to affect `java.lang`.
   */
  float getInstability() {
    exists(int ecoupling, int sumcoupling |
      ecoupling = this.getEfferentCoupling() and
      sumcoupling = ecoupling + this.getAfferentCoupling() and
      sumcoupling > 0 and
      result = ecoupling / sumcoupling.(float)
    )
  }

  /**
   * Abstractness metric.
   *
   * Abstractness measures the proportion of abstract types in
   * a package relative to the total number of types in that package.
   * A highly abstract package (where the metric value is close 1)
   * that is furthermore unstable is likely to be useless: the
   * class hierarchy has been over-engineered, and all those
   * abstract types are not heavily used.
   *
   * One should try to design packages that are abstract in
   * proportion to their incoming dependencies, and concrete in
   * proportion to their outgoing dependencies. Such an approach
   * is likely to facilitate making changes to the code.
   *
   * See _Java Design: Objects, UML, and Process_ by R. C. Martin
   * for further discussion of these metrics and their use.
   */
  float getAbstractness() {
    exists(int i, int j |
      i = count(RefType t | t.getPackage() = this) and
      j = count(RefType t | t.getPackage() = this and t.isAbstract()) and
      result = j / i.(float) and
      i > 0
    )
  }

  /**
   * Distance from Main Sequence.
   *
   * This measure intends to capture the tradeoff between abstractness
   * and instability: the ideal situation occurs when the sum of
   * abstractness and instability is one. That is, a package is
   * completely abstract and stable (abstractness=1 and instability=0)
   * or it is concrete and unstable (abstractness=0 and instability=1).
   * We thus measure the distance from that ideal situation.
   */
  float getDistanceFromMain() {
    exists(float r | r = this.getAbstractness() + this.getInstability() - 1 |
      r >= 0 and result = r
      or
      r < 0 and result = -r
    )
  }

  /**
   * How many types in this package the specified reference type depends on.
   *
   * The specified reference type must also belong to this package.
   */
  float countDependencies(RefType t) {
    t.getPackage() = this and
    result = count(RefType s | s.getPackage() = this and depends(t, s))
  }

  /**
   * Relational Cohesion.
   *
   * Relational Cohesion measures how well a package p hangs together.
   * That is, for each type in p we measure how many types within p
   * it depends on, and we take the average. To cater for the case
   * that there is only one type in the package (and then obviously
   * the package is quite cohesive!) we add 1 to the resulting average.
   *
   * The recommended range for this metric is between 1.5 and 4.0:
   * too low a cohesion indicates that the package is a "kitchen sink"
   * containing too many unrelated types. On the other hand, a cohesion
   * that is too high indicates a package that is too complex, with
   * too many internal dependencies.
   *
   * Note: some tools compute this metric not by counting types, but
   * by counting the different ways one type depends on another.
   * While this is appropriate in a tool that distinguishes between
   * associations, generalizations and use links, it is less appropriate
   * for metrics that are directly computed from code.
   */
  float relationalCohesion() {
    result =
      1 +
        avg(RefType t, float toAvg |
          t.getPackage() = this and
          toAvg = this.countDependencies(t)
        |
          toAvg
        )
  }

  /**
   * Gets a dependency of this element, for use with John Lakos's "level metric".
   */
  override MetricElement getADependency() {
    exists(RefType s, RefType t |
      s.getPackage() = this and
      t.getPackage() = result and
      depends(s, t) and
      result != this
    )
  }

  /** Cyclic package dependencies: a source package dependency of this package. */
  MetricPackage srcDep() {
    result = this.getADependency() and
    result.fromSource() and
    this.fromSource()
  }

  /**
   * Cyclic package dependencies: a member of the cycle to which this package belongs.
   */
  MetricPackage getACycleMember() {
    result.srcDep*() = this and
    this.srcDep*() = result and
    result.fromSource()
  }

  /** Cyclic package dependencies: the size of the cycle to which this package belongs. */
  int getCycleSize() { result = count(this.getACycleMember()) }

  /**
   * Cyclic package dependencies: whether this package is considered to be a
   * representative member of the cycle to which it belongs.
   */
  predicate isRepresentative() {
    this.getName() =
      min(MetricPackage p, string toMin |
        p = this.getACycleMember() and
        toMin = p.getName()
      |
        toMin
      )
  }

  /**
   * Average Fan-In.
   *
   * The fan-in of a package is the average efferent coupling over all callables in that package.
   */
  float getAverageFanIn() {
    result =
      avg(RefType t, MetricCallable c, int toAvg |
        (c = t.getACallable() and t.getPackage() = this) and
        toAvg = c.getAfferentCoupling()
      |
        toAvg
      )
  }
}
