private import AstImport

class MemberExpr extends Expr, TMemberExpr {
  Expr getQualifier() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, memberExprQual(), result)
      or
      not synthChild(r, memberExprQual(), _) and
      result = getResultAst(r.(Raw::MemberExpr).getQualifier())
    )
  }

  Expr getMemberExpr() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, memberExprMember(), result)
      or
      not synthChild(r, memberExprMember(), _) and
      result = getResultAst(r.(Raw::MemberExpr).getMember())
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = memberExprQual() and result = this.getQualifier()
    or
    i = memberExprMember() and result = this.getMemberExpr()
  }

  /** Gets the name of the member being looked up, if any. */
  string getLowerCaseMemberName() {
    result =
      getRawAst(this)
          .(Raw::MemberExpr)
          .getMember()
          .(Raw::StringConstExpr)
          .getValue()
          .getValue()
          .toLowerCase()
  }

  bindingset[name]
  pragma[inline_late]
  predicate memberNameMatches(string name) { this.getLowerCaseMemberName() = name.toLowerCase() }

  predicate isNullConditional() { getRawAst(this).(Raw::MemberExpr).isNullConditional() }

  predicate isStatic() { getRawAst(this).(Raw::MemberExpr).isStatic() }

  final override string toString() {
    result = this.getLowerCaseMemberName()
    or
    not exists(this.getLowerCaseMemberName()) and
    result = "..."
  }

  predicate isExplicitWrite(Ast assignment) {
    explicitAssignment(getRawAst(this), getRawAst(assignment))
  }

  predicate isImplicitWrite() { implicitAssignment(getRawAst(this)) }
}

/** A `MemberExpr` that is being written to. */
class MemberExprWriteAccess extends MemberExpr {
  MemberExprWriteAccess() { this.isExplicitWrite(_) or this.isImplicitWrite() }
}

/** A `MemberExpr` that is being read from. */
class MemberExprReadAccess extends MemberExpr {
  MemberExprReadAccess() { not this instanceof MemberExprWriteAccess }
}
