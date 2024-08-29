import powershell

class ParamBlock extends @param_block, Ast {
  override string toString() { result = "param(...)" }

  override SourceLocation getLocation() { param_block_location(this, result) }

  int getNumAttributes() { param_block(this, result, _) }

  int getNumParameters() { param_block(this, _, result) }

  Attribute getAttribute(int i) { param_block_attribute(this, i, result) }

  Attribute getAnAttribute() { result = this.getAttribute(_) }

  Parameter getParameter(int i) { param_block_parameter(this, i, result) }

  Parameter getAParameter() { result = this.getParameter(_) }
}
