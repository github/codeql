private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.TypeInference as TypeInference
private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl
private import codeql.rust.elements.Operation

module Impl {
  /**
   * An expression that calls a function.
   *
   * This class abstract over the different ways in which a function can be called in Rust.
   */
  abstract class Call extends ExprImpl::Expr {
    Call() { this.fromSource() }

    /** Gets the number of arguments _excluding_ any `self` argument. */
    abstract int getNumberOfArguments();

    /** Gets the receiver of this call if it is a method call. */
    abstract Expr getReceiver();

    /** Holds if the call has a receiver that might be implicitly borrowed. */
    abstract predicate receiverImplicitlyBorrowed();

    /** Gets the trait targeted by this call, if any. */
    abstract Trait getTrait();

    /** Gets the name of the method called if this call is a method call. */
    abstract string getMethodName();

    /** Gets the `i`th argument of this call, if any. */
    abstract Expr getArgument(int i);

    /** Gets the static target of this call, if any. */
    Function getStaticTarget() {
      result = TypeInference::resolveMethodCallTarget(this)
      or
      not exists(TypeInference::resolveMethodCallTarget(this)) and
      result = this.(CallExpr).getStaticTarget()
    }
  }

  /** Holds if the call expression dispatches to a trait method. */
  private predicate callIsMethodCall(CallExpr call, Path qualifier, string methodName) {
    exists(Path path, Function f |
      path = call.getFunction().(PathExpr).getPath() and
      f = resolvePath(path) and
      f.getParamList().hasSelfParam() and
      qualifier = path.getQualifier() and
      path.getSegment().getIdentifier().getText() = methodName
    )
  }

  private class CallExprCall extends Call instanceof CallExpr {
    CallExprCall() { not callIsMethodCall(this, _, _) }

    override string getMethodName() { none() }

    override Expr getReceiver() { none() }

    override Trait getTrait() { none() }

    override predicate receiverImplicitlyBorrowed() { none() }

    override int getNumberOfArguments() { result = super.getArgList().getNumberOfArgs() }

    override Expr getArgument(int i) { result = super.getArgList().getArg(i) }
  }

  private class CallExprMethodCall extends Call instanceof CallExpr {
    Path qualifier;
    string methodName;

    CallExprMethodCall() { callIsMethodCall(this, qualifier, methodName) }

    override string getMethodName() { result = methodName }

    override Expr getReceiver() { result = super.getArgList().getArg(0) }

    override Trait getTrait() {
      result = resolvePath(qualifier) and
      // When the qualifier is `Self` and resolves to a trait, it's inside a
      // trait method's default implementation. This is not a dispatch whose
      // target is inferred from the type of the receiver, but should always
      // resolve to the function in the trait block as path resolution does.
      qualifier.toString() != "Self"
    }

    override predicate receiverImplicitlyBorrowed() { none() }

    override int getNumberOfArguments() { result = super.getArgList().getNumberOfArgs() - 1 }

    override Expr getArgument(int i) { result = super.getArgList().getArg(i + 1) }
  }

  private class MethodCallExprCall extends Call instanceof MethodCallExpr {
    override string getMethodName() { result = super.getIdentifier().getText() }

    override Expr getReceiver() { result = this.(MethodCallExpr).getReceiver() }

    override Trait getTrait() { none() }

    override predicate receiverImplicitlyBorrowed() { any() }

    override int getNumberOfArguments() { result = super.getArgList().getNumberOfArgs() }

    override Expr getArgument(int i) { result = super.getArgList().getArg(i) }
  }

  private class OperatorCall extends Call instanceof Operation {
    Trait trait;
    string methodName;

    OperatorCall() { super.isOverloaded(trait, methodName) }

    override string getMethodName() { result = methodName }

    override Expr getReceiver() { result = super.getOperand(0) }

    override Trait getTrait() { result = trait }

    override predicate receiverImplicitlyBorrowed() { none() }

    override int getNumberOfArguments() { result = super.getNumberOfOperands() - 1 }

    override Expr getArgument(int i) { result = super.getOperand(1) and i = 0 }
  }
}
