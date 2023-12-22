/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import ruby
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowPrivate
private import codeql.ruby.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.frameworks.core.Gem
private import codeql.ruby.frameworks.data.ModelsAsData
private import codeql.ruby.frameworks.data.internal.ApiGraphModelsExtensions
private import queries.modeling.internal.Util as Util

/** Holds if the given callable is not worth supporting. */
private predicate isUninteresting(DataFlow::MethodNode c) {
  c.getLocation().getFile() instanceof TestFile
}

private predicate gemFileStep(Gem::GemSpec gem, Folder folder, int n) {
  n = 0 and folder.getAFile() = gem.(File)
  or
  exists(Folder parent, int m |
    gemFileStep(gem, parent, m) and
    parent.getAFolder() = folder and
    n = m + 1
  )
}

/**
 * A callable method or accessor from either the Ruby Standard Library, a 3rd party library, or from the source.
 */
class Endpoint extends DataFlow::MethodNode {
  Endpoint() { this.isPublic() and not isUninteresting(this) }

  File getFile() { result = this.getLocation().getFile() }

  string getName() { result = this.getMethodName() }

  /**
   * Gets the namespace of this endpoint.
   */
  bindingset[this]
  string getNamespace() {
    exists(Folder folder | folder = this.getFile().getParentContainer() |
      // The nearest gemspec to this endpoint, if one exists
      result = min(Gem::GemSpec g, int n | gemFileStep(g, folder, n) | g order by n).getName()
      or
      not gemFileStep(_, folder, _) and
      result = ""
    )
  }

  /**
   * Gets the unbound type name of this endpoint.
   */
  bindingset[this]
  string getTypeName() {
    result =
      any(DataFlow::ModuleNode m | m.getOwnInstanceMethod(this.getMethodName()) = this)
          .getQualifiedName() or
    result =
      any(DataFlow::ModuleNode m | m.getOwnSingletonMethod(this.getMethodName()) = this)
            .getQualifiedName() + "!"
  }

  /**
   * Gets the parameter types of this endpoint.
   */
  bindingset[this]
  string getParameterTypes() {
    // For now, return the names of postional and keyword parameters. We don't always have type information, so we can't return type names.
    // We don't yet handle splat params or block params.
    result =
      "(" +
        concat(string key, string value |
          value = any(int i | i.toString() = key | this.asCallable().getParameter(i)).getName()
          or
          exists(DataFlow::ParameterNode param |
            param = this.asCallable().getKeywordParameter(key)
          |
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
  abstract predicate isSource();

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  abstract predicate isSink();

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

  boolean getSupportedStatus() { if this.isSupported() then result = true else result = false }

  string getSupportedType() {
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

string methodClassification(Call method) {
  method.getFile() instanceof TestFile and result = "test"
  or
  not method.getFile() instanceof TestFile and
  result = "source"
}

class TestFile extends File {
  TestFile() {
    this.getRelativePath().regexpMatch(".*(test|spec).+") and
    not this.getAbsolutePath().matches("%/ql/test/%") // allows our test cases to work
  }
}

/**
 * A callable where there exists a MaD sink model that applies to it.
 */
class SinkCallable extends DataFlow::MethodNode {
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
class SourceCallable extends DataFlow::CallableNode {
  SourceCallable() {
    exists(string type, string path, string method |
      method = path.regexpCapture("(Method\\[[^\\]]+\\]).*", 1) and
      Util::pathToMethod(this, type, method) and
      sourceModel(type, path, _)
    )
  }
}

/**
 * A class of effectively public callables from source code.
 */
class PublicEndpointFromSource extends Endpoint {
  override predicate isSource() { this instanceof SourceCallable }

  override predicate isSink() { this instanceof SinkCallable }
}
