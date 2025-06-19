private import AstImport

class CmdCall extends CallExpr, TCmd {
  final override string getLowerCaseName() {
    result = getRawAst(this).(Raw::Cmd).getLowerCaseName()
  }

  final override Expr getArgument(int i) { synthChild(getRawAst(this), cmdArgument(i), result) }

  final override Expr getCallee() {
    exists(Raw::Ast r | r = getRawAst(this) |
      synthChild(r, cmdCallee(), result)
      or
      not synthChild(r, cmdCallee(), _) and
      result = getResultAst(r.(Raw::Cmd).getCallee())
    )
  }

  private predicate isNamedArgument(int i, string name) {
    any(Synthesis s).isNamedArgument(this, i, name)
  }

  private predicate isPositionalArgument(int i) {
    exists(this.getArgument(i)) and
    not this.isNamedArgument(i, _)
  }

  /** Gets the `i`th positional argument to this command. */
  final override Expr getPositionalArgument(int i) {
    result =
      rank[i + 1](Expr e, int k |
        this.isPositionalArgument(k) and e = this.getArgument(k)
      |
        e order by k
      )
  }

  /** Holds if this call has an argument named `name`. */
  predicate hasNamedArgument(string name) { exists(this.getNamedArgument(name)) }

  /** Gets the named argument with the given name. */
  final override Expr getNamedArgument(string name) {
    exists(int i |
      result = this.getArgument(i) and
      this.isNamedArgument(i, name)
    )
  }

  override Redirection getRedirection(int i) {
    // TODO: Is this weird given that there's also another redirection on Expr?
    exists(ChildIndex index, Raw::Ast r | index = cmdRedirection(i) and r = getRawAst(this) |
      synthChild(r, index, result)
      or
      not synthChild(r, index, _) and
      result = getResultAst(r.(Raw::Cmd).getRedirection(i))
    )
  }

  final override Ast getChild(ChildIndex i) {
    result = super.getChild(i)
    or
    i = cmdCallee() and
    result = this.getCallee()
    or
    exists(int index |
      i = cmdArgument(index) and
      result = this.getArgument(index)
      or
      i = cmdRedirection(index) and
      result = this.getRedirection(index)
    )
  }
}

/** A call to operator `&`. */
class CallOperator extends CmdCall {
  CallOperator() { getRawAst(this) instanceof Raw::CallOperator }

  Expr getCommand() { result = this.getArgument(0) }
}

/** A call to the dot-sourcing `.`. */
class DotSourcingOperator extends CmdCall {
  DotSourcingOperator() { getRawAst(this) instanceof Raw::DotSourcingOperator }

  Expr getPath() { result = this.getArgument(0) }
}

class JoinPath extends CmdCall {
  JoinPath() { this.getLowerCaseName() = "join-path" }

  Expr getPath() {
    result = this.getNamedArgument("path")
    or
    not this.hasNamedArgument("path") and
    result = this.getPositionalArgument(0)
  }

  Expr getChildPath() {
    result = this.getNamedArgument("childpath")
    or
    not this.hasNamedArgument("childpath") and
    result = this.getPositionalArgument(1)
  }
}

class SplitPath extends CmdCall {
  SplitPath() { this.getLowerCaseName() = "split-path" }

  Expr getPath() {
    result = this.getNamedArgument("path")
    or
    not this.hasNamedArgument("path") and
    result = this.getPositionalArgument(0)
    or
    // TODO: This should not be allowed, but I've seen code doing it and somehow it works
    result = this.getNamedArgument("parent")
  }

  predicate isParent() { this.hasNamedArgument("parent") }

  predicate isLeaf() { this.hasNamedArgument("leaf") }

  predicate isNoQualifier() { this.hasNamedArgument("noqualifier") }

  predicate isQualifier() { this.hasNamedArgument("qualifier") }

  predicate isResolve() { this.hasNamedArgument("resolve") }

  predicate isExtension() { this.hasNamedArgument("extension") }

  predicate isLeafBaseName() { this.hasNamedArgument("leafbasename") }
}

class GetVariable extends CmdCall {
  GetVariable() { this.getLowerCaseName() = "get-variable" }

  Expr getVariable() { result = this.getPositionalArgument(0) }

  predicate isGlobalScope() { this.hasNamedArgument("global") }

  predicate isLocalScope() { this.hasNamedArgument("local") }

  predicate isScriptScope() { this.hasNamedArgument("script") }

  predicate isPrivateScope() { this.hasNamedArgument("private") }

  predicate isNumbered(Expr e) { e = this.getNamedArgument("scope") }
}
