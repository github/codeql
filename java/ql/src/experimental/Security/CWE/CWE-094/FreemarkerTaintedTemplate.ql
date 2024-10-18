/**
 * @id java/freemarker-tainted
 * @name Tainted Freemarker Template
 * @description Building a template from user-controlled sources is vulnerable to insertion of
 *              malicious code by the user. This may lead up to remote code execution and data leakage.
 * @kind path-problem
 * @problem.severity error
 * @tags security
 *       external/cwe/cwe-094
 * @precision high
 */

import java
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph
import semmle.code.java.dataflow.TaintTracking
import Freemarker

class FreemarkerTaintedTemplateConfig extends TaintTracking::Configuration {
  FreemarkerTaintedTemplateConfig() { this = "FreemarkerTaintedTemplateConfig" }

  override predicate isSource(DataFlow::Node src) { src instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    any(Freemarker::NewTemplate t).getSink() = sink.asExpr()
    or
    any(Freemarker::FreemarkerPutTemplate t).getSink() = sink.asExpr()
  }
  // override int fieldFlowBranchLimit() { result = 0 }
}

from DataFlow::PathNode source, DataFlow::PathNode sink, FreemarkerTaintedTemplateConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "Template is built using $@.", source.getNode(), "user input"
