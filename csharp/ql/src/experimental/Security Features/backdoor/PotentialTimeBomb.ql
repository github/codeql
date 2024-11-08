/**
 * @name Potential Timebomb
 * @description If there is data flow from a file's last modification date and an offset to a condition statement, this could trigger a "time bomb".
 * @kind path-problem
 * @precision Low
 * @problem.severity warning
 * @id cs/backdoor/potential-time-bomb
 * @tags security
 *       experimental
 *       solorigate
 */

import csharp
import Flow::PathGraph

query predicate edges(Flow::PathNode a, Flow::PathNode b, string key, string val) {
  Flow::PathGraph::edges(a, b, key, val)
  or
  FlowsFromGetLastWriteTimeConfigToTimeSpanArithmeticCallableConfig::isSink(a.getNode()) and
  FlowsFromTimeSpanArithmeticToTimeComparisonCallableConfig::isSource(b.getNode()) and
  key = "provenance" and
  val = ""
  or
  FlowsFromTimeSpanArithmeticToTimeComparisonCallableConfig::isSink(a.getNode()) and
  FlowsFromTimeComparisonCallableToSelectionStatementConditionConfig::isSource(b.getNode()) and
  key = "provenance" and
  val = ""
}

/**
 * Class that will help to find the source for the trigger file-modification date.
 *
 * May be extended as new patterns for similar time bombs are found.
 */
class GetLastWriteTimeMethod extends Method {
  GetLastWriteTimeMethod() {
    this.hasFullyQualifiedName("System.IO.File",
      ["GetLastWriteTime", "GetFileCreationTime", "GetCreationTimeUtc", "GetLastAccessTimeUtc"])
  }
}

/**
 * Abstracts `System.DateTime` structure
 */
class DateTimeStruct extends Struct {
  DateTimeStruct() { this.hasFullyQualifiedName("System", "DateTime") }

  /**
   * holds if the Callable is used for DateTime arithmetic operations
   */
  Callable getATimeSpanArithmeticCallable() {
    (result = this.getAnOperator() or result = this.getAMethod()) and
    result.getName() in [
        "Add", "AddDays", "AddHours", "AddMilliseconds", "AddMinutes", "AddMonths", "AddSeconds",
        "AddTicks", "AddYears", "+", "-"
      ]
  }

  /**
   * Holds if the Callable is used for DateTime comparison
   */
  Callable getAComparisonCallable() {
    (result = this.getAnOperator() or result = this.getAMethod()) and
    result.getName() in ["Compare", "CompareTo", "Equals", "==", "!=", "<", ">", "<=", ">="]
  }
}

/**
 * Configuration to find flow from a GetLastWriteTime source to a DateTime arithmetic operation
 */
private module FlowsFromGetLastWriteTimeConfigToTimeSpanArithmeticCallableConfig implements
  DataFlow::ConfigSig
{
  predicate isSource(DataFlow::Node source) {
    exists(Call call, GetLastWriteTimeMethod m |
      m.getACall() = call and
      source.asExpr() = call
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Call call, DateTimeStruct dateTime |
      call.getAChild*() = sink.asExpr() and
      call = dateTime.getATimeSpanArithmeticCallable().getACall()
    )
  }
}

/**
 * Tainttracking module to find flow from a GetLastWriteTime source to a DateTime arithmetic operation
 */
private module FlowsFromGetLastWriteTimeConfigToTimeSpanArithmeticCallable =
  TaintTracking::Global<FlowsFromGetLastWriteTimeConfigToTimeSpanArithmeticCallableConfig>;

/**
 * Configuration to find flow from a DateTime arithmetic operation to a DateTime comparison operation
 */
