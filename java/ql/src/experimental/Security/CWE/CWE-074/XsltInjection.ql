/**
 * @name XSLT transformation with user-controlled stylesheet
 * @description Doing an XSLT transformation with user-controlled stylesheet can lead to
 *              information disclosure or execution of arbitrary code.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/xslt-injection
 * @tags security
 *       external/cwe/cwe-074
 */

import java
import semmle.code.java.dataflow.FlowSources
import XsltInjectionLib
import DataFlow::PathGraph

from DataFlow::PathNode source, DataFlow::PathNode sink, XsltInjectionFlowConfig conf
where conf.hasFlowPath(source, sink)
select sink.getNode(), source, sink, "XSLT transformation might include stylesheet from $@.",
  source.getNode(), "this user input"
