/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import python
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.frameworks.data.internal.ApiGraphModelsExtensions
private import queries.modeling.internal.Util as Util

/**
 * Gets the namespace of an endpoint `scope`.
 */
string getNamespace(Scope scope) { result = scope.getEnclosingModule().getPackage().getName() }

abstract class Endpoint instanceof Scope {
  string getNamespace() { result = getNamespace(this) }

  string getFileName() { result = super.getLocation().getFile().getBaseName() }

  string toString() { result = super.toString() }

  Location getLocation() { result = super.getLocation() }

  abstract string getType();

  abstract string getName();

  abstract string getParameters();

  abstract boolean getSupportedStatus();

  abstract string getSupportedType();
}

/**
 * A callable function from source code.
 */
class FunctionEndpoint extends Endpoint instanceof Function {
  FunctionEndpoint() {
    this.isPublic() and
    this.(Function).getLocation().getFile() instanceof Util::RelevantFile
  }

  override string getName() { result = this.(Function).getName() }

  /**
   * Gets the unbound type name of this endpoint.
   */
  override string getType() {
    result = this.(Function).getEnclosingScope().(Class).getQualifiedName()
    or
    not exists(this.(Function).getEnclosingScope().(Class)) and result = ""
  }

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
