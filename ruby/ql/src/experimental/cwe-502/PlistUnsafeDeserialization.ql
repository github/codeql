/**
 * @name Unsafe Deserialization of user-controlled data by Plist
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @id rb/plist-unsafe-deserialization
 * @tags security
 *       experimental
 *       external/cwe/cwe-502
 */

import codeql.ruby.ApiGraphs
import codeql.ruby.DataFlow
import codeql.ruby.TaintTracking
import codeql.ruby.CFG
import DataFlow::PathGraph
import codeql.ruby.security.UnsafeDeserializationCustomizations

abstract class PlistUnsafeSinks extends DataFlow::Node { }

/**
 * An argument in a call to `Plist.parse_xml` where the marshal is `true` (which is
 * the default), considered a sink for unsafe deserialization.
 */
class UnsafePlistParsexmlArgument extends PlistUnsafeSinks {
  UnsafePlistParsexmlArgument() {
    exists(DataFlow::CallNode plistParseXml |
      plistParseXml = API::getTopLevelMember("Plist").getAMethodCall("parse_xml")
    |
      this = [plistParseXml.getArgument(0), plistParseXml.getKeywordArgument("filename_or_xml")] and
      plistParseXml.getKeywordArgument("marshal").getConstantValue().isBoolean(true)
      or
      this = [plistParseXml.getArgument(0), plistParseXml.getKeywordArgument("filename_or_xml")] and
      plistParseXml.getNumberOfArguments() = 1
    )
  }
}

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "PlistUnsafeDeserialization" }

  override predicate isSource(DataFlow::Node source) {
    // to detect CVE-2021-33575, we should uncomment following line instead of current UnsafeDeserialization::Source
    // source instanceof DataFlow::LocalSourceNode
    source instanceof UnsafeDeserialization::Source
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof PlistUnsafeSinks }
}

from Configuration config, DataFlow::PathNode source, DataFlow::PathNode sink
where config.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe deserialization depends on a $@.", source.getNode(),
  "potentially untrusted source"
