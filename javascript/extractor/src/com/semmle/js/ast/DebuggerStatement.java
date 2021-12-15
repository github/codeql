package com.semmle.js.ast;

/** A debugger statement <code>debugger;</code>. */
public class DebuggerStatement extends Statement {
  public DebuggerStatement(SourceLocation loc) {
    super("DebuggerStatement", loc);
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }
}
