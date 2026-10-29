package com.semmle.js.extractor;

/**
 * A kind of top-level, corresponding to the <code>@toplevel</code> type in the dbscheme.
 */
public enum TopLevelKind {
  SCRIPT(0),
  INLINE_SCRIPT(1),
  EVENT_HANDLER(2),
  JAVASCRIPT_URL(3),
  ANGULAR_STYLE_TEMPLATE(4);
  
  private int value;
  
  private TopLevelKind(int value) {
    this.value = value;
  }

  /** Returns the value identifying this toplevel kind in the database. */
  public int getValue() {
    return value;
  }
}
