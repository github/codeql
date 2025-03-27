private import AstImport

class ScriptBlock extends Ast, TScriptBlock {
  override string toString() {
    if this.isTopLevel()
    then result = this.getLocation().getFile().getBaseName()
    else result = "{...}"
  }

  NamedBlock getProcessBlock() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, scriptBlockProcessBlock(), result)
      or
      not synthChild(r, scriptBlockProcessBlock(), _) and
      result = getResultAst(r.(Raw::ScriptBlock).getProcessBlock())
    )
  }

  NamedBlock getBeginBlock() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, scriptBlockBeginBlock(), result)
      or
      not synthChild(r, scriptBlockBeginBlock(), _) and
      result = getResultAst(r.(Raw::ScriptBlock).getBeginBlock())
    )
  }

  UsingStmt getUsingStmt(int i) {
    exists(ChildIndex index, Raw::Ast r | index = scriptBlockUsing(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::ScriptBlock).getUsing(i))
    )
  }

  UsingStmt getAUsingStmt() { result = this.getUsingStmt(_) }

  NamedBlock getEndBlock() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, scriptBlockEndBlock(), result)
      or
      not synthChild(r, scriptBlockEndBlock(), _) and
      result = getResultAst(r.(Raw::ScriptBlock).getEndBlock())
    )
  }

  NamedBlock getDynamicBlock() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, scriptBlockDynParamBlock(), result)
      or
      not synthChild(r, scriptBlockDynParamBlock(), _) and
      result = getResultAst(r.(Raw::ScriptBlock).getDynamicParamBlock())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = scriptBlockBeginBlock() and
    result = this.getBeginBlock()
    or
    i = scriptBlockProcessBlock() and
    result = this.getProcessBlock()
    or
    i = scriptBlockEndBlock() and
    result = this.getEndBlock()
    or
    i = scriptBlockDynParamBlock() and
    result = this.getDynamicBlock()
    or
    exists(int index |
      i = scriptBlockAttr(index) and
      result = this.getAttribute(index)
    )
    or
    exists(int index |
      i = funParam(index) and
      result = this.getParameter(index)
    )
    or
    i = ThisVar() and
    result = this.getThisParameter()
    or
    exists(int index |
      i = scriptBlockUsing(index) and
      result = this.getUsingStmt(index)
    )
  }

  Parameter getParameter(int i) {
    synthChild(getRawAst(this), funParam(i), result)
    or
    any(Synthesis s).pipelineParameterHasIndex(this, i) and
    synthChild(getRawAst(this), PipelineParamVar(), result)
  }

  Parameter getThisParameter() { synthChild(getRawAst(this), ThisVar(), result) }

  /**
   * Gets a parameter of this block.
   *
   * Note: This does not include the `this` parameter, but it does include pipeline parameters.
   */
  Parameter getAParameter() { result = this.getParameter(_) }

  int getNumberOfParameters() { result = count(this.getAParameter()) }

  predicate isTopLevel() { not exists(this.getParent()) }

  Attribute getAttribute(int i) {
    // We attach the attributes to the function since we got rid of parameter blocks
    exists(ChildIndex index, Raw::Ast r | index = scriptBlockAttr(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::ScriptBlock).getParamBlock().getAttribute(i))
    )
  }

  Attribute getAnAttribute() { result = this.getAttribute(_) }
}

class TopLevelScriptBlock extends ScriptBlock {
  TopLevelScriptBlock() { this.isTopLevel() }
}
