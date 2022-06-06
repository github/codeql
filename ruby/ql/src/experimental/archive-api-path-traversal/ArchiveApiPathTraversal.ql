/**
 * @name User-controlled filename in archive library
 * @description User-controlled data that flows into File I/O of archive libraries could be dangerous
 * @kind path-problem
 * @problem.severity error
 * @security-severity 7.0
 * @precision medium
 * @id rb/user-controlled-path-traversal-archive-library
 * @tags security external/cwe/cwe-22
 */

import ruby
import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.TaintTracking
import DataFlow::PathGraph

class ArchiveApiFileOpen extends DataFlow::Node {

    // this should find the first argument of Zlib::Inflate.inflate or Zip::File.extract
    ArchiveApiFileOpen() {
        this instanceof RubyZipFileOpen or
        this instanceof TarReaderFileOpen
    }

}

class RubyZipFileOpen extends DataFlow::Node {
    // find any use of Zip::File.open()
    RubyZipFileOpen() {
        this = API::getTopLevelMember("Zip").getMember("File").getAMethodCall("open").getArgument(0)
    }
}

class TarReaderFileOpen extends DataFlow::Node {
    // this should find a use of File.open() in context of a block opened in context of Gem::Package::TarReader.new()
    TarReaderFileOpen() {
        this = API::getTopLevelMember("File").getAMethodCall("open").getArgument(0) and
        this.asExpr().getExpr().getParent+() = API::getTopLevelMember("Gem").getMember("Package").getMember("TarReader").getAnInstantiation().asExpr().getExpr()
    }
}

class Configuration extends TaintTracking::Configuration {
    Configuration() { this = "ArchiveApiFileOpen" }
  
    // this predicate will be used to contstrain our query to find instances where only remote user-controlled data flows to the sink
    override predicate isSource(DataFlow::Node source) {
        source instanceof RemoteFlowSource
    }

    // our Decompression APIs defined above will the the sinks we use for this query
    override predicate isSink(DataFlow::Node sink) {
        sink instanceof ArchiveApiFileOpen
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
select sink.getNode(), source, sink, "This call to $@ appears to extract an archive using user-controlled data $@ to set the filename. If the filename is not properly handled, they could end up writing to unintended places in the filesystem.", sink.getNode().asExpr().getExpr().getParent().toString(), sink.getNode().asExpr().getExpr().getParent().toString(), source.toString(), source.toString()
