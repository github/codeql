private import TreeSitter
private import codeql_ruby.ast.Scope
private import codeql_ruby.ast.internal.AST
private import codeql_ruby.ast.internal.Parameter

class TScopeType = TMethodBase or TModuleLike or TBlockLike;

private class TBlockLike = TDoBlock or TLambda or TBlock or TEndBlock;

private class TModuleLike = TToplevel or TModuleDeclaration or TClassDeclaration or TSingletonClass;

module Scope {
  class TypeRange = Callable::TypeRange or ModuleBase::TypeRange or @end_block;

  class Range extends Generated::AstNode, TypeRange {
    Range() { not this = any(Generated::Lambda l).getBody() }

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

    Range getOuterScope() { result = scopeOf(this) }
  }
}

module MethodBase {
  class TypeRange = @method or @singleton_method;

  class Range extends Scope::Range, TypeRange { }
}

module Callable {
  class TypeRange = MethodBase::TypeRange or @do_block or @lambda or @block;

  class Range extends Scope::Range, TypeRange {
    Parameter::Range getParameter(int i) {
      result = this.(Generated::Method).getParameters().getChild(i) or
      result = this.(Generated::SingletonMethod).getParameters().getChild(i) or
      result = this.(Generated::DoBlock).getParameters().getChild(i) or
      result = this.(Generated::Lambda).getParameters().getChild(i) or
      result = this.(Generated::Block).getParameters().getChild(i)
    }
  }
}

module ModuleBase {
  class TypeRange = @program or @module or @class or @singleton_class;

  class Range extends Scope::Range, TypeRange { }
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

/** Gets the enclosing scope of a node */
cached
Scope::Range scopeOf(Generated::AstNode n) {
  exists(Generated::AstNode p | p = parentOf(n) |
    p = result
    or
    not p instanceof Scope::Range and result = scopeOf(p)
  )
}
