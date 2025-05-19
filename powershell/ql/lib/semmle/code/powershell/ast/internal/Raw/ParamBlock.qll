private import Raw

class ParamBlock extends @param_block, Ast {
  override SourceLocation getLocation() { param_block_location(this, result) }

  int getNumAttributes() { param_block(this, result, _) }

  int getNumParameters() { param_block(this, _, result) }

  Attribute getAttribute(int i) { param_block_attribute(this, i, result) }

  Attribute getAnAttribute() { result = this.getAttribute(_) }

  Parameter getParameter(int i) { param_block_parameter(this, i, result) }

  Parameter getAParameter() { result = this.getParameter(_) }

  PipelineParameter getPipelineParameter() { result = this.getAParameter() }

  PipelineByPropertyNameParameter getAPipelineByPropertyNameParameter() {
    result = this.getAParameter()
  }

  final override Ast getChild(ChildIndex i) {
    exists(int index |
      i = ParamBlockAttr(index) and
      result = this.getAttribute(index)
      or
      i = ParamBlockParam(index) and
      result = this.getParameter(index)
    )
  }

  /** Gets the script block, if any. */
  ScriptBlock getScriptBlock() { result.getParamBlock() = this }
}
