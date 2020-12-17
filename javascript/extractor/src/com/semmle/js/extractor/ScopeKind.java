package com.semmle.js.extractor;

/**
 * A kind of scope, corresponding to the <code>@scope</code> type in the dbscheme.
 */
public enum ScopeKind {
  global(0),
  function(1),
  catch_(2),
  module(3),
  block(4),
  for_(5),
  forIn(6),
  comprehensionBlock(7),
  classExpr(8),
  namespace(9),
  classDecl(10),
  interface_(11),
  typeAlias(12),
  mappedType(13),
  enum_(14),
  externalModule(15),
  conditionalType(16);
  
  private int value;
  
  private ScopeKind(int value) {
    this.value = value;
  }

  /** Returns the value identifying this scope kind in the database. */
  public int getValue() {
    return value;
  }
}
