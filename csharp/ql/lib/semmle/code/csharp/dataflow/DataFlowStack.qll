
private import codeql.dataflow.DataFlow
private import semmle.code.csharp.dataflow.internal.DataFlowImplSpecific

private import codeql.dataflowstack.DataFlowStack as DFS
private import DFS::DataFlowStackMake<CsharpDataFlow> as DataFlowStackFactory

module DataFlowStackMake<DataFlowStackFactory::DataFlow::GlobalFlowSig Flow>{
    import DataFlowStackFactory::FlowStack<Flow>
}