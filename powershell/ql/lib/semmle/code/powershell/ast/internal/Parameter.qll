private import AstImport

class Parameter extends Variable instanceof ParameterImpl {
  string getLowerCaseName() { result = super.getLowerCaseNameImpl() }

  bindingset[name]
  pragma[inline_late]
  final predicate matchesName(string name) { this.getLowerCaseName() = name.toLowerCase() }

  bindingset[result]
  pragma[inline_late]
  final string getAName() { result.toLowerCase() = this.getLowerCaseName() }

  override Ast getChild(ChildIndex childIndex) {
    result = Variable.super.getChild(childIndex)
    or
    childIndex = paramDefaultVal() and result = this.getDefaultValue()
    or
    exists(int index |
      childIndex = paramAttr(index) and
      result = this.getAttribute(index)
    )
  }

  Expr getDefaultValue() { synthChild(getRawAst(this), paramDefaultVal(), result) }

  AttributeBase getAttribute(int index) { synthChild(getRawAst(this), paramAttr(index), result) }

  AttributeBase getAnAttribute() { result = this.getAttribute(_) }

  predicate hasDefaultValue() { exists(this.getDefaultValue()) }

  FunctionBase getFunction() { result.getAParameter() = this }

  int getIndex() { this.getFunction().getParameter(result) = this }

  /** ..., if any. */
  string getStaticType() { any(Synthesis s).parameterStaticType(this, result) }
}

class ThisParameter extends Parameter instanceof ThisParameterImpl { }

/** The pipeline parameter of a function. */
class PipelineParameter extends Parameter instanceof PipelineParameterImpl {
  ScriptBlock getScriptBlock() { result = super.getScriptBlock() }
}

/**
 * The iterator variable associated with a pipeline parameter.
 * 
 * This is the variable that is bound to the current element in the pipeline.
 */
class PipelineIteratorVariable extends Variable instanceof PipelineIteratorVariableImpl {
  ProcessBlock getProcessBlock() { result = super.getProcessBlock() }
}

/**
 * A pipeline-by-property-name parameter of a function.
 */
class PipelineByPropertyNameParameter extends Parameter instanceof PipelineByPropertyNameParameterImpl
{
  ScriptBlock getScriptBlock() { result = super.getScriptBlock() }

  string getPropertyName() { result = super.getName() }

  /**
   * Gets the iterator variable that is used to iterate over the elements in the pipeline.
   */
  PipelineByPropertyNameIteratorVariable getIteratorVariable() { result.getParameter() = this }
}

/**
 * The iterator variable associated with a pipeline-by-property-name parameter.
 * 
 * This is the variable that is bound to the current element in the pipeline.
 */
class PipelineByPropertyNameIteratorVariable extends Variable instanceof PipelineByPropertyNameIteratorVariableImpl
{
  ProcessBlock getProcessBlock() { result = super.getProcessBlock() }

  string getPropertyName() { result = super.getPropertyName() }

  /**
   * Gets the pipeline-by-property-name parameter that this variable
   * iterates over.
   */
  PipelineByPropertyNameParameter getParameter() { result = super.getParameter() }
}