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

import codeql.ruby.dataflow.RemoteFlowSources
import codeql.ruby.TaintTracking
import codeql.ruby.Concepts
import codeql.ruby.DataFlow

class UnsafeXxeSink extends DataFlow::ExprNode {
  UnsafeXxeSink() {
    exists(XmlParserCall parse |
      parse.getInput() = this and
      parse.externalEntitiesEnabled()
    )
  }
}

private module XxeConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeXxeSink }

  predicate observeDiffInformedIncrementalMode() { any() }
}

private module XxeFlow = TaintTracking::Global<XxeConfig>;

import XxeFlow::PathGraph

from XxeFlow::PathNode source, XxeFlow::PathNode sink
where XxeFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "XML parsing depends on a $@ without guarding against external entity expansion.",
  source.getNode(), "user-provided value"
