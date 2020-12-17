package com.semmle.js.extractor;

/**
 * A kind of top-level, corresponding to the <code>@toplevel</code> type in the dbscheme.
 */
public enum TopLevelKind {
  script(0),
  inlineScript(1),
  eventHandler(2),
  javascriptUrl(3),
  angularTemplate(4);
  
  private int value;
  
  private TopLevelKind(int value) {
    this.value = value;
  }

  /** Returns the value identifying this toplevel kind in the database. */
  public int getValue() {
    return value;
  }
}
