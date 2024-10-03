import powershell
import semmle.code.powershell.controlflow.BasicBlocks

abstract private class AbstractFunction extends Ast {
  /** Gets the name of this function. */
  abstract string getName();

  /** Holds if this function has name `name`. */
  final predicate hasName(string name) { this.getName() = name }

  /** Gets the body of this function. */
  abstract ScriptBlock getBody();

  /**
   * Gets the i'th function parameter, if any.
   *
   * Note that this predicate only returns _function_ parameters.
   * To also get _block_ parameters use the `getParameter` predicate.
   */
  abstract Parameter getFunctionParameter(int i);

  /** Gets the declaring type of this function, if any. */
  abstract Type getDeclaringType();

  /**
   * Gets any function parameter of this function.
   *
   * Note that this only gets _function_ paramters. To get any parameter
   * use the `getAParameter` predicate.
   */
  final Parameter getAFunctionParameter() { result = this.getFunctionParameter(_) }

  /** Gets the number of function parameters. */
  final int getNumberOfFunctionParameters() { result = count(this.getAFunctionParameter()) }

  /** Gets the number of parameters (both function and block). */
  final int getNumberOfParameters() { result = count(this.getAParameter()) }

  /** Gets the i'th parameter of this function, if any. */
  final Parameter getParameter(int i) {
    result = this.getFunctionParameter(i)
    or
    result = this.getBody().getParamBlock().getParameter(i)
  }

  /** Gets any parameter of this function. */
  final Parameter getAParameter() { result = this.getParameter(_) }

  /** Gets the entry point of this function in the control-flow graph. */
  EntryBasicBlock getEntryBasicBlock() { result.getScope() = this.getBody() }
}

/**
 * A function definition.
 */
private class FunctionBase extends @function_definition, Stmt, AbstractFunction {
  override string toString() { result = this.getName() }

  override SourceLocation getLocation() { function_definition_location(this, result) }

  override string getName() { function_definition(this, _, result, _, _) }

  override ScriptBlock getBody() { function_definition(this, result, _, _, _) }

  predicate isFilter() { function_definition(this, _, _, true, _) }

  predicate isWorkflow() { function_definition(this, _, _, _, true) }

  override Parameter getFunctionParameter(int i) { result.isFunctionParameter(this, i) }

  override Type getDeclaringType() { none() }
}

private predicate isMethod(Member m, ScriptBlock body) {
  function_member(m, body, _, _, _, _, _, _, _)
}

/**
 * A method definition. That is, a function defined inside a class definition.
 */
class Method extends FunctionBase {
  Method() { isMethod(_, super.getBody()) }

  /** Gets the member corresponding to this function definition. */
  Member getMember() { isMethod(result, super.getBody()) }

  /** Holds if this method is a constructor. */
  predicate isConstructor() { function_member(this.getMember(), _, true, _, _, _, _, _, _) }

  final override Type getDeclaringType() { result = this.getMember().getDeclaringType() }
}

/** A constructor definition. */
class Constructor extends Method {
  Constructor() { this.isConstructor() }
}

final class Function = FunctionBase;
