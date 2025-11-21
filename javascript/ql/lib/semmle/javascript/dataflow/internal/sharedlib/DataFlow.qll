/** Provides the instantiation of the shared data flow library. */
overlay[local?]
module;

private import semmle.javascript.Locations
private import codeql.dataflow.DataFlow
private import DataFlowArg
import DataFlowMake<Location, JSDataFlow>
import DataFlowImplSpecific::Public
