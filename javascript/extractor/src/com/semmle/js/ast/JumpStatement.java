package com.semmle.js.ast;

/** A jump statement, that is, either a {@link BreakStatement} or a {@link ContinueStatement}. */
public abstract class JumpStatement extends Statement {
  private final Identifier label;

  public JumpStatement(String type, SourceLocation loc, Identifier label) {
    super(type, loc);
    this.label = label;
  }

  /** Does this jump have an explicit target label? */
  public boolean hasLabel() {
    return label != null;
  }

  /** Get the target label of this jump; may be null. */
  public Identifier getLabel() {
    return label;
  }
}
