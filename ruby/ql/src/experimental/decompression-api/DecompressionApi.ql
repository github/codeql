/**
 * @name User-controlled file decompression
 * @description User-controlled data that flows into decompression library APIs could be dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.8
 * @precision medium
 * @id rb/user-controlled-file-decompression
 * @tags security
 *       experimental
 *       external/cwe/cwe-409
 */

import codeql.ruby.AST
import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.TaintTracking

class DecompressionApiUse extends DataFlow::Node {
  private DataFlow::CallNode call;

  // this should find the first argument in calls to Zlib::Inflate.inflate or Zip::File.open_buffer
  DecompressionApiUse() {
    this = call.getArgument(0) and
    (
      call = API::getTopLevelMember("Zlib").getMember("Inflate").getAMethodCall("inflate") or
      call = API::getTopLevelMember("Zip").getMember("File").getAMethodCall("open_buffer")
    )
  }

  // returns calls to Zlib::Inflate.inflate or Zip::File.open_buffer
  DataFlow::CallNode getCall() { result = call }
}

private module DecompressionApiConfig implements DataFlow::ConfigSig {
  // this predicate will be used to constrain our query to find instances where only remote user-controlled data flows to the sink
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  // our Decompression APIs defined above will be the sinks we use for this query
  predicate isSink(DataFlow::Node sink) { sink instanceof DecompressionApiUse }

  predicate observeDiffInformedIncrementalMode() { any() }

  Location getASelectedSinkLocation(DataFlow::Node sink) {
    result = sink.(DecompressionApiUse).getLocation()
    or
    result = sink.(DecompressionApiUse).getCall().getLocation()
  }
}

private module DecompressionApiFlow = TaintTracking::Global<DecompressionApiConfig>;

import DecompressionApiFlow::PathGraph

from DecompressionApiFlow::PathNode source, DecompressionApiFlow::PathNode sink
where DecompressionApiFlow::flowPath(source, sink)
select sink.getNode().(DecompressionApiUse), source, sink,
  "This call to $@ is unsafe because user-controlled data is used to set the object being decompressed, which could lead to a denial of service attack or malicious code extracted from an unknown source.",
  sink.getNode().(DecompressionApiUse).getCall(),
  sink.getNode().(DecompressionApiUse).getCall().getMethodName()
