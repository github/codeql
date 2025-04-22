private import AstImport

class PipelineChain extends Expr, TPipelineChain {
  predicate isBackground() { getRawAst(this).(Raw::PipelineChain).isBackground() }

  Expr getLeft() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, pipelineChainLeft(), result)
      or
      not synthChild(r, pipelineChainLeft(), _) and
      result = getResultAst(r.(Raw::PipelineChain).getLeft())
    )
  }

  Pipeline getRight() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, pipelineChainRight(), result)
      or
      not synthChild(r, pipelineChainRight(), _) and
      result = getResultAst(r.(Raw::PipelineChain).getRight())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = pipelineChainLeft() and result = this.getLeft()
    or
    i = pipelineChainRight() and result = this.getRight()
  }
}
