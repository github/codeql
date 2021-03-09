private import TreeSitter
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Module
private import codeql_ruby.ast.internal.Method
private import codeql_ruby.ast.internal.Statement

module Scope {
  class ScopeType = MethodLike or ModuleLike or BlockLike;

  class BlockLike = @do_block or @lambda or @block or @end_block;

  class ModuleLike = @program or @module or @class or @singleton_class;

  class MethodLike = @method or @singleton_method;

  class Range extends AstNode::Range, ScopeType {
    Range() { not exists(Generated::Lambda l | l.getBody() = this) }

    Generated::AstNode getADescendant() { this = scopeOf(result) }

    ModuleBase::Range getEnclosingModule() {
      result = this
      or
      not this instanceof ModuleBase::Range and result = this.getOuterScope().getEnclosingModule()
    }

    MethodBase::Range getEnclosingMethod() {
      result = this
      or
      not this instanceof MethodBase::Range and
      not this instanceof ModuleBase::Range and
      result = this.getOuterScope().getEnclosingMethod()
    }

    Scope::Range getOuterScope() { result = scopeOf(this) }

    override string toString() { none() }
  }
}

/** Gets the enclosing scope of a node */
private Scope::Range scopeOf(Generated::AstNode n) {
  exists(Generated::AstNode p | p = parentOf(n) |
    p instanceof Scope::Range and result = p
    or
    not p instanceof Scope::Range and result = scopeOf(p)
  )
}

private Generated::AstNode parentOf(Generated::AstNode n) {
  exists(Generated::AstNode parent | parent = n.getParent() |
    if
      n =
        [
          parent.(Generated::Module).getName(), parent.(Generated::Class).getName(),
          parent.(Generated::Class).getSuperclass(), parent.(Generated::SingletonClass).getValue(),
          parent.(Generated::Method).getName(), parent.(Generated::SingletonMethod).getName(),
          parent.(Generated::SingletonMethod).getObject()
        ]
    then result = parent.getParent()
    else result = parent
  )
}
