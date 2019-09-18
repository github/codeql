package com.semmle.js.ast;

/**
 * A loop statement, that is, a {@link WhileStatement}, a {@link DoWhileStatement}, a {@link
 * ForStatement}, or a {@link EnhancedForStatement}.
 */
public abstract class Loop extends Statement {
  protected final Statement body;

  public Loop(String type, SourceLocation loc, Statement body) {
    super(type, loc);
    this.body = body;
  }

  /** The loop body. */
  public final Statement getBody() {
    return body;
  }

  /**
   * The child node of this loop where execution resumes after a <code>continue</code> statement.
   */
  public abstract Node getContinueTarget();
}
