import java
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.internal.DataFlowImplSpecific

private import codeql.dataflowstack.DataFlowStack as DFS
private import DFS::DataFlowStackMake<Location, JavaDataFlow> as DataFlowStackFactory

module DataFlowStackMake<DataFlowStackFactory::DataFlow::GlobalFlowSig Flow>{
    import DataFlowStackFactory::FlowStack<Flow>
}

module BiStackAnalysisMake<DataFlowStackFactory::DataFlow::GlobalFlowSig FlowA, DataFlowStackFactory::DataFlow::GlobalFlowSig FlowB>{
    import DataFlowStackFactory::BiStackAnalysis<FlowA, FlowB>
}