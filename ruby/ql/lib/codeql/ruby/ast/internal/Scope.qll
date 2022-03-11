private import TreeSitter
private import codeql.ruby.AST
private import codeql.ruby.ast.Scope
private import codeql.ruby.ast.internal.AST
private import codeql.ruby.ast.internal.Parameter
private import codeql.ruby.ast.internal.Variable

class TScopeType = TMethodBase or TModuleLike or TBlockLike;

/**
 * The scope of a `self` variable.
 * This differs from a normal scope because it is not affected by blocks or lambdas.
 */
class TSelfScopeType = TMethodBase or TModuleBase;

private class TBlockLike = TDoBlock or TLambda or TBlock or TEndBlock;

private class TModuleLike = TToplevel or TModuleDeclaration or TClassDeclaration or TSingletonClass;

private class TScopeReal = TMethodBase or TModuleLike or TDoBlock or TLambda or TBraceBlock;

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

    SelfBase::Range getEnclosingSelfScope() {
      this instanceof SelfBase::Range and result = this
      or
      not this instanceof SelfBase::Range and result = this.getOuterScope().getEnclosingSelfScope()
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

module SelfBase {
  class TypeRange = MethodBase::TypeRange or ModuleBase::TypeRange;

  /**
   * A `self` variable can appear in a class, module, method or at the top level.
   */
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

private Ruby::AstNode specialParentOf(Ruby::AstNode n) {
  n =
    [
      result.(Ruby::Module).getName(), result.(Ruby::Class).getName(),
      result.(Ruby::Class).getSuperclass(), result.(Ruby::SingletonClass).getValue(),
      result.(Ruby::Method).getName(), result.(Ruby::SingletonMethod).getName(),
      result.(Ruby::SingletonMethod).getObject()
    ]
}

private Ruby::AstNode parentOf(Ruby::AstNode n) {
  n = getHereDocBody(result)
  or
  result = specialParentOf(n).getParent()
  or
  not exists(specialParentOf(n)) and
  result = n.getParent()
}

private AstNode specialParentOfInclSynth(AstNode n) {
  n =
    [
      result.(Namespace).getScopeExpr(), result.(ClassDeclaration).getSuperclassExpr(),
      result.(SingletonMethod).getObject()
    ]
}

private AstNode parentOfInclSynth(AstNode n) {
  (
    result = specialParentOfInclSynth(n).getParent()
    or
    not exists(specialParentOfInclSynth(n)) and
    result = n.getParent()
  ) and
  (synthChild(_, _, n) implies synthChild(result, _, n))
}

cached
private module Cached {
  /** Gets the enclosing scope of a node */
  cached
  Scope::Range scopeOf(Ruby::AstNode n) {
    exists(Ruby::AstNode p | p = parentOf(n) |
      p = result
      or
      not p instanceof Scope::Range and result = scopeOf(p)
    )
  }

  /**
   * Gets the enclosing scope of a node. Unlike `scopeOf`, this predicate
   * operates on the external AST API, and therefore takes synthesized nodes
   * and synthesized scopes into account.
   */
  cached
  Scope scopeOfInclSynth(AstNode n) {
    exists(AstNode p | p = parentOfInclSynth(n) |
      p = result
      or
      not p instanceof Scope and result = scopeOfInclSynth(p)
    )
  }
}

import Cached

abstract class ScopeImpl extends AstNode, TScopeType {
  final Scope getOuterScopeImpl() { result = scopeOfInclSynth(this) }

  abstract Variable getAVariableImpl();

  final Variable getVariableImpl(string name) {
    result = this.getAVariableImpl() and
    result.getName() = name
  }
}

private class ScopeRealImpl extends ScopeImpl, TScopeReal {
  ScopeRealImpl() { toGenerated(this) instanceof Scope::Range }

  override Variable getAVariableImpl() { result.getDeclaringScope() = this }
}

// We desugar for loops by implementing them as calls to `each` with a block
// argument. Though this is how the desugaring is described in the MRI parser,
// in practice there is not a real nested scope created, so variables that
// may appear to be local to the loop body (e.g. the iteration variable) are
// scoped to the outer scope rather than the loop body.
private class ScopeSynthImpl extends ScopeImpl, TBraceBlockSynth {
  ScopeSynthImpl() { this = TBraceBlockSynth(_, _) }

  override Variable getAVariableImpl() {
    // Synthesized variables introduced as parameters to this scope
    // As this variable is also synthetic, it is genuinely local to this scope.
    exists(SimpleParameterSynthImpl p |
      p = TSimpleParameterSynth(this, _) and
      p.getVariableImpl() = result
    )
  }
}
