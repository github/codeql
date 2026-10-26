/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * code constructed from library input vulnerabilities, as
 * well as extension points for adding your own.
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.core.Gem::Gem as Gem
private import codeql.ruby.Concepts as Concepts
private import codeql.ruby.typetracking.TypeTracking

/**
 * Module containing sources, sinks, and sanitizers for code constructed from library input.
 */
module UnsafeCodeConstruction {
  /** A source for code constructed from library input vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** An input parameter to a gem seen as a source. */
  private class LibraryInputAsSource extends Source instanceof DataFlow::ParameterNode {
    LibraryInputAsSource() {
      this = Gem::getALibraryInput() and
      not this.getName() = "code"
    }
  }

  /** A sink for code constructed from library input vulnerabilities. */
  abstract class Sink extends DataFlow::Node {
    /**
     * Gets the node where the unsafe code is executed.
     */
    abstract DataFlow::Node getCodeSink();

    /**
     * Gets the type of sink.
     */
    string getSinkType() { result = "code construction" }
  }

  /** Gets a node that is eventually executed as code at `codeExec`. */
  DataFlow::Node getANodeExecutedAsCode(Concepts::CodeExecution codeExec) {
    result = getANodeExecutedAsCode(TypeBackTracker::end(), codeExec)
  }

  /** Gets a node that is eventually executed as code at `codeExec`, type-tracked with `t`. */
  private DataFlow::LocalSourceNode getANodeExecutedAsCode(
    TypeBackTracker t, Concepts::CodeExecution codeExec
  ) {
    t.start() and
    result = codeExec.getCode().getALocalSource() and
    codeExec.runsArbitraryCode() // methods like `Object.send` is benign here, because of the string-construction the attacker cannot control the entire method name
    or
    exists(TypeBackTracker t2 | result = getANodeExecutedAsCode(t2, codeExec).backtrack(t2, t))
  }

  /**
   * A string constructed using a `.join(...)` call, where the resulting string ends up being executed as code.
   */
  class ArrayJoin extends Sink {
    Concepts::CodeExecution s;

    ArrayJoin() {
      exists(DataFlow::CallNode call |
        call.getMethodName() = "join" and
        call.getNumberOfArguments() = 1 and // any string. E.g. ";" or "\n".
        call = getANodeExecutedAsCode(s) and
        this = call.getReceiver()
      )
    }

    override DataFlow::Node getCodeSink() { result = s }

    override string getSinkType() { result = "array" }
  }

  /**
   * A string constructed from a string-literal (e.g. `"foo #{sink}"`),
   * where the resulting string ends up being executed as a code.
   */
  class StringInterpolationAsSink extends Sink {
    Concepts::CodeExecution s;

    StringInterpolationAsSink() {
      exists(Ast::StringlikeLiteral lit |
        any(DataFlow::Node n | n.asExpr().getExpr() = lit) = getANodeExecutedAsCode(s) and
        this.asExpr().getExpr() = lit.getComponent(_)
      )
    }

    override DataFlow::Node getCodeSink() { result = s }

    override string getSinkType() { result = "string interpolation" }
  }

  /**
   * A component of a string-concatenation (e.g. `"foo " + sink`),
   * where the resulting string ends up being executed as a code.
   */
  class StringConcatAsSink extends Sink {
    Concepts::CodeExecution s;

    StringConcatAsSink() {
      exists(Ast::AddExprRoot add |
        any(DataFlow::Node n | n.asExpr().getExpr() = add) = getANodeExecutedAsCode(s) and
        this.asExpr().getExpr() = add.getALeaf()
      )
    }

    override DataFlow::Node getCodeSink() { result = s }

    override string getSinkType() { result = "string concatenation" }
  }

  import codeql.ruby.security.TaintedFormatStringSpecific as TaintedFormat

  /**
   * A string constructed from a printf-style call,
   * where the resulting string ends up being executed as a code.
   */
  class TaintedFormatStringAsSink extends Sink {
    Concepts::CodeExecution s;

    TaintedFormatStringAsSink() {
      exists(TaintedFormat::PrintfStyleCall call |
        call = getANodeExecutedAsCode(s) and
        this = [call.getFormatArgument(_), call.getFormatString()]
      )
    }

    override DataFlow::Node getCodeSink() { result = s }

    override string getSinkType() { result = "string format" }
  }
}
