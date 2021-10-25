package com.semmle.jcorn;

import com.semmle.js.ast.Position;

public class SyntaxError extends RuntimeException {
  private static final long serialVersionUID = -4883173648492364902L;

  private final Position position;

  public SyntaxError(String msg, Position loc, int raisedAt) {
    super(msg);
    this.position = loc;
  }

  public Position getPosition() {
    return position;
  }
}
