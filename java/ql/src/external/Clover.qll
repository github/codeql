/** Provides classes and predicates for working with Clover reports. */

import java

/**
 * A Clover report is characterised by the fact that one of its
 * top-level children (usually, in fact, there is only one) is
 * a tag with the name "coverage".
 */
class CloverReport extends XMLFile {
  CloverReport() { this.getAChild().getName() = "coverage" }
}

/**
 * The Clover "coverage" tag contains one or more "projects".
 */
class CloverCoverage extends XMLElement {
  CloverCoverage() {
    this.getParent() instanceof CloverReport and
    this.getName() = "coverage"
  }

  /** Gets a project for this `coverage` element. */
  CloverProject getAProject() { result = this.getAChild() }
}

/**
 * Several elements in the Clover report contain a "metrics" element which
 * contains various numbers, aggregated to the different levels. They are
 * all subclasses of this class, to share code.
 */
abstract class CloverMetricsContainer extends XMLElement {
  /** Gets the Clover `metrics` child element for this element. */
  CloverMetrics getMetrics() { result = this.getAChild() }
}

/**
 * A "metrics" element contains a range of numbers for the current
 * aggregation level.
 */
class CloverMetrics extends XMLElement {
  CloverMetrics() {
    this.getParent() instanceof CloverMetricsContainer and
    this.getName() = "metrics"
  }

  private int attr(string name) { result = this.getAttribute(name).getValue().toInt() }

  private float ratio(string name) { result = attr("covered" + name) / attr(name).(float) }

  /** Gets the value of the `conditionals` attribute. */
  int getNumConditionals() { result = attr("conditionals") }

  /** Gets the value of the `coveredconditionals` attribute. */
  int getNumCoveredConditionals() { result = attr("coveredconditionals") }

  /** Gets the value of the `statements` attribute. */
  int getNumStatements() { result = attr("statements") }

  /** Gets the value of the `coveredstatements` attribute. */
  int getNumCoveredStatements() { result = attr("coveredstatements") }

  /** Gets the value of the `elements` attribute. */
  int getNumElements() { result = attr("elements") }

  /** Gets the value of the `coveredelements` attribute. */
  int getNumCoveredElements() { result = attr("coveredelements") }

  /** Gets the value of the `methods` attribute. */
  int getNumMethods() { result = attr("methods") }

  /** Gets the value of the `coveredmethods` attribute. */
  int getNumCoveredMethods() { result = attr("coveredmethods") }

  /** Gets the value of the `loc` attribute. */
  int getNumLoC() { result = attr("loc") }

  /** Gets the value of the `ncloc` attribute. */
  int getNumNonCommentedLoC() { result = attr("ncloc") }

  /** Gets the value of the `packages` attribute. */
  int getNumPackages() { result = attr("packages") }

  /** Gets the value of the `files` attribute. */
  int getNumFiles() { result = attr("files") }

  /** Gets the value of the `classes` attribute. */
  int getNumClasses() { result = attr("classes") }

  /** Gets the value of the `complexity` attribute. */
  int getCloverComplexity() { result = attr("complexity") }

  /** Gets the ratio of the `coveredconditionals` attribute over the `conditionals` attribute. */
  float getConditionalCoverage() { result = ratio("conditionals") }

  /** Gets the ratio of the `coveredstatements` attribute over the `statements` attribute. */
  float getStatementCoverage() { result = ratio("statements") }

  /** Gets the ratio of the `coveredelements` attribute over the `elements` attribute. */
  float getElementCoverage() { result = ratio("elements") }

  /** Gets the ratio of the `coveredmethods` attribute over the `methods` attribute. */
  float getMethodCoverage() { result = ratio("methods") }

  /** Gets the ratio of the `ncloc` attribute over the `loc` attribute. */
  float getNonCommentedLoCRatio() { result = attr("ncloc") / attr("loc") }
}

/**
 * A Clover project has an aggregated "metrics" element and
 * groups together several "package" (or "testpackage") elements.
 */
class CloverProject extends CloverMetricsContainer {
  CloverProject() { this.getParent() instanceof CloverCoverage }
}

/**
 * A Clover package is nested in a project and contains several files.
 */
class CloverPackage extends CloverMetricsContainer {
  CloverPackage() {
    this.getParent() instanceof CloverProject and
    this.getName() = "package"
  }

  /** Gets the Java package for this Clover package. */
  Package getRealPackage() { result.hasName(getAttribute("name").getValue()) }
}

/**
 * A Clover file is nested in a package and contains several classes.
 */
class CloverFile extends CloverMetricsContainer {
  CloverFile() {
    this.getParent() instanceof CloverPackage and
    this.getName() = "file"
  }
}

/**
 * A Clover class is nested in a file and contains metric information.
 */
class CloverClass extends CloverMetricsContainer {
  CloverClass() {
    this.getParent() instanceof CloverFile and
    this.getName() = "class"
  }

  /** Gets the Clover package for this Clover class. */
  CloverPackage getPackage() { result = getParent().(CloverFile).getParent() }

  /** Gets the Java type for this Clover class. */
  RefType getRealClass() {
    result
        .hasQualifiedName(getPackage().getAttribute("name").getValue(),
          getAttribute("name").getValue())
  }
}

/**
 * Get the clover metrics associated with the given class, if any.
 */
CloverMetrics cloverInfo(RefType t) {
  exists(CloverClass c | c.getRealClass() = t | result = c.getMetrics())
}
