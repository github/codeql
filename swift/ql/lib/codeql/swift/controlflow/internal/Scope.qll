private import swift
private import codeql.swift.generated.GetImmediateParent

module CallableBase {
  class TypeRange = @abstract_function_decl;

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
  private AstNode getParentOfAstStep(Element e) {
    not e instanceof AstNode and
    result = getImmediateParent(e)
  }

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
