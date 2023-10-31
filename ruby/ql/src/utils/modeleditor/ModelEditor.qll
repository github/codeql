/** Provides classes and predicates related to handling APIs for the VS Code extension. */

private import ruby
private import codeql.ruby.dataflow.FlowSummary
private import codeql.ruby.dataflow.internal.DataFlowPrivate
private import codeql.ruby.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
private import codeql.ruby.dataflow.internal.FlowSummaryImplSpecific
private import codeql.ruby.frameworks.core.Gem
private import codeql.ruby.frameworks.data.ModelsAsData
private import codeql.ruby.frameworks.data.internal.ApiGraphModelsExtensions

/** Holds if the given callable is not worth supporting. */
private predicate isUninteresting(DataFlow::MethodNode c) {
  c.getLocation().getFile() instanceof TestFile
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
    // Return the name of any gemspec file in the database.
    // TODO: make this work for projects with multiple gems (and hence multiple gemspec files)
    result = any(Gem::GemSpec g).getName()
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
    // For now, return the names of postional parameters. We don't always have type information, so we can't return type names.
    // We don't yet handle keyword params, splat params or block params.
    result =
      "(" +
        concat(DataFlow::ParameterNode p, int i |
          p = this.asCallable().getParameter(i)
        |
          p.getName(), "," order by i
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
  predicate isNeutral() {
    none()
    // this instanceof FlowSummaryImpl::Public::NeutralCallable
  }

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
  TestFile() { this.getRelativePath().regexpMatch(".*(test|spec).+") }
}

/**
 * A callable where there exists a MaD sink model that applies to it.
 */
class SinkCallable extends DataFlow::MethodNode {
  SinkCallable() {
    this = ModelOutput::getASinkNode(_).asCallable() and
    exists(string type, string path, string kind, string method |
      sinkModel(type, path, kind) and
      path = "Method[" + method + "]" and
      method = this.getMethodName()
      // TODO: (type, path) corresponds to this method
    )
  }
}

/**
 * A callable where there exists a MaD source model that applies to it.
 */
class SourceCallable extends DataFlow::CallableNode {
  SourceCallable() { sourceElement(this.asExpr().getExpr(), _, _, _) }
}

/**
 * A class of effectively public callables from source code.
 */
class PublicEndpointFromSource extends Endpoint {
  override predicate isSource() { this instanceof SourceCallable }

  override predicate isSink() { this instanceof SinkCallable }
}
