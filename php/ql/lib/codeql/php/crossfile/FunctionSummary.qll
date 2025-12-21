/**
 * @name Function Summary for Cross-File Analysis
 * @description Models function return types and parameter data flow
 * @kind concept
 */

private import codeql.php.ast.internal.TreeSitter as TS

/**
 * A function definition with parameter and return tracking.
 */
class AnalyzedFunction extends TS::PHP::FunctionDefinition {
  /** Gets the function name */
  string getFunctionName() {
    result = this.getName().getValue()
  }

  /** Gets the number of parameters */
  int getNumParams() {
    result = count(TS::PHP::SimpleParameter p | p = this.getParameters().(TS::PHP::FormalParameters).getChild(_))
  }

  /** Gets a parameter by index */
  TS::PHP::SimpleParameter getParam(int i) {
    result = this.getParameters().(TS::PHP::FormalParameters).getChild(i)
  }

  /** Gets the function body */
  TS::PHP::CompoundStatement getFunctionBody() {
    result = this.getBody()
  }

  /** Gets return statements in this function */
  TS::PHP::ReturnStatement getAReturnStatement() {
    result.getParent+() = this
  }
}

/**
 * A method definition with parameter and return tracking.
 */
class AnalyzedMethod extends TS::PHP::MethodDeclaration {
  /** Gets the method name */
  string getMethodName() {
    result = this.getName().getValue()
  }

  /** Gets the number of parameters */
  int getNumParams() {
    result = count(TS::PHP::SimpleParameter p | p = this.getParameters().(TS::PHP::FormalParameters).getChild(_))
  }

  /** Gets a parameter by index */
  TS::PHP::SimpleParameter getParam(int i) {
    result = this.getParameters().(TS::PHP::FormalParameters).getChild(i)
  }

  /** Gets return statements in this method */
  TS::PHP::ReturnStatement getAReturnStatement() {
    result.getParent+() = this
  }
}

/**
 * A function call with tracking.
 */
class TrackedFunctionCall extends TS::PHP::FunctionCallExpression {
  /** Gets the called function name */
  string getCalledName() {
    result = this.getFunction().(TS::PHP::Name).getValue() or
    result = this.getFunction().(TS::PHP::QualifiedName).toString()
  }

  /** Gets an argument */
  TS::PHP::AstNode getArg(int i) {
    result = this.getArguments().(TS::PHP::Arguments).getChild(i)
  }

  /** Gets the number of arguments */
  int getNumArgs() {
    result = count(int i | exists(this.getArg(i)))
  }
}

/**
 * A method call with tracking.
 */
class TrackedMethodCall extends TS::PHP::MemberCallExpression {
  /** Gets the called method name */
  string getCalledName() {
    result = this.getName().(TS::PHP::Name).getValue()
  }

  /** Gets an argument */
  TS::PHP::AstNode getArg(int i) {
    result = this.getArguments().(TS::PHP::Arguments).getChild(i)
  }

  /** Gets the number of arguments */
  int getNumArgs() {
    result = count(int i | exists(this.getArg(i)))
  }
}

/**
 * Summary of a function's data flow characteristics.
 */
class FunctionDataFlowSummary extends AnalyzedFunction {
  /** Checks if function has a return statement */
  predicate hasReturn() {
    exists(this.getAReturnStatement())
  }

  /** Gets the number of return statements */
  int getNumReturns() {
    result = count(this.getAReturnStatement())
  }
}
