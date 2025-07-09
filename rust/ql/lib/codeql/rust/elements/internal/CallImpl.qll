private import rust
private import codeql.rust.internal.PathResolution
private import codeql.rust.internal.TypeInference as TypeInference
private import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl
private import codeql.rust.elements.Operation

module Impl {
  newtype TArgumentPosition =
    TPositionalArgumentPosition(int i) {
      i in [0 .. max([any(ParamList l).getNumberOfParams(), any(ArgList l).getNumberOfArgs()]) - 1]
    } or
    TSelfArgumentPosition()

  /** An argument position in a call. */
  class ArgumentPosition extends TArgumentPosition {
    /** Gets the index of the argument in the call, if this is a positional argument. */
    int asPosition() { this = TPositionalArgumentPosition(result) }

    /** Holds if this call position is a self argument. */
    predicate isSelf() { this instanceof TSelfArgumentPosition }

    /** Gets a string representation of this argument position. */
    string toString() {
      result = this.asPosition().toString()
      or
      this.isSelf() and result = "self"
    }
  }

  /**
   * An expression that calls a function.
   *
   * This class abstracts over the different ways in which a function can be
   * called in Rust.
   */
  abstract class Call extends ExprImpl::Expr {
    /** Holds if the receiver of this call is implicitly borrowed. */
    predicate receiverImplicitlyBorrowed() { this.implicitBorrowAt(TSelfArgumentPosition(), _) }

    /** Gets the trait targeted by this call, if any. */
    abstract Trait getTrait();

    /** Gets the name of the method called if this call is a method call. */
    abstract string getMethodName();

    /** Gets the argument at the given position, if any. */
    abstract Expr getArgument(ArgumentPosition pos);

    /** Holds if the argument at `pos` might be implicitly borrowed. */
    abstract predicate implicitBorrowAt(ArgumentPosition pos, boolean certain);

    /** Gets the number of arguments _excluding_ any `self` argument. */
    int getNumberOfArguments() { result = count(this.getArgument(TPositionalArgumentPosition(_))) }

    /** Gets the `i`th argument of this call, if any. */
    Expr getPositionalArgument(int i) { result = this.getArgument(TPositionalArgumentPosition(i)) }

    /** Gets the receiver of this call if it is a method call. */
    Expr getReceiver() { result = this.getArgument(TSelfArgumentPosition()) }

    /** Gets the static target of this call, if any. */
    Function getStaticTarget() {
      result = TypeInference::resolveMethodCallTarget(this)
      or
      not exists(TypeInference::resolveMethodCallTarget(this)) and
      result = this.(CallExpr).getStaticTarget()
    }

    /** Gets a runtime target of this call, if any. */
    pragma[nomagic]
    Function getARuntimeTarget() {
      result.hasImplementation() and
      (
        result = this.getStaticTarget()
        or
        result.implements(this.getStaticTarget())
      )
    }
  }

  /** Holds if the call expression dispatches to a method. */
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

    override Trait getTrait() { none() }

    override predicate implicitBorrowAt(ArgumentPosition pos, boolean certain) { none() }

    override Expr getArgument(ArgumentPosition pos) {
      result = super.getArgList().getArg(pos.asPosition())
    }
  }

  private class CallExprMethodCall extends Call instanceof CallExpr {
    Path qualifier;
    string methodName;

    CallExprMethodCall() { callIsMethodCall(this, qualifier, methodName) }

    override string getMethodName() { result = methodName }

    override Trait getTrait() {
      result = resolvePath(qualifier) and
      // When the qualifier is `Self` and resolves to a trait, it's inside a
      // trait method's default implementation. This is not a dispatch whose
      // target is inferred from the type of the receiver, but should always
      // resolve to the function in the trait block as path resolution does.
      qualifier.toString() != "Self"
    }

    override predicate implicitBorrowAt(ArgumentPosition pos, boolean certain) { none() }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and result = super.getArgList().getArg(0)
      or
      result = super.getArgList().getArg(pos.asPosition() + 1)
    }
  }

  private class MethodCallExprCall extends Call instanceof MethodCallExpr {
    override string getMethodName() { result = super.getIdentifier().getText() }

    override Trait getTrait() { none() }

    override predicate implicitBorrowAt(ArgumentPosition pos, boolean certain) {
      pos.isSelf() and certain = false
    }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and result = this.(MethodCallExpr).getReceiver()
      or
      result = super.getArgList().getArg(pos.asPosition())
    }
  }

  private class OperatorCall extends Call instanceof Operation {
    Trait trait;
    string methodName;
    int borrows;

    OperatorCall() { super.isOverloaded(trait, methodName, borrows) }

    override string getMethodName() { result = methodName }

    override Trait getTrait() { result = trait }

    override predicate implicitBorrowAt(ArgumentPosition pos, boolean certain) {
      (
        pos.isSelf() and borrows >= 1
        or
        pos.asPosition() = 0 and borrows = 2
      ) and
      certain = true
    }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and result = super.getOperand(0)
      or
      pos.asPosition() = 0 and result = super.getOperand(1)
    }
  }

  private class IndexCall extends Call instanceof IndexExpr {
    override string getMethodName() { result = "index" }

    override Trait getTrait() { result.getCanonicalPath() = "core::ops::index::Index" }

    override predicate implicitBorrowAt(ArgumentPosition pos, boolean certain) {
      pos.isSelf() and certain = true
    }

    override Expr getArgument(ArgumentPosition pos) {
      pos.isSelf() and result = super.getBase()
      or
      pos.asPosition() = 0 and result = super.getIndex()
    }
  }
}
