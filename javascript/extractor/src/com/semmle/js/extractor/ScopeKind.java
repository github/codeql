package com.semmle.js.extractor;

/**
 * A kind of scope, corresponding to the <code>@scope</code> type in the dbscheme.
 */
public enum ScopeKind {
  GLOBAL(0),
  FUNCTION(1),
  CATCH(2),
  MODULE(3),
  BLOCK(4),
  FOR(5),
  FOR_IN(6),
  COMPREHENSION_BLOCK(7),
  CLASS_EXPR(8),
  NAMESPACE(9),
  CLASS_DECL(10),
  INTERFACE(11),
  TYPE_ALIAS(12),
  MAPPED_TYPE(13),
  ENUM(14),
  EXTERNAL_MODULE(15),
  CONDITIONAL_TYPE(16);
  
  private int value;
  
  private ScopeKind(int value) {
    this.value = value;
  }

  /** Returns the value identifying this scope kind in the database. */
  public int getValue() {
    return value;
  }
}
