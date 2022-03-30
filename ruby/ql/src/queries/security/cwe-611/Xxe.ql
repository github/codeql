/**
 * @name XML external entity expansion
 * @description Parsing user input as an XML document with external
 *              entity expansion is vulnerable to XXE attacks.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id rb/xxe
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-776
 *       external/cwe/cwe-827
 */

import ruby
import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.TaintTracking
import codeql.ruby.Concepts
import codeql.ruby.DataFlow
import DataFlow::PathGraph

class UnsafeXxeSink extends DataFlow::ExprNode {
  UnsafeXxeSink() {
    exists(XmlParserCall parse |
      parse.getInput() = this and
      parse.externalEntitiesEnabled()
    )
  }
}

class XxeConfig extends TaintTracking::Configuration {
  XxeConfig() { this = "XXE.ql::XxeConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeXxeSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XxeConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe parsing of XML file from $@.", source.getNode(),
  "user input"
