/**
 * @name Exposure of Data Element to Wrong Session
 * @description Different sessions can use non-final member
 *              fields, causing data to be provided to the wrong session.
 * @kind path-problem
 * @problem.severity error
 * @precision high
 * @id java/wrong-session
 * @tags security
 *       external/cwe/cwe-488
 */

import java
import WrongSessionLib
import semmle.code.java.dataflow.FlowSources
import DataFlow::PathGraph

class WrongSessionConfig extends TaintTracking::Configuration {
  WrongSessionConfig() { this = "WrongSessionConfig" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof RemoteFlowSource and
    not hasDefaultValue(source) and
    source.getEnclosingCallable() instanceof RequestMethod
  }

  override predicate isSink(DataFlow::Node sink) { sink instanceof WrongSessionSink }
}

from
  DataFlow::PathNode source, DataFlow::PathNode sink, WrongSessionConfig conf, InputJudgeConfig ijc
where
  conf.hasFlowPath(source, sink) and
  ijc.hasFlow(source.getNode(), _)
select sink.getNode(), source, sink, "Wrong session might include code from $@.", source.getNode(),
  "this user input"
