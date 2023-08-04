private import swift
private import codeql.swift.generated.ParentChild
private import codeql.swift.generated.Synth

module CallableBase {
  class TypeRange = Synth::TFunction or Synth::TKeyPathExpr or Synth::TClosureExpr;

  class Range extends Scope::Range, TypeRange { }
}

module Callable {
  class TypeRange = CallableBase::TypeRange;

  class Range extends Scope::Range, TypeRange { }
}

private module Scope {
  class TypeRange = Callable::TypeRange;

  class Range extends AstNode, TypeRange {
    Range getOuterScope() { result = scopeOfAst(this) }
  }
}

class Scope extends AstNode instanceof Scope::Range {
  /** Gets the scope in which this scope is nested, if any. */
  Scope getOuterScope() { result = super.getOuterScope() }
}

cached
private module Cached {
  /**
   * Gets the immediate parent of a non-`AstNode` element `e`.
   *
   * We restrict `e` to be a non-`AstNode` to skip past non-`AstNode` in
   * the transitive closure computation in `getParentOfAst`. This is
   * necessary because the parent of an `AstNode` is not necessarily an `AstNode`.
   */
  private Element getParentOfAstStep(Element e) {
    not e instanceof AstNode and
    result = getImmediateParent(e)
  }

  /** Gets the nearest enclosing parent of `ast` that is an `AstNode`. */
  cached
  AstNode getParentOfAst(AstNode ast) { result = getParentOfAstStep*(getImmediateParent(ast)) }
}

/** Gets the enclosing scope of a node */
cached
AstNode scopeOfAst(AstNode n) {
  exists(AstNode p | p = getParentOfAst(n) |
    if p instanceof Scope then p = result else result = scopeOfAst(p)
  )
}

import Cached
