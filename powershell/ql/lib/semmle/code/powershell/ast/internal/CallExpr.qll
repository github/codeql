private import AstImport

class CallExpr extends Expr, TCallExpr {
  /** Gets the i'th argument to this call. */
  Expr getArgument(int i) { none() }

  /** Gets the name that is used to select the callee. */
  string getLowerCaseName() { none() }

  /** Holds if `name` is the name of this call. The name is case insensitive. */
  bindingset[name]
  pragma[inline_late]
  final predicate matchesName(string name) { this.getLowerCaseName() = name.toLowerCase() }

  /** Gets a name that case-insensitively matches the name of this call. */
  bindingset[result]
  pragma[inline_late]
  final string getAName() { result.toLowerCase() = this.getLowerCaseName() }

  /** Gets the i'th positional argument to this call. */
  Expr getPositionalArgument(int i) { none() }

  /**
   * Gets the expression that represents the callee. That is, the expression
   * that computes the target of the call.
   */
  Expr getCallee() { none() }

  /**
   * Holds if an argument with name `name` is provided to this call.
   * Note: `name` is normalized to lower case.
   */
  final predicate hasNamedArgument(string name) { exists(this.getNamedArgument(name)) }

  /**
   * Gets the named argument with the given name.
   * Note: `name` is normalized to lower case.
   */
  Expr getNamedArgument(string name) { none() }

  /** Gets any argument to this call. */
  final Expr getAnArgument() { result = this.getArgument(_) }

  /** Gets the qualifier of this call, if any. */
  Expr getQualifier() { none() }

  Expr getPipelineArgument() {
    exists(Pipeline p, int i | this = p.getComponent(i + 1) and result = p.getComponent(i))
  }

  final override string toString() { result = "Call to " + this.getLowerCaseName() }

  predicate isStatic() { none() }
}

class Argument extends Expr {
  CallExpr call;

  Argument() { this = call.getAnArgument() }

  int getPosition() { this = call.getPositionalArgument(result) }

  string getLowerCaseName() { this = call.getNamedArgument(result) }

  bindingset[name]
  pragma[inline_late]
  final predicate matchesName(string name) { this.getLowerCaseName() = name.toLowerCase() }

  bindingset[result]
  pragma[inline_late]
  final string getAName() { result.toLowerCase() = this.getLowerCaseName() }

  CallExpr getCall() { result = call }
}

class Qualifier extends Expr {
  CallExpr call;

  Qualifier() { this = call.getQualifier() }

  CallExpr getCall() { result = call }
}

class PipelineArgument extends Expr {
  CallExpr call;

  PipelineArgument() { this = call.getPipelineArgument() }

  CallExpr getCall() { result = call }
}
