/** Provides the instantiation of the shared taint tracking library. */
overlay[local?]
module;

private import semmle.javascript.Locations
private import codeql.dataflow.TaintTracking
private import DataFlowArg
import TaintFlowMake<Location, JSDataFlow, JSTaintFlow>
