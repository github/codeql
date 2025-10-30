/**
 * Provides classes and predicates for reasoning about database
 * queries built from user-controlled sources (that is, SQL injection
 * vulnerabilities).
 */

import rust
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.FlowSink
private import codeql.rust.Concepts
private import codeql.util.Unit
private import codeql.rust.controlflow.ControlFlowGraph as Cfg
private import codeql.rust.controlflow.CfgNodes as CfgNodes

/**
 * Provides default sources, sinks and barriers for detecting SQL injection
 * vulnerabilities, as well as extension points for adding your own.
 */
module SqlInjection {
  /**
   * A data flow source for SQL injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for SQL injection vulnerabilities.
   */
  abstract class Sink extends QuerySink::Range {
    override string getSinkType() { result = "SqlInjection" }
  }

  /**
   * A barrier for SQL injection vulnerabilities.
   */
  abstract class Barrier extends DataFlow::Node { }

  /**
   * An active threat-model source, considered as a flow source.
   */
  private class ActiveThreatModelSourceAsSource extends Source, ActiveThreatModelSource { }

  /**
   * A flow sink that is the statement of an SQL construction.
   */
  class SqlConstructionAsSink extends Sink {
    SqlConstructionAsSink() { this = any(SqlConstruction c).getSql() }
  }

  /**
   * A flow sink that is the statement of an SQL execution.
   */
  class SqlExecutionAsSink extends Sink {
    SqlExecutionAsSink() { this = any(SqlExecution e).getSql() }
  }

  /**
   * A sink for sql-injection from model data.
   */
  private class ModelsAsDataSink extends Sink {
    ModelsAsDataSink() { sinkNode(this, "sql-injection") }
  }

  /**
   * A barrier for SQL injection vulnerabilities for nodes that result from parsing to numeric types.
   *
   * Numeric types are considered safe because they cannot contain SQL injection payloads.
   * This barrier stops taint flow when untrusted data is parsed to a numeric type like i32, u32, f64, etc.
   */
  private class NumericTypeBarrier extends Barrier {
    NumericTypeBarrier() {
      // Match dataflow nodes that come from the result of parsing strings to numeric types
      // The parse method is called with a turbofish operator specifying the target type: .parse::<i32>()
      exists(MethodCallExpr parse, string typeName |
        parse.getIdentifier().getText() = "parse" and
        this.asExpr().getExpr() = parse and
        // Extract the type name from the generic argument list
        typeName = parse.getGenericArgList().toString() and
        // Check if it's a numeric type
        (
          typeName.matches("%i8%") or
          typeName.matches("%i16%") or
          typeName.matches("%i32%") or
          typeName.matches("%i64%") or
          typeName.matches("%i128%") or
          typeName.matches("%isize%") or
          typeName.matches("%u8%") or
          typeName.matches("%u16%") or
          typeName.matches("%u32%") or
          typeName.matches("%u64%") or
          typeName.matches("%u128%") or
          typeName.matches("%usize%") or
          typeName.matches("%f32%") or
          typeName.matches("%f64%")
        )
      )
    }
  }

  /**
   * Holds if comparison `guard` validates `node` by comparing it with a string literal
   * when `branch` is true.
   */
  private predicate stringConstCompare(CfgNodes::AstCfgNode guard, Cfg::CfgNode node, boolean branch) {
    exists(EqualsOperation eq |
      guard = eq.getACfgNode() and
      branch = true and
      (
        // node == "literal" or "literal" == node
        node = eq.getLhs().getACfgNode() and
        eq.getRhs() instanceof StringLiteralExpr
        or
        node = eq.getRhs().getACfgNode() and
        eq.getLhs() instanceof StringLiteralExpr
      )
    )
    or
    exists(NotEqualsOperation ne |
      guard = ne.getACfgNode() and
      branch = false and
      (
        // node != "literal" or "literal" != node
        node = ne.getLhs().getACfgNode() and
        ne.getRhs() instanceof StringLiteralExpr
        or
        node = ne.getRhs().getACfgNode() and
        ne.getLhs() instanceof StringLiteralExpr
      )
    )
    or
    // Handle multiple comparisons with OR
    stringConstCompareOr(guard, node, branch)
  }

  /**
   * Holds if `guard` is an OR expression where both operands compare `node`
   * with string literals when `branch` is true.
   */
  private predicate stringConstCompareOr(
    CfgNodes::AstCfgNode guard, Cfg::CfgNode node, boolean branch
  ) {
    exists(LogicalOrExpr orExpr, EqualsOperation eqLeft, EqualsOperation eqRight |
      guard = orExpr.getACfgNode() and
      branch = true and
      eqLeft.getACfgNode() = orExpr.getLhs().getACfgNode() and
      eqRight.getACfgNode() = orExpr.getRhs().getACfgNode() and
      // Both sides must compare the same node against string literals
      (
        node = eqLeft.getLhs().getACfgNode() and
        node = eqRight.getLhs().getACfgNode() and
        eqLeft.getRhs() instanceof StringLiteralExpr and
        eqRight.getRhs() instanceof StringLiteralExpr
        or
        node = eqLeft.getRhs().getACfgNode() and
        node = eqRight.getRhs().getACfgNode() and
        eqLeft.getLhs() instanceof StringLiteralExpr and
        eqRight.getLhs() instanceof StringLiteralExpr
      )
    )
  }

  /**
   * A barrier for SQL injection vulnerabilities where the data is validated
   * against one or more constant string values.
   *
   * For example, `if remote_string == "admin"` or `if remote_string == "person" || remote_string == "vehicle"`.
   */
  private class StringConstCompareBarrier extends Barrier {
    StringConstCompareBarrier() {
      this = DataFlow::BarrierGuard<stringConstCompare/3>::getABarrierNode()
    }
  }

  /**
   * Holds if `guard` is a call to a collection contains/includes method that checks
   * if `node` is in a collection of string literals.
   */
  private predicate stringConstArrayInclusionCall(
    CfgNodes::AstCfgNode guard, Cfg::CfgNode node, boolean branch
  ) {
    exists(MethodCallExpr call |
      guard = call.getACfgNode() and
      branch = true and
      // Check for contains() method call
      call.getIdentifier().getText() = "contains" and
      // The argument should be the node we're checking
      node = call.getArgList().getAnArg().getACfgNode() and
      // The receiver should be an array/slice/collection of string literals
      exists(Expr receiver |
        receiver = call.getReceiver() and
        isArrayOfStringLiterals(receiver)
      )
    )
  }

  /**
   * Holds if `expr` is an array or slice literal containing only string literals.
   */
  private predicate isArrayOfStringLiterals(Expr expr) {
    // Array literal: ["str1", "str2", "str3"]
    expr instanceof ArrayListExpr and
    forex(Expr elem | elem = expr.(ArrayListExpr).getExpr(_) | elem instanceof StringLiteralExpr)
  }

  /**
   * A barrier for SQL injection where the data is validated by checking
   * if it's contained in a collection of constant string values.
   *
   * For example, `if ["admin", "user"].contains(&remote_string)`.
   */
  private class StringConstArrayInclusionCallBarrier extends Barrier {
    StringConstArrayInclusionCallBarrier() {
      this = DataFlow::BarrierGuard<stringConstArrayInclusionCall/3>::getABarrierNode()
    }
  }
}
