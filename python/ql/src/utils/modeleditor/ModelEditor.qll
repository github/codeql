/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.dataflow.new.FlowSummary
private import semmle.python.dataflow.new.internal.DataFlowPrivate
private import semmle.python.dataflow.new.internal.FlowSummaryImpl as FlowSummaryImpl
private import semmle.python.frameworks.data.ModelsAsData
private import semmle.python.frameworks.data.internal.ApiGraphModelsExtensions
private import Modeling.internal.Util as Util

/**
 * Gets the namespace of an endpoint in `file`.
 */
string getNamespace(File file) { result = "" }

/**
 * Holds if this method is a constructor for a module.
 */
abstract class Endpoint instanceof Scope {
  string getNamespace() { result = getNamespace(super.getLocation().getFile()) }

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
 * A callable method or accessor from source code.
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
    this.(Function).isMethod() and
    result = this.(Function).getEnclosingScope().(Class).getName()
    or
    not this.(Function).isMethod() and
    result = ""
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
          value = any(int i | i.toString() = key | this.(Function).getArg(i).getName())
          or
          exists(this.(Function).getArgByName(key)) and
          value = key + ":"
        |
          value, "," order by key
        ) + ")"
  }

  /** Holds if this API has a supported summary. */
  pragma[nomagic]
  predicate hasSummary() { this instanceof SummaryCallable }

  /** Holds if this API is a known source. */
  pragma[nomagic]
  predicate isSource() { this instanceof SourceCallable }

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  predicate isSink() { this instanceof SinkCallable }

  /** Holds if this API is a known neutral. */
  pragma[nomagic]
  predicate isNeutral() { this instanceof NeutralCallable }

  /**
   * Holds if this API is supported by existing CodeQL libraries, that is, it is either a
   * recognized source, sink or neutral or it has a flow summary.
   */
  predicate isSupported() {
    // none() is a simple solution here
    this.hasSummary() or this.isSource() or this.isSink() or this.isNeutral()
  }

  override boolean getSupportedStatus() {
    if this.isSupported() then result = true else result = false
  }

  override string getSupportedType() {
    // result = "" is a simple solution here
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
  // Consider support for nested classes in getTypeName()
}

/**
 * A callable where there exists a MaD sink model that applies to it.
 */
class SinkCallable extends Function {
  SinkCallable() {
    exists(string type, string path, string method |
      method = path.regexpCapture("(Method\\[[^\\]]+\\]).*", 1) and
      Util::pathToMethod(this, type, method) and
      sinkModel(type, path, _)
    )
  }
}

/**
 * A callable where there exists a MaD source model that applies to it.
 */
class SourceCallable extends Function {
  SourceCallable() {
    exists(string type, string path, string method |
      method = path.regexpCapture("(Method\\[[^\\]]+\\]).*", 1) and
      Util::pathToMethod(this, type, method) and
      sourceModel(type, path, _)
    )
  }
}

/**
 * A callable where there exists a MaD summary model that applies to it.
 */
class SummaryCallable extends Function {
  SummaryCallable() {
    exists(string type, string path |
      Util::pathToMethod(this, type, path) and
      summaryModel(type, path, _, _, _)
    )
  }
}

/**
 * A callable where there exists a MaD neutral model that applies to it.
 */
class NeutralCallable extends Function {
  NeutralCallable() {
    exists(string type, string path |
      Util::pathToMethod(this, type, path) and
      neutralModel(type, path, _)
    )
  }
}
