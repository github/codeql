package com.semmle.js.ast;

import java.util.ArrayList;
import java.util.List;

/** A try statement. */
public class TryStatement extends Statement {
  private final BlockStatement block;
  private final CatchClause handler;
  private final List<CatchClause> guardedHandlers, allHandlers;
  private final BlockStatement finalizer;

  public TryStatement(
      SourceLocation loc,
      BlockStatement block,
      CatchClause handler,
      List<CatchClause> guardedHandlers,
      BlockStatement finalizer) {
    super("TryStatement", loc);
    this.block = block;
    this.handler = handler;
    this.guardedHandlers = guardedHandlers;
    this.finalizer = finalizer;
    this.allHandlers = new ArrayList<CatchClause>();
    if (guardedHandlers != null) this.allHandlers.addAll(guardedHandlers);
    if (handler != null) this.allHandlers.add(handler);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The body of this try statement. */
  public BlockStatement getBlock() {
    return block;
  }

  /** The (single unguarded) catch clause of this try statement; may be null. */
  public CatchClause getHandler() {
    return handler;
  }

  /** The guarded catch clauses of this try statement. */
  public List<CatchClause> getGuardedHandlers() {
    return guardedHandlers;
  }

  /** The finally block of this try statement; may be null. */
  public BlockStatement getFinalizer() {
    return finalizer;
  }

  /** All catch clauses (both guarded and unguarded) of this try statement in lexical order. */
  public List<CatchClause> getAllHandlers() {
    return allHandlers;
  }

  /** Does this try statement have a finally block? */
  public boolean hasFinalizer() {
    return finalizer != null;
  }

  /** Does this try statement have an unguarded catch block? */
  public boolean hasHandler() {
    return handler != null;
  }
}
