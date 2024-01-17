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
 * Gets the namespace of an endpoint in `file`.
 */
string getNamespace(File file) {
  exists(Folder folder | folder = file.getParentContainer() |
    // The nearest gemspec to this endpoint, if one exists
    result = min(Gem::GemSpec g, int n | gemFileStep(g, folder, n) | g order by n).getName()
    or
    not gemFileStep(_, folder, _) and
    result = ""
  )
}

abstract class Endpoint instanceof DataFlow::Node {
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
class MethodEndpoint extends Endpoint instanceof DataFlow::MethodNode {
  MethodEndpoint() {
    this.isPublic() and
    not isUninteresting(this)
  }

  DataFlow::MethodNode getNode() { result = this }

  override string getName() { result = super.getMethodName() }

  /**
   * Gets the unbound type name of this endpoint.
   */
  override string getType() {
    result =
      any(DataFlow::ModuleNode m | m.getOwnInstanceMethod(this.getName()) = this).getQualifiedName() or
    result =
      any(DataFlow::ModuleNode m | m.getOwnSingletonMethod(this.getName()) = this)
            .getQualifiedName() + "!"
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
          value = any(int i | i.toString() = key | super.asCallable().getParameter(i)).getName()
          or
          exists(DataFlow::ParameterNode param |
            param = super.asCallable().getKeywordParameter(key)
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
  predicate isSource() { this.getNode() instanceof SourceCallable }

  /** Holds if this API is a known sink. */
  pragma[nomagic]
  predicate isSink() { this.getNode() instanceof SinkCallable }

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

string methodClassification(Call method) {
  method.getFile() instanceof TestFile and result = "test"
  or
  not method.getFile() instanceof TestFile and
  result = "source"
}

class TestFile extends File {
  TestFile() {
    this.getRelativePath().regexpMatch(".*(test|spec|examples).+") and
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
 * A module defined in source code
 */
class ModuleEndpoint extends Endpoint {
  private DataFlow::ModuleNode moduleNode;

  ModuleEndpoint() {
    this =
      min(DataFlow::Node n, Location loc |
        n.asExpr().getExpr() = moduleNode.getADeclaration() and
        loc = n.getLocation()
      |
        n order by loc.getFile().getAbsolutePath(), loc.getStartLine(), loc.getStartColumn()
      ) and
    not moduleNode.(Module).isBuiltin() and
    not moduleNode.getLocation().getFile() instanceof TestFile
  }

  DataFlow::ModuleNode getNode() { result = moduleNode }

  override string getType() { result = this.getNode().getQualifiedName() }

  override string getName() { result = "" }

  override string getParameters() { result = "" }

  override boolean getSupportedStatus() { result = false }

  override string getSupportedType() { result = "" }
}
