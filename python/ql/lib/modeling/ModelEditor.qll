/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import python
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.frameworks.data.internal.ApiGraphModelsExtensions
private import semmle.python.dataflow.new.internal.DataFlowDispatch as DP
private import Util as Util

/**
 * An string describing the kind of source code element being modeled.
 *
 * See `EndPoint`.
 */
class EndpointKind extends string {
  EndpointKind() {
    this in ["Function", "InstanceMethod", "ClassMethod", "StaticMethod", "InitMethod", "Class"]
  }
}

/**
 * An element of the source code to be modeled.
 *
 * See `EndPointKind` for the possible kinds of elements.
 */
abstract class Endpoint instanceof Util::RelevantScope {
  string namespace;
  string type;
  string name;

  Endpoint() {
    exists(string scopePath, string path, int pathIndex |
      scopePath = Util::computeScopePath(this) and
      pathIndex = scopePath.indexOf(".", 0, 0)
    |
      namespace = scopePath.prefix(pathIndex) and
      path = scopePath.suffix(pathIndex + 1) and
      (
        exists(int nameIndex | nameIndex = max(path.indexOf(".")) |
          type = path.prefix(nameIndex) and
          name = path.suffix(nameIndex + 1)
        )
        or
        not exists(path.indexOf(".")) and
        type = "" and
        name = path
      )
    )
  }

  /** Gets the namespace for this endpoint. This will typically be the package in which it is found. */
  string getNamespace() { result = namespace }

  /** Gets hte basename of the file where this endpoint is found. */
  string getFileName() { result = super.getLocation().getFile().getBaseName() }

  /** Gets a string representation of this endpoint. */
  string toString() { result = super.toString() }

  /** Gets the location of this endpoint. */
  Location getLocation() { result = super.getLocation() }

  /** Gets the name of the class in which this endpoint is found, or the empty string if it is not found inside a class. */
  string getClass() { result = type }

  /**
   * Gets the name of the endpoint if it is not a class, or the empty string if it is a class
   *
   * If this endpoint is a class, the class name can be obtained via `getType`.
   */
  string getFunctionName() { result = name }

  /**
   * Gets a string representation of the parameters of this endpoint.
   *
   * The string follows a specific format:
   * - Normal  parameters(where arguments can be passed as either positional or keyword) are listed in order, separated by commas.
   * - Keyword-only parameters are listed in order, separated by commas, each followed by a colon.
   * - In the future, positional-only parameters will be listed in order, separated by commas, each followed by a slash.
   */
  abstract string getParameters();

  /**
   * Gets a boolean that is true iff this endpoint is supported by existing modeling.
   *
   * The check only takes Models as Data extension models into account.
   */
  abstract boolean getSupportedStatus();

  /**
   * Gets a string that describes the type of support detected this endpoint.
   *
   * The string can be one of the following:
   * - "source" if this endpoint is a known source.
   * - "sink" if this endpoint is a known sink.
   * - "summary" if this endpoint has a flow summary.
   * - "neutral" if this endpoint is a known neutral.
   * - "" if this endpoint is not detected as supported.
   */
  abstract string getSupportedType();

  /** Gets the kind of this endpoint. See `EndPointKind`. */
  abstract EndpointKind getKind();
}

private predicate sourceModelPath(string type, string path) { sourceModel(type, path, _, _) }

module FindSourceModel = Util::FindModel<sourceModelPath/2>;

private predicate sinkModelPath(string type, string path) { sinkModel(type, path, _, _) }

module FindSinkModel = Util::FindModel<sinkModelPath/2>;

private predicate summaryModelPath(string type, string path) {
  summaryModel(type, path, _, _, _, _)
}

module FindSummaryModel = Util::FindModel<summaryModelPath/2>;

private predicate neutralModelPath(string type, string path) { neutralModel(type, path, _) }

module FindNeutralModel = Util::FindModel<neutralModelPath/2>;

/**
 * A callable function or method from source code.
 */
class FunctionEndpoint extends Endpoint instanceof Function {
  /**
   * Gets the parameter types of this endpoint.
   */
  override string getParameters() {
    // For now, return the names of positional and keyword parameters. We don't always have type information, so we can't return type names.
    // We don't yet handle splat params or dict splat params.
    //
    // In Python, there are three types of parameters:
    // 1. Positional-only parameters: These are parameters that can only be passed by position and not by keyword.
    // 2. Positional-or-keyword parameters: These are parameters that can be passed by position or by keyword.
    // 3. Keyword-only parameters: These are parameters that can only be passed by keyword.
    //
    // The syntax for defining these parameters is as follows:
    // ```python
    // def f(a, /, b, *, c):
    //     pass
    // ```
    // In this example, `a` is a positional-only parameter, `b` is a positional-or-keyword parameter, and `c` is a keyword-only parameter.
    //
    // We handle positional-only parameters by adding a "/" to the parameter name, reminiscient of the syntax above.
    //    Note that we don't yet have information about positional-only parameters.
    // We handle keyword-only parameters by adding a ":" to the parameter name, to be consistent with the MaD syntax and the other languages.
    exists(int nrPosOnly, Function f |
      f = this and
      nrPosOnly = f.getPositionalParameterCount()
    |
      result =
        "(" +
          concat(string key, string value |
            // TODO: Once we have information about positional-only parameters:
            // Handle positional-only parameters by adding a "/"
            value = any(int i | i.toString() = key | f.getArgName(i))
            or
            exists(Name param | param = f.getAKeywordOnlyArg() |
              param.getId() = key and
              value = key + ":"
            )
          |
            value, "," order by key
          ) + ")"
    )
  }

  /** Holds if this API has a supported summary. */
  pragma[nomagic]
  predicate hasSummary() { FindSummaryModel::hasModel(this) }

  /** Holds if this API is a known source. */
  pragma[nomagic]
  predicate isSource() { FindSourceModel::hasModel(this) }

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  predicate isSink() { FindSinkModel::hasModel(this) }

  /** Holds if this API is a known neutral. */
  pragma[nomagic]
  predicate isNeutral() { FindNeutralModel::hasModel(this) }

  /**
   * Holds if this API is supported by existing CodeQL libraries, that is, it is either a
   * recognized source, sink or neutral or it has a flow summary.
   */
  predicate isSupported() {
    this.hasSummary() or this.isSource() or this.isSink() or this.isNeutral()
  }

  override boolean getSupportedStatus() {
    if this.isSupported() then result = true else result = false
  }

  override string getSupportedType() {
    this.isSink() and result = "sink"
    or
    this.isSource() and result = "source"
    or
    this.hasSummary() and result = "summary"
    or
    this.isNeutral() and result = "neutral"
    or
    not this.isSupported() and result = ""
  }

  override EndpointKind getKind() {
    if this.(Function).isMethod()
    then
      result = this.methodKind()
      or
      not exists(this.methodKind()) and result = "InstanceMethod"
    else result = "Function"
  }

  private EndpointKind methodKind() {
    this.(Function).isMethod() and
    (
      DP::isClassmethod(this) and result = "ClassMethod"
      or
      DP::isStaticmethod(this) and result = "StaticMethod"
      or
      this.(Function).isInitMethod() and result = "InitMethod"
    )
  }
}

/**
 * A class from source code.
 */
class ClassEndpoint extends Endpoint instanceof Class {
  override string getClass() { result = type + "." + name }

  override string getFunctionName() { result = "" }

  override string getParameters() { result = "" }

  override boolean getSupportedStatus() { result = false }

  override string getSupportedType() { result = "" }

  override EndpointKind getKind() { result = "Class" }
}
