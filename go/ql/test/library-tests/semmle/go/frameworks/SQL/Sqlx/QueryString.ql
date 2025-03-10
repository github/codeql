import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module SqlTest implements TestSig {
  string getARelevantTag() { result = "query" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "query" and
    exists(SQL::Query q, SQL::QueryString qs | qs = q.getAQueryString() |
      q.getLocation() = location and
      element = q.toString() and
      value = qs.toString()
    )
  }
}

module QueryString implements TestSig {
  string getARelevantTag() { result = "querystring" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "querystring" and
    element = "" and
    exists(SQL::QueryString qs | not exists(SQL::Query q | qs = q.getAQueryString()) |
      qs.getLocation() = location and
      value = qs.toString()
    )
  }
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n.asExpr() instanceof StringLit }

  predicate isSink(DataFlow::Node n) {
    n = any(DataFlow::CallNode cn | cn.getTarget().getName() = "sink").getAnArgument()
  }
}

module Flow = TaintTracking::Global<Config>;

module TaintFlow implements TestSig {
  string getARelevantTag() { result = "flowfrom" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flowfrom" and
    element = "" and
    exists(DataFlow::Node fromNode, DataFlow::Node toNode |
      toNode.getLocation() = location and
      Flow::flow(fromNode, toNode) and
      value = fromNode.asExpr().(StringLit).getValue()
    )
  }
}

import MakeTest<MergeTests3<SqlTest, QueryString, TaintFlow>>
