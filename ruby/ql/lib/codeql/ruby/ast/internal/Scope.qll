private import TreeSitter
private import codeql.ruby.ast.Scope
private import codeql.ruby.ast.internal.AST
private import codeql.ruby.ast.internal.Parameter

class TScopeType = TMethodBase or TModuleLike or TBlockLike;

private class TBlockLike = TDoBlock or TLambda or TBlock or TEndBlock;

private class TModuleLike = TToplevel or TModuleDeclaration or TClassDeclaration or TSingletonClass;

module Scope {
  class TypeRange = Callable::TypeRange or ModuleBase::TypeRange or @ruby_end_block;

  class Range extends Ruby::AstNode, TypeRange {
    Range() { not this = any(Ruby::Lambda l).getBody() }

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
  class TypeRange = @ruby_method or @ruby_singleton_method;

  class Range extends Scope::Range, TypeRange { }
}

module Callable {
  class TypeRange = MethodBase::TypeRange or @ruby_do_block or @ruby_lambda or @ruby_block;

  class Range extends Scope::Range, TypeRange {
    Parameter::Range getParameter(int i) {
      result = this.(Ruby::Method).getParameters().getChild(i) or
      result = this.(Ruby::SingletonMethod).getParameters().getChild(i) or
      result = this.(Ruby::DoBlock).getParameters().getChild(i) or
      result = this.(Ruby::Lambda).getParameters().getChild(i) or
      result = this.(Ruby::Block).getParameters().getChild(i)
    }
  }
}

module ModuleBase {
  class TypeRange = @ruby_program or @ruby_module or @ruby_class or @ruby_singleton_class;

  class Range extends Scope::Range, TypeRange { }
}

pragma[noinline]
private predicate rankHeredocBody(File f, Ruby::HeredocBody b, int i) {
  b =
    rank[i](Ruby::HeredocBody b0 |
      f = b0.getLocation().getFile()
    |
      b0 order by b0.getLocation().getStartLine(), b0.getLocation().getStartColumn()
    )
}

Ruby::HeredocBody getHereDocBody(Ruby::HeredocBeginning g) {
  exists(int i, File f |
    g =
      rank[i](Ruby::HeredocBeginning b |
        f = b.getLocation().getFile()
      |
        b order by b.getLocation().getStartLine(), b.getLocation().getStartColumn()
      ) and
    rankHeredocBody(f, result, i)
  )
}

private Ruby::AstNode parentOf(Ruby::AstNode n) {
  n = getHereDocBody(result)
  or
  exists(Ruby::AstNode parent | parent = n.getParent() |
    if
      n =
        [
          parent.(Ruby::Module).getName(), parent.(Ruby::Class).getName(),
          parent.(Ruby::Class).getSuperclass(), parent.(Ruby::SingletonClass).getValue(),
          parent.(Ruby::Method).getName(), parent.(Ruby::SingletonMethod).getName(),
          parent.(Ruby::SingletonMethod).getObject()
        ]
    then result = parent.getParent()
    else result = parent
  )
}

/** Gets the enclosing scope of a node */
cached
Scope::Range scopeOf(Ruby::AstNode n) {
  exists(Ruby::AstNode p | p = parentOf(n) |
    p = result
    or
    not p instanceof Scope::Range and result = scopeOf(p)
  )
}
