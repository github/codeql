private import AstImport

class NamedBlock extends Ast, TNamedBlock {
  override string toString() { result = "{...}" }

  Stmt getStmt(int i) {
    exists(ChildIndex index, Raw::Ast r | index = namedBlockStmt(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::NamedBlock).getStmt(i))
    )
  }

  TrapStmt getTrapStmt(int i) {
    exists(ChildIndex index, Raw::Ast r | index = namedBlockTrap(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::NamedBlock).getTrap(i))
    )
  }

  Stmt getAStmt() { result = this.getStmt(_) }

  TrapStmt getATrapStmt() { result = this.getTrapStmt(_) }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    exists(int index |
      i = namedBlockStmt(index) and
      result = this.getStmt(index)
      or
      i = namedBlockTrap(index) and
      result = this.getTrapStmt(index)
    )
  }
}

/** A `process` block. */
class ProcessBlock extends NamedBlock {
  ScriptBlock scriptBlock;

  ProcessBlock() { scriptBlock.getProcessBlock() = this }

  ScriptBlock getScriptBlock() { result = scriptBlock }

  PipelineParameter getPipelineParameter() {
    result = this.getEnclosingFunction().getPipelineParameter()
  }

  PipelineByPropertyNameParameter getAPipelineByPropertyNameParameter() {
    result = scriptBlock.getEnclosingFunction().getAParameter()
  }
}
