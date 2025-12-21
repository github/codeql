import codeql.php.ast.internal.TreeSitter

/** A PHP call expression (function call, method call, static call). */
class Call extends Php::AstNode {
  Call() {
    this instanceof Php::FunctionCallExpression or
    this instanceof Php::MemberCallExpression or
    this instanceof Php::NullsafeMemberCallExpression or
    this instanceof Php::ScopedCallExpression
  }

  /** Gets the syntactic callee node. */
  Php::AstNode getCallee() {
    result = this.(Php::FunctionCallExpression).getFunction() or
    result = this.(Php::MemberCallExpression).getName() or
    result = this.(Php::NullsafeMemberCallExpression).getName() or
    result = this.(Php::ScopedCallExpression).getName()
  }

  /** Gets the argument list node. */
  Php::Arguments getArguments() {
    result = this.(Php::FunctionCallExpression).getArguments() or
    result = this.(Php::MemberCallExpression).getArguments() or
    result = this.(Php::NullsafeMemberCallExpression).getArguments() or
    result = this.(Php::ScopedCallExpression).getArguments()
  }

  /**
   * Gets the statically-known name of the callee, where available.
   *
   * This intentionally returns the unqualified final name segment.
   */
  string getCalleeName() {
    exists(Php::AstNode callee | callee = this.getCallee() |
      callee instanceof Php::Name and result = callee.(Php::Name).getValue() or
      callee instanceof Php::QualifiedName and
      result = callee.(Php::QualifiedName).getChild().getValue()
    )
  }

  /** Gets an argument node of this call. */
  Php::Argument getAnArgument() {
    result = this.getArguments().getAFieldOrChild().(Php::Argument)
  }

  /** Gets the `i`th argument of this call (0-based), skipping placeholders. */
  Php::Argument getArgument(int i) {
    exists(Php::Argument arg |
      arg = this.getAnArgument() and
      i = count(Php::Argument prev |
        prev = this.getAnArgument() and prev.getParentIndex() < arg.getParentIndex()
      ) and
      result = arg
    )
  }

  /** Gets an argument expression of this call. */
  Php::Expression getAnArgumentExpr() {
    result = this.getAnArgument().getChild().(Php::Expression)
  }

  /** Gets the expression of the `i`th argument of this call (0-based). */
  Php::Expression getArgumentExpr(int i) {
    result = this.getArgument(i).getChild().(Php::Expression)
  }
}

/** A plain function call, e.g. `f(...)` or `\f(...)`. */
class FunctionCall extends Call {
  FunctionCall() { this instanceof Php::FunctionCallExpression }
}

/** An instance method call, e.g. `$o->m(...)` or `$o?->m(...)`. */
class MemberCall extends Call {
  MemberCall() {
    this instanceof Php::MemberCallExpression or
    this instanceof Php::NullsafeMemberCallExpression
  }
}

/** A scoped (static) call, e.g. `C::m(...)`. */
class ScopedCall extends Call {
  ScopedCall() { this instanceof Php::ScopedCallExpression }
}