private module FlowsFromTimeSpanArithmeticToTimeComparisonCallableConfig implements
  DataFlow::ConfigSig
{
  predicate isSource(DataFlow::Node source) {
    exists(DateTimeStruct dateTime, Call call | source.asExpr() = call |
      call = dateTime.getATimeSpanArithmeticCallable().getACall()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(Call call, DateTimeStruct dateTime |
      call.getAnArgument().getAChild*() = sink.asExpr() and
      call = dateTime.getAComparisonCallable().getACall()
    )
  }
}

/**
 * Tainttracking module to find flow from a DateTime arithmetic operation to a DateTime comparison operation
 */
private module FlowsFromTimeSpanArithmeticToTimeComparisonCallable =
  TaintTracking::Global<FlowsFromTimeSpanArithmeticToTimeComparisonCallableConfig>;

/**
 * Configuration to find flow from a DateTime comparison operation to a Selection Statement (such as an If)
 */
private module FlowsFromTimeComparisonCallableToSelectionStatementConditionConfig implements
  DataFlow::ConfigSig
{
  predicate isSource(DataFlow::Node source) {
    exists(DateTimeStruct dateTime, Call call | source.asExpr() = call |
      call = dateTime.getAComparisonCallable().getACall()
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(SelectionStmt sel | sel.getCondition().getAChild*() = sink.asExpr())
  }
}

/**
 * Tainttracking module to find flow from a DateTime comparison operation to a Selection Statement (such as an If)
 */
private module FlowsFromTimeComparisonCallableToSelectionStatementCondition =
  TaintTracking::Global<FlowsFromTimeComparisonCallableToSelectionStatementConditionConfig>;

private module Flow =
  DataFlow::MergePathGraph3<FlowsFromGetLastWriteTimeConfigToTimeSpanArithmeticCallable::PathNode,
    FlowsFromTimeSpanArithmeticToTimeComparisonCallable::PathNode,
    FlowsFromTimeComparisonCallableToSelectionStatementCondition::PathNode,
    FlowsFromGetLastWriteTimeConfigToTimeSpanArithmeticCallable::PathGraph,
    FlowsFromTimeSpanArithmeticToTimeComparisonCallable::PathGraph,
    FlowsFromTimeComparisonCallableToSelectionStatementCondition::PathGraph>;

/**
 * Holds if the last file modification date from the call to getLastWriteTimeMethodCall will be used in a DateTime arithmetic operation timeArithmeticCall,
 * which is then used for a DateTime comparison timeComparisonCall and the result flows to a Selection statement which is likely a TimeBomb trigger
 */
predicate isPotentialTimeBomb(
  Flow::PathNode pathSource, Flow::PathNode pathSink, Call getLastWriteTimeMethodCall,
  Call timeArithmeticCall, Call timeComparisonCall, SelectionStmt selStatement
) {
  exists(DataFlow::Node sink, DateTimeStruct dateTime, DataFlow::Node sink2, DataFlow::Node sink3 |
    pathSource.getNode() = DataFlow::exprNode(getLastWriteTimeMethodCall) and
    FlowsFromGetLastWriteTimeConfigToTimeSpanArithmeticCallable::flow(DataFlow::exprNode(getLastWriteTimeMethodCall),
      sink) and
    timeArithmeticCall = dateTime.getATimeSpanArithmeticCallable().getACall() and
    timeArithmeticCall.getAChild*() = sink.asExpr() and
    FlowsFromTimeSpanArithmeticToTimeComparisonCallable::flow(DataFlow::exprNode(timeArithmeticCall),
      sink2) and
    timeComparisonCall = dateTime.getAComparisonCallable().getACall() and
    timeComparisonCall.getAnArgument().getAChild*() = sink2.asExpr() and
    FlowsFromTimeComparisonCallableToSelectionStatementCondition::flow(DataFlow::exprNode(timeComparisonCall),
      sink3) and
    selStatement.getCondition().getAChild*() = sink3.asExpr() and
    pathSink.getNode() = sink3
  )
}

deprecated query predicate problems(
  SelectionStmt selStatement, Flow::PathNode source, Flow::PathNode sink, string message,
  Call timeComparisonCall, string timeComparisonCallString, Call timeArithmeticCall, string offset,
  Call getLastWriteTimeMethodCall, string lastWriteTimeMethodCallMessage
) {
  isPotentialTimeBomb(source, sink, getLastWriteTimeMethodCall, timeArithmeticCall,
    timeComparisonCall, selStatement) and
  message =
    "Possible TimeBomb logic triggered by an $@ that takes into account $@ from the $@ as part of the potential trigger." and
  timeComparisonCallString = timeComparisonCall.toString() and
  offset = "offset" and
  lastWriteTimeMethodCallMessage = "last modification time of a file"
}
