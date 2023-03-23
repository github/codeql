import go
import TestUtilities.InlineExpectationsTest

class SqlTest extends InlineExpectationsTest {
  SqlTest() { this = "SQLTest" }

  override string getARelevantTag() { result = "query" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "query" and
    exists(SQL::Query q, SQL::QueryString qs, int qsLine | qs = q.getAQueryString() |
      q.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      qs.hasLocationInfo(_, qsLine, _, _, _) and
      element = q.toString() and
      value = qs.toString()
    )
  }
}

class QueryString extends InlineExpectationsTest {
  QueryString() { this = "QueryString no Query" }

  override string getARelevantTag() { result = "querystring" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "querystring" and
    element = "" and
    exists(SQL::QueryString qs | not exists(SQL::Query q | qs = q.getAQueryString()) |
      qs.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      value = qs.toString()
    )
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "pg-orm config" }

  override predicate isSource(DataFlow::Node n) {
    n.asExpr() instanceof StringLit
  }

  override predicate isSink(DataFlow::Node n) {
    n = any(DataFlow::CallNode cn | cn.getTarget().getName() = "sink").getAnArgument()
  }
}

class TaintFlow extends InlineExpectationsTest {
  TaintFlow() { this = "pg-orm flow" }

  override string getARelevantTag() { result = "flowfrom" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flowfrom" and
    element = "" and
    exists(Config c, DataFlow::Node fromNode, DataFlow::Node toNode |
      toNode.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      c.hasFlow(fromNode, toNode) and
      value = fromNode.asExpr().(StringLit).getValue()
    )
  }
}