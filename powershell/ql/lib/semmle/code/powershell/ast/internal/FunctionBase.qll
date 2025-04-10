private import AstImport
private import semmle.code.powershell.controlflow.BasicBlocks

class FunctionBase extends Ast, TFunctionBase {
  final override string toString() { result = this.getName() }

  string getName() { none() }

  final predicate hasName(string name) { name = this.getName() }

  ScriptBlock getBody() { none() }

  Parameter getParameter(int i) { none() }

  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Note: This always has a result */
  final PipelineParameter getPipelineParameter() { result = this.getAParameter() }

  final EntryBasicBlock getEntryBasicBlock() { result.getScope() = this.getBody() }

  final int getNumberOfParameters() { result = count(this.getAParameter()) }
}

/**
 * The implicit function that represents the entire script block in a file.
 */
class TopLevelFunction extends FunctionBase, TTopLevelFunction { }
