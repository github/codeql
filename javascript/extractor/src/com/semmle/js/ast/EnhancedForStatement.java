package com.semmle.js.ast;

/**
 * An enhanced for statement, that is, either a {@link ForInStatement} or a {@link ForOfStatement}.
 */
public abstract class EnhancedForStatement extends Loop {
  private final Node left;
  private final Expression defaultValue;
  private final Expression right;

  public EnhancedForStatement(
      String type, SourceLocation loc, Node left, Expression right, Statement body) {
    super(type, loc, body);
    if (left instanceof AssignmentPattern) {
      AssignmentPattern ap = (AssignmentPattern) left;
      this.left = ap.getLeft();
      this.defaultValue = ap.getRight();
    } else {
      this.left = left;
      this.defaultValue = null;
    }
    this.right = right;
  }

  /**
   * The iterator variable of this statement; may be either a {@link VariableDeclaration} statement,
   * or an lvalue {@link Expression}.
   */
  public Node getLeft() {
    return left;
  }

  /** Does the iterator variable of this statement have a default value? */
  public boolean hasDefaultValue() {
    return defaultValue != null;
  }

  /** Get the default value of the iterator variable of this statement. */
  public Expression getDefaultValue() {
    return defaultValue;
  }

  /** The expression this loop iterates over. */
  public Expression getRight() {
    return right;
  }

  @Override
  public Node getContinueTarget() {
    return this;
  }
}
