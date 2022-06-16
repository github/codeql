/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs could be dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id rb/user-controlled-file-decompression
 * @tags security external/cwe/cwe-409
 */

import ruby
import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.TaintTracking
import DataFlow::PathGraph

class DecompressionApiUse extends DataFlow::Node {
  // this should find the first argument of Zlib::Inflate.inflate
  DecompressionApiUse() {
    this =
      API::getTopLevelMember("Zlib").getMember("Inflate").getAMethodCall("inflate").getArgument(0)
  }
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "DecompressionApiUse" }

  // this predicate will be used to contstrain our query to find instances where only remote user-controlled data flows to the sink
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  // our Decompression APIs defined above will the the sinks we use for this query
  override predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionApiUse }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink,
  "This call to $@ is unsafe because user-controlled data is used to set the object being decompressed, which could lead to a denial of service attack or malicious code extracted from an unknown source.",
  sink.getNode().asExpr().getExpr().getParent(),
  sink.getNode().asExpr().getExpr().getParent().toString()
