/**
 * @name Resolving XML external entity in user-controlled data (experimental sinks)
 * @description Parsing user-controlled XML documents and allowing expansion of external entity
 *              references may lead to disclosure of confidential data or denial of service.
 *              (note this version differs from query `java/xxe` by including support for additional possibly-vulnerable XML parsers)
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/xxe-with-experimental-sinks
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
