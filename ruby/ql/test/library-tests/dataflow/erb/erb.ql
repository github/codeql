import codeql.ruby.AST
import codeql.ruby.CFG
import ruby
import codeql.ruby.DataFlow
import codeql.ruby.AST
import codeql.ruby.TaintTracking
import codeql.ruby.frameworks.data.internal.ApiGraphModels
import codeql.ruby.ApiGraphs
import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.CFG
private import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.ast.internal.Module
import codeql.ruby.dataflow.internal.DataFlowPrivate
import codeql.ruby.dataflow.SSA

from ErbFlow::PartialPathNode source, ErbFlow::PartialPathNode sink
where ErbFlow::partialFlow(source, sink, _)
select source, sink

module ErbFlow = TaintTracking::Global<Erb>::FlowExplorationFwd<explorationLimit/0>;

module Erb implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.(DataFlow::CallNode).getMethodName() = "source" }

  predicate isSink(DataFlow::Node node) {
    node = any(DataFlow::CallNode c | c.getMethodName() = "sink").getArgument(_)
  }

  predicate isAdditionalFlowStep(DataFlow::Node node1, DataFlow::Node node2) {
    isFlowFromViewSelfToTemplate(node1, node2)
  }
}

int explorationLimit() { result = 10 }

predicate isFlowFromViewSelfToTemplate(DataFlow::Node node1, SsaSelfDefinitionNode node2) {
  exists(DataFlow::CallNode call, DataFlow::ClassNode view |
    call.getMethodName() = "render" and
    call.getArgument(0) = node1 and
    view.trackInstance().getAValueReachableFromSource() = node1 and
    exists(ErbFile template |
      view = getTemplateAssociatedViewClass(template) and node2.getLocation().getFile() = template
    ) and
    node2.getSelfScope() instanceof Toplevel and
    node2.getDefinitionExt() instanceof Ssa::SelfDefinition
  )
}

DataFlow::ClassNode getTemplateAssociatedViewClass(ErbFile template) {
  // template is in same directory as view
  exists(File viewFile | viewFile = result.getADeclaration().getFile() |
    template.getParentContainer().getAbsolutePath() =
      viewFile.getParentContainer().getAbsolutePath() and
    viewFile.getStem() = template.getStem()
  )
}
