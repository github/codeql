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

class DecompressionAPIUse extends DataFlow::Node {

    // this should find the first argument of Zlib::Inflate.inflate or Zip::File.extract
    DecompressionAPIUse() {
        this = API::getTopLevelMember("Zlib").getMember("Inflate").getAMethodCall("inflate").getArgument(0) or
        this = API::getTopLevelMember("Zip").getMember("File").getAMethodCall("open").getArgument(0) or
        this = API::getTopLevelMember("Zip").getMember("Entry").getAMethodCall("extract").getArgument(0)
    }

}

class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "DecompressionAPIUse" }
  
    // this predicate will be used to contstrain our query to find instances where only remote user-controlled data flows to the sink
    override predicate isSource(DataFlow::Node source) {
        source instanceof RemoteFlowSource
    }

    // our Decompression APIs defined above will the the sinks we use for this query
    override predicate isSink(DataFlow::Node sink) {
        sink instanceof DecompressionAPIUse
    }

    // I think it would also be helpful to reduce false positives by adding a simple sanitizer config in the event
    // that the code first checks the file name against a string literal or array of string literals before calling
    // the decompression API
    override predicate isSanitizerGuard(DataFlow::BarrierGuard guard) {
        guard instanceof StringConstCompare or
        guard instanceof StringConstArrayInclusionCall
    }
  }
  

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where
  config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "This call to $@ is unsafe because user-controlled data is used to set the object being decompressed, which could lead to a denial of service attack or malicious code extracted from an unknown source."
