private import AstImport

class InvokeMemberExpr extends CallExpr, TInvokeMemberExpr {
  final override string getName() { result = getRawAst(this).(Raw::InvokeMemberExpr).getName() }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = invokeMemberExprQual() and
    result = this.getQualifier()
    or
    i = invokeMemberExprCallee() and
    result = this.getCallee()
    or
    exists(int index |
      i = invokeMemberExprArg(index) and
      result = this.getArgument(index)
    )
  }

  final override Expr getCallee() {
    exists(Raw::Ast r | r = getRawAst(this) and r = getRawAst(this) |
      synthChild(r, invokeMemberExprCallee(), result)
      or
      not synthChild(r, invokeMemberExprCallee(), _) and
      result = getResultAst(r.(Raw::InvokeMemberExpr).getCallee())
    )
  }

  final override Expr getArgument(int i) {
    exists(ChildIndex index, Raw::Ast r | index = invokeMemberExprArg(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::InvokeMemberExpr).getArgument(i))
    )
  }

  final override Expr getPositionalArgument(int i) {
    // All arguments are positional in an InvokeMemberExpr
    result = this.getArgument(i)
  }

  final override Expr getNamedArgument(string name) { none() }

  final override Expr getQualifier() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, invokeMemberExprQual(), result)
      or
      not synthChild(r, invokeMemberExprQual(), _) and
      result = getResultAst(r.(Raw::InvokeMemberExpr).getQualifier())
    )
  }

  override predicate isStatic() { getRawAst(this).(Raw::InvokeMemberExpr).isStatic() }
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

  /** Gets the name of the type being constructed by this constructor call. */
  string getConstructedTypeName() { result = typename.getName() }
}

/**
 * A call to a `toString` method. For example:
 *
 * ```powershell
 * $x.ToString()
 * ```
 */
class ToStringCall extends InvokeMemberExpr {
  ToStringCall() { this.getName().toLowerCase() = "toString" }
}
