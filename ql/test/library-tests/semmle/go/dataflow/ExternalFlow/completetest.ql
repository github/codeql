/**
 * @kind path-problem
 */

import go
import semmle.go.dataflow.DataFlow
import semmle.go.dataflow.ExternalFlow
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import CsvValidation

import DataFlow::PartialPathGraph

class SummaryModelTest extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        "github.com/nonexistent/test;;false;StepArgResContent;;;Argument[0];ArrayElement of ReturnValue;taint",
        "github.com/nonexistent/test;T;false;StepArgRes;;;Argument[0];ReturnValue;taint"
      ]
  }
}

class SourceModelTest extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; -; ext; output; kind`
        "github.com/nonexistent/test;A;false;Src1;;;ReturnValue;qltest"
      ]
  }
}

class SinkModelTest extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        //`namespace; type; subtypes; name; -; ext; input; kind`
        "github.com/nonexistent/test;B;false;Sink1;;;Argument[0];qltest"
      ]
  }
}

class Config extends TaintTracking::Configuration {
  Config() { this = "external-flow-test" }

  override predicate isSource(DataFlow::Node src) { sourceNode(src, "qltest") }

  override predicate isSink(DataFlow::Node src) { sinkNode(src, "qltest") }

  override int explorationLimit() { result = 10}
}

/* from Config cfg, DataFlow::PathNode src, DataFlow::PathNode sink
where cfg.hasFlowPath(src, sink)
select src, src, sink, "path" */

from Config cfg, DataFlow::PartialPathNode src, DataFlow::PartialPathNode sink
where cfg.hasPartialFlow(src, sink, _) and not edges(sink, _)
select src, src, sink, "path", sink.toString(), sink.getAQlClass()
