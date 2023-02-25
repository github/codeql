/**
 * @name Unsafe Deserialization of user-controlled data by Plist
 * @description Deserializing user-controlled data may allow attackers to
 *              execute arbitrary code.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 9.8
 * @precision high
 * @id rb/Plist-unsafe-deserialization
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
 * check whether an input argument has desired "key: value" input or not.
 * borrowed from UnsafeDeserialization module with some changes
 */
predicate checkkeyBalue(CfgNodes::ExprNodes::PairCfgNode p, string key, string value) {
  p.getKey().getConstantValue().isStringlikeValue(key) and
  DataFlow::exprNode(p.getValue()).getALocalSource().getConstantValue().toString() = value
}

/**
 * An argument in a call to `Plist.parse_xml` where the marshal is `true` (which is
 * the default), considered a sink for unsafe deserialization.
 * borrowed from UnsafeDeserialization module with some changes
 */
class UnsafePlistParsexmlArgument extends PlistUnsafeSinks {
  UnsafePlistParsexmlArgument() {
    exists(DataFlow::CallNode plistParsexml |
      plistParsexml = API::getTopLevelMember("Plist").getAMethodCall("parse_xml")
    |
      this = [plistParsexml.getArgument(0), plistParsexml.getKeywordArgument("filename_or_xml")] and
      // Exclude calls that explicitly pass a safe mode option.
      checkkeyBalue(plistParsexml.getArgument(1).asExpr(), "marshal", "true")
      or
      this = [plistParsexml.getArgument(0), plistParsexml.getKeywordArgument("filename_or_xml")] and
      plistParsexml.getNumberOfArguments() = 1
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
