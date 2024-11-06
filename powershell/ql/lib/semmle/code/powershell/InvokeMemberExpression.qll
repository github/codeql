import powershell

class InvokeMemberExpr extends @invoke_member_expression, MemberExprBase {
  override SourceLocation getLocation() { invoke_member_expression_location(this, result) }

  Expr getQualifier() { invoke_member_expression(this, result, _) }

  string getName() { result = this.getMember().(StringConstExpr).getValue().getValue() }

  CmdElement getMember() { invoke_member_expression(this, _, result) }

  string getMemberName() { result = this.getMember().(StringConstExpr).getValue().getValue() }

  Expr getArgument(int i) { invoke_member_expression_argument(this, i, result) }

  Expr getAnArgument() { invoke_member_expression_argument(this, _, result) }

  override string toString() { result = "call to " + this.getName() }

  override predicate isStatic() { this.getQualifier() instanceof TypeNameExpr }
}

/**
 * A call to a constructor. For example:
 *
 * ```powershell
 * [System.IO.FileInfo]::new("C:\\file.txt")
 * ```
 */
class ConstructorCall extends InvokeMemberExpr {
  TypeNameExpr typename;

  ConstructorCall() {
    this.isStatic() and typename = this.getQualifier() and this.getName() = "new"
  }

  /**
   * Gets the type being constructed by this constructor call.
   *
   * Note that the type may not exist in the database.
   *
   * Use `getConstructedTypeName` to get the name of the type (which will
   * always exist in the database).
   */
  Type getConstructedType() { result = typename.getType() }

  /** Gets the name of the type being constructed by this constructor call. */
  string getConstructedTypeName() { result = typename.getName() }
}
