/**
 * Provides modeling for the `Module` class.
 */

private import codeql.ruby.AST
private import codeql.ruby.Concepts
private import codeql.ruby.DataFlow

/**
 * Provides modeling for the `Module` class.
 */
module Module {
  /**
   * A call to `Module#module_eval`, which executes its first argument as Ruby code.
   */
  class ModuleEvalCallCodeExecution extends CodeExecution::Range, DataFlow::CallNode {
    ModuleEvalCallCodeExecution() {
      this.asExpr().getExpr().(UnknownMethodCall).getMethodName() = "module_eval"
    }

    override DataFlow::Node getCode() { result = this.getArgument(0) }
  }

  /**
   * A call to `Module#class_eval`, which executes its first argument as Ruby code.
   */
  class ClassEvalCallCodeExecution extends CodeExecution::Range, DataFlow::CallNode {
    ClassEvalCallCodeExecution() {
      this.asExpr().getExpr().(UnknownMethodCall).getMethodName() = "class_eval"
    }

    override DataFlow::Node getCode() { result = this.getArgument(0) }
  }

  /**
   * A call to `Module#const_get`, which interprets its argument as a Ruby constant.
   * Passing user input to this method may result in instantiation of arbitrary Ruby classes.
   */
  class ModuleConstGetCallCodeExecution extends CodeExecution::Range, DataFlow::CallNode {
    ModuleConstGetCallCodeExecution() {
      this.asExpr().getExpr().(UnknownMethodCall).getMethodName() = "const_get"
    }

    override DataFlow::Node getCode() { result = this.getArgument(0) }
  }
}
