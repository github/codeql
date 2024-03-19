/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import python
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.frameworks.data.internal.ApiGraphModelsExtensions
private import queries.modeling.internal.Util as Util

abstract class Endpoint instanceof Scope {
  string namespace;
  string path;

  Endpoint() {
    this.isPublic() and
    this.getLocation().getFile() instanceof Util::RelevantFile and
    exists(string scopePath, int firstDot |
      scopePath = Util::computeScopePath(this) and
      firstDot = scopePath.indexOf(".", 0, 0)
    |
      namespace = scopePath.prefix(firstDot) and
      path = scopePath.suffix(firstDot + 1)
    )
  }

  string getNamespace() { result = namespace }

  string getFileName() { result = super.getLocation().getFile().getBaseName() }

  string toString() { result = super.toString() }

  Location getLocation() { result = super.getLocation() }

  string getType() { result = "" }

  string getName() { result = path }

  abstract string getParameters();

  abstract boolean getSupportedStatus();

  abstract string getSupportedType();
}

/**
 * A callable function or method from source code.
 */
class FunctionEndpoint extends Endpoint instanceof Function {
  /**
   * Gets the parameter types of this endpoint.
   */
  override string getParameters() {
    // For now, return the names of positional and keyword parameters. We don't always have type information, so we can't return type names.
    // We don't yet handle splat params or block params.
    result =
      "(" +
        concat(string key, string value |
          value = any(int i | i.toString() = key | this.(Function).getArgName(i))
          or
          exists(Name param | param = this.(Function).getAKeywordOnlyArg() |
            param.getId() = key and
            value = key + ":"
          )
        |
          value, "," order by key
        ) + ")"
  }

  /** Holds if this API has a supported summary. */
  pragma[nomagic]
  predicate hasSummary() { none() }

  /** Holds if this API is a known source. */
  pragma[nomagic]
  predicate isSource() { none() }

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  predicate isSink() { none() }

  /** Holds if this API is a known neutral. */
  pragma[nomagic]
  predicate isNeutral() { none() }

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
}
