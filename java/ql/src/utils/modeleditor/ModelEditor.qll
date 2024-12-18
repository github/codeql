/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import java
private import semmle.code.java.dataflow.ExternalFlow
private import semmle.code.java.dataflow.FlowSummary
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.internal.ModelExclusions

/** Holds if the given callable/method is not worth supporting. */
private predicate isUninteresting(Callable c) {
  c.getDeclaringType() instanceof TestLibrary or
  c.(Constructor).isParameterless() or
  c.getDeclaringType() instanceof AnonymousClass
}

/**
 * A callable method from either the Standard Library, a 3rd party library or from the source.
 */
class Endpoint extends Callable {
  Endpoint() { not isUninteresting(this) }

  /**
   * Gets the package name of this endpoint.
   */
  string getPackageName() { result = this.getDeclaringType().getPackage().getName() }

  /**
   * Gets the type name of this endpoint.
   */
  string getTypeName() { result = this.getDeclaringType().getNestedName() }

  /**
   * Gets the parameter types of this endpoint.
   */
  string getParameterTypes() { result = paramsString(this) }

  private string getJarName() {
    result = this.getCompilationUnit().getParentContainer*().(JarFile).getBaseName()
  }

  private string getJarVersion() {
    result = this.getCompilationUnit().getParentContainer*().(JarFile).getSpecificationVersion()
  }

  /**
   * Gets the jar file containing this API. Normalizes the Java Runtime to "rt.jar" despite the presence of modules.
   */
  string jarContainer() {
    result = this.getJarName()
    or
    not exists(this.getJarName()) and result = "rt.jar"
  }

  /**
   * Gets the version of the JAR file containing this API. Empty if no version is found in the JAR.
   */
  string jarVersion() {
    result = this.getJarVersion()
    or
    not exists(this.getJarVersion()) and result = ""
  }

  /** Holds if this API has a supported summary. */
  pragma[nomagic]
  predicate hasSummary() { this = any(SummarizedCallable sc).asCallable() }

  /** Holds if this API is a known source. */
  pragma[nomagic]
  abstract predicate isSource();

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  abstract predicate isSink();

  /** Holds if this API is a known neutral. */
  pragma[nomagic]
  predicate isNeutral() {
    exists(string namespace, string type, string name, string signature |
      neutralModel(namespace, type, name, signature, _, _) and
      this = interpretElement(namespace, type, true, name, signature, "", _)
    )
  }

  /**
   * Holds if this API is supported by existing CodeQL libraries, that is, it is either a
   * recognized source, sink or neutral or it has a flow summary.
   */
  predicate isSupported() {
    this.hasSummary() or this.isSource() or this.isSink() or this.isNeutral()
  }
}

boolean isSupported(Endpoint endpoint) {
  endpoint.isSupported() and result = true
  or
  not endpoint.isSupported() and result = false
}

string supportedType(Endpoint endpoint) {
  endpoint.isSink() and result = "sink"
  or
  endpoint.isSource() and result = "source"
  or
  endpoint.hasSummary() and result = "summary"
  or
  endpoint.isNeutral() and result = "neutral"
  or
  not endpoint.isSupported() and result = ""
}

string usageClassification(Call usage) {
  isInTestFile(usage.getLocation().getFile()) and result = "test"
  or
  usage.getFile() instanceof GeneratedFile and result = "generated"
  or
  not isInTestFile(usage.getLocation().getFile()) and
  not usage.getFile() instanceof GeneratedFile and
  result = "source"
}
