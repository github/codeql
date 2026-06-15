/** Provides the instantiation of the shared taint tracking library. */

private import semmle.javascript.Locations
private import codeql.dataflow.TaintTracking
private import DataFlowArg
import TaintFlowMake<Location, JSDataFlow, JSTaintFlow>
