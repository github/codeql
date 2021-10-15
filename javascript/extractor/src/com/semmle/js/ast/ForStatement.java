package com.semmle.js.ast;

/**
 * A for statement such as
 *
 * <pre>
 * for (var i=10; i&gt;0; i--)
 *   console.log(i);
 * console.log("Boom!");
 * </pre>
 */
public class ForStatement extends Loop {
  private final Node init;
  private final Expression test, update;

  public ForStatement(
      SourceLocation loc, Node init, Expression test, Expression update, Statement body) {
    super("ForStatement", loc, body);
    this.init = init;
    this.test = test;
    this.update = update;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** Does this for statement have an initialization part? */
  public boolean hasInit() {
    return init != null;
  }

  /**
   * The initialization part of this for statement; may be a {@link VariableDeclaration} statement,
   * an {@link Expression}, or {@literal null}.
   */
  public Node getInit() {
    return init;
  }

  /** Does this for statement have a test? */
  public boolean hasTest() {
    return test != null;
  }

  /** The test expression of this for statement; may be null. */
  public Expression getTest() {
    return test;
  }

  /** Does this for statement have an update expression? */
  public boolean hasUpdate() {
    return update != null;
  }

  /** The update expression of this for statement; may be null. */
  public Expression getUpdate() {
    return update;
  }

  @Override
  public Node getContinueTarget() {
    if (update != null) return update;
    if (test != null) return test;
    return body;
  }
}
