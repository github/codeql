package com.semmle.js.ast;

import com.semmle.ts.ast.INodeWithSymbol;
import java.util.List;

/** A top-level program entity forming the root of an AST. */
public class Program extends Node implements IStatementContainer, INodeWithSymbol {
  private final List<Statement> body;
  private final String sourceType;
  private int symbolId = -1;

  public Program(SourceLocation loc, List<Statement> body, String sourceType) {
    super("Program", loc);
    this.body = body;
    this.sourceType = sourceType;
  }

  @Override
  public <Q, A> A accept(Visitor<Q, A> v, Q q) {
    return v.visit(this, q);
  }

  /** The statements in this program. */
  public List<Statement> getBody() {
    return body;
  }

  public String getSourceType() {
    return sourceType;
  }

  public int getSymbol() {
    return this.symbolId;
  }

  public void setSymbol(int symbolId) {
    this.symbolId = symbolId;
  }
}
