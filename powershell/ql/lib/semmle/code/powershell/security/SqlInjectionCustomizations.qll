/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * SQL-injection vulnerabilities, as well as extension points for
 * adding your own.
 */

private import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
private import semmle.code.powershell.dataflow.flowsources.FlowSources
private import semmle.code.powershell.Cfg

module SqlInjection {
  /**
   * A data flow source for SQL-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this flow source. */
    abstract string getSourceType();
  }

  /**
   * A data flow sink for SQL-injection vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    abstract string getSinkType();
  }

  /**
   * A sanitizer for SQL-injection vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of user input, considered as a flow source for command injection. */
  class FlowSourceAsSource extends Source instanceof SourceNode {
    override string getSourceType() { result = "user-provided value" }
  }

  class InvokeSqlCmdSink extends Sink {
    InvokeSqlCmdSink() {
      exists(DataFlow::CallNode call | call.matchesName("Invoke-Sqlcmd") |
        this = call.getNamedArgument("query")
        or
        not call.hasNamedArgument("query") and
        this = call.getArgument(0)
      )
    }

    override string getSinkType() { result = "call to Invoke-Sqlcmd" }
  }

  class ConnectionStringWriteSink extends Sink {
    string memberName;

    ConnectionStringWriteSink() {
      exists(CfgNodes::StmtNodes::AssignStmtCfgNode assign |
        memberName = "CommandText" and
        assign
            .getLeftHandSide()
            .(CfgNodes::ExprNodes::MemberExprCfgNode)
            .memberNameMatches(memberName) and
        assign.getRightHandSide() = this.asExpr()
      )
    }

    override string getSinkType() { result = "write to " + memberName }
  }

  class SqlCmdSink extends Sink {
    SqlCmdSink() {
      exists(DataFlow::CallOperatorNode call |
        call.getCommand().asExpr().getValue().stringMatches("sqlcmd") and
        call.getAnArgument() = this
      )
    }

    override string getSinkType() { result = "call to sqlcmd" }
  }
}
