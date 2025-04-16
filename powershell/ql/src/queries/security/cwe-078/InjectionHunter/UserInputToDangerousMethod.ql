/**
 * @name User Input to injection sink
 * @description Finding cases where the user input is passed an dangerous method that can lead to RCE
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.8
 * @precision high
 * @id powershell/microsoft/public/user-input-to-injection-sink
 * @tags security
 *       external/cwe/cwe-078
 *       external/cwe/cwe-088
 */

import powershell
import semmle.code.powershell.dataflow.TaintTracking
import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
import semmle.code.powershell.dataflow.flowsources.FlowSources

import Sanitizers
import Sinks

private module InjectionConfig implements DataFlow::ConfigSig {
    predicate isSource(DataFlow::Node source) { 
        source instanceof SourceNode
    }
    predicate isSink(DataFlow::Node sink) { sink instanceof InjectionSink }
    predicate isBarrier(DataFlow::Node node) {node instanceof Sanitizer}
}

module InjectionFlow = TaintTracking::Global<InjectionConfig>;
import InjectionFlow::PathGraph

from InjectionFlow::PathNode source, InjectionFlow::PathNode sink
where InjectionFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Possible injection path from user input to dangerous " + sink.getNode().(InjectionSink).getSinkType()
