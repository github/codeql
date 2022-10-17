/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * code constructed from library input vulnerabilities, as
 * well as extension points for adding your own.
 */

private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.core.Gem::Gem as Gem
private import codeql.ruby.AST as Ast
private import codeql.ruby.Concepts as Concepts

/**
 * Module containing sources, sinks, and sanitizers for code constructed from library input.
 */
module UnsafeCodeConstruction {
  /** A source for code constructed from library input vulnerabilities. */
  abstract class Source extends DataFlow::Node { }

  /** An input parameter to a gem seen as a source. */
  private class LibraryInputAsSource extends Source instanceof DataFlow::ParameterNode {
    LibraryInputAsSource() { this = Gem::getALibraryInput() }
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
    result = getANodeExecutedAsCode(TypeTracker::TypeBackTracker::end(), codeExec)
  }

  import codeql.ruby.typetracking.TypeTracker as TypeTracker

  /** Gets a node that is eventually executed as code at `codeExec`, type-tracked with `t`. */
  private DataFlow::LocalSourceNode getANodeExecutedAsCode(
    TypeTracker::TypeBackTracker t, Concepts::CodeExecution codeExec
  ) {
    t.start() and
    result = codeExec.getCode().getALocalSource() and
    codeExec.runsArbitraryCode() // methods like `Object.send` is benign here, because of the string-construction the attacker cannot control the entire method name
    or
    exists(TypeTracker::TypeBackTracker t2 |
      result = getANodeExecutedAsCode(t2, codeExec).backtrack(t2, t)
    )
  }

  /**
   * A string constructed from a string-literal (e.g. `"foo #{sink}"`),
   * where the resulting string ends up being executed as a code.
   */
  class StringFormatAsSink extends Sink {
    Concepts::CodeExecution s;
    Ast::StringLiteral lit;

    StringFormatAsSink() {
      any(DataFlow::Node n | n.asExpr().getExpr() = lit) = getANodeExecutedAsCode(s) and
      this.asExpr().getExpr() = lit.getComponent(_)
    }

    override DataFlow::Node getCodeSink() { result = s }

    override string getSinkType() { result = "string interpolation" }
  }

  import codeql.ruby.security.TaintedFormatStringSpecific as TaintedFormat

  /**
   * A string constructed from a printf-style call,
   * where the resulting string ends up being executed as a code.
   */
  class TaintedFormatStringAsSink extends Sink {
    Concepts::CodeExecution s;
    TaintedFormat::PrintfStyleCall call;

    TaintedFormatStringAsSink() {
      call = getANodeExecutedAsCode(s) and
      this = [call.getFormatArgument(_), call.getFormatString()]
    }

    override DataFlow::Node getCodeSink() { result = s }

    override string getSinkType() { result = "string format" }
  }
}
