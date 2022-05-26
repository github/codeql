/**
 * Provides modeling for the `Logger` library.
 */

private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.ApiGraphs
private import codeql.ruby.frameworks.Stdlib
private import codeql.ruby.Concepts
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.internal.DataFlowDispatch

/**
 * Provides modeling for the `Logger` library.
 */
module Logger {
  /** A reference to a `Logger` instance */
  private DataFlow::Node loggerInstance() {
    result = API::getTopLevelMember("Logger").getAnInstantiation()
    or
    exists(DataFlow::Node inst |
      inst = loggerInstance() and
      inst.(DataFlow::LocalSourceNode).flowsTo(result)
    )
    or
    // Assume that a variable assigned as a `Logger` instance is always a
    // `Logger` instance. This covers class and instance variables where we can't
    // necessarily trace a dataflow path from assignment to use.
    exists(Variable v, Assignment a |
      a.getLeftOperand().getAVariable() = v and
      a.getRightOperand() = loggerInstance().asExpr().getExpr() and
      result.asExpr().getExpr().(VariableReadAccess).getVariable() = v
    )
  }

  /**
   * A call to a `Logger` instance method that causes a message to be logged.
   */
  abstract class LoggerLoggingCall extends Logging::Range, DataFlow::CallNode {
    LoggerLoggingCall() { this.getReceiver() = loggerInstance() }
  }

  /**
   * A call to `Logger#add` or its alias `Logger#log`.
   */
  private class LoggerAddCall extends LoggerLoggingCall {
    LoggerAddCall() { this.getMethodName() = ["add", "log"] }

    override DataFlow::Node getAnInput() {
      // Both the message and the progname are form part of the log output:
      // Logger#add(severity, message) / Logger#add(severity, message, progname)
      result = this.getArgument(1)
      or
      result = this.getArgument(2)
      or
      // a return value from the block in Logger#add(severity) <block> or in
      // Logger#add(severity, nil, progname) <block>
      (
        this.getNumberOfArguments() = 1
        or
        // TODO: this could track the value of the `message` argument to make
        // this check more accurate
        this.getArgument(1).asExpr().getExpr() instanceof NilLiteral
      ) and
      exprNodeReturnedFrom(result, this.getBlock().asExpr().getExpr())
    }
  }

  /**
   * A call to `Logger#<<`.
   */
  private class LoggerPushCall extends LoggerLoggingCall {
    LoggerPushCall() { this.getMethodName() = "<<" }

    override DataFlow::Node getAnInput() {
      // Logger#<<(msg)
      result = this.getArgument(0)
    }
  }

  /**
   * A call to a `Logger` method that logs at a preset severity level.
   *
   * Specifically, these methods are `debug`, `error`, `fatal`, `info`,
   * `unknown`, and `warn`.
   */
  private class LoggerInfoStyleCall extends LoggerLoggingCall {
    LoggerInfoStyleCall() {
      this.getMethodName() = ["debug", "error", "fatal", "info", "unknown", "warn"]
    }

    override DataFlow::Node getAnInput() {
      // `msg` from `Logger#info(msg)`,
      // or `progname` from `Logger#info(progname) <block>`
      result = this.getArgument(0)
      or
      // a return value from the block in `Logger#info(progname) <block>`
      exprNodeReturnedFrom(result, this.getBlock().asExpr().getExpr())
    }
  }

  /**
   * A call to `Logger#progname=`. This sets a default progname.
   * This call does not log anything directly, but the assigned value can appear
   * in future log messages that do not specify a `progname` argument.
   */
  private class LoggerSetPrognameCall extends LoggerLoggingCall {
    LoggerSetPrognameCall() { this.getMethodName() = "progname=" }

    override DataFlow::Node getAnInput() {
      exists(CfgNodes::ExprNodes::AssignExprCfgNode a | this.getArgument(0).asExpr() = a |
        result.asExpr() = a.getRhs()
      )
    }
  }
}
