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

  CloverProject getAProject() { result = this.getAChild() }
}

/**
 * Several elements in the Clover report contain a "metrics" element which
 * contains various numbers, aggregated to the different levels. They are
 * all subclasses of this class, to share code.
 */
abstract class CloverMetricsContainer extends XMLElement {
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

  int getNumConditionals() { result = attr("conditionals") }

  int getNumCoveredConditionals() { result = attr("coveredconditionals") }

  int getNumStatements() { result = attr("statements") }

  int getNumCoveredStatements() { result = attr("coveredstatements") }

  int getNumElements() { result = attr("elements") }

  int getNumCoveredElements() { result = attr("coveredelements") }

  int getNumMethods() { result = attr("methods") }

  int getNumCoveredMethods() { result = attr("coveredmethods") }

  int getNumLoC() { result = attr("loc") }

  int getNumNonCommentedLoC() { result = attr("ncloc") }

  int getNumPackages() { result = attr("packages") }

  int getNumFiles() { result = attr("files") }

  int getNumClasses() { result = attr("classes") }

  int getCloverComplexity() { result = attr("complexity") }

  float getConditionalCoverage() { result = ratio("conditionals") }

  float getStatementCoverage() { result = ratio("statements") }

  float getElementCoverage() { result = ratio("elements") }

  float getMethodCoverage() { result = ratio("methods") }

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

  CloverPackage getPackage() { result = getParent().(CloverFile).getParent() }

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
