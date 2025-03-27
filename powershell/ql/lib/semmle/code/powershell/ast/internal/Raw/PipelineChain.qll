private import Raw

class PipelineChain extends @pipeline_chain, Chainable {
  final override SourceLocation getLocation() { pipeline_chain_location(this, result) }

  predicate isBackground() { pipeline_chain(this, true, _, _, _) }

  Chainable getLeft() { pipeline_chain(this, _, _, result, _) }

  Pipeline getRight() { pipeline_chain(this, _, _, _, result) }

  final override Ast getChild(ChildIndex i) {
    i = PipelineChainLeft() and result = this.getLeft()
    or
    i = PipelineChainRight() and result = this.getRight()
  }
}
