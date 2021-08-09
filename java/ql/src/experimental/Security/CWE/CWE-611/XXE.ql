/**
 * @name Resolving XML external entity in user-controlled data
 * @description Parsing user-controlled XML documents and allowing expansion of external entity
 *              references may lead to disclosure of confidential data or denial of service.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/xxe
 * @tags security
 *       external/cwe/cwe-611
 */

import java
import XXELib
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class XxeConfig extends TaintTracking::Configuration {
  XxeConfig() { this = "XxeConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) { sink instanceof UnsafeXxeSink }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, XxeConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Unsafe parsing of XML file from $@.", source.getNode(),
  "user input"
