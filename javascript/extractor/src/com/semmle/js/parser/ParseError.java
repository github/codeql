package com.semmle.js.parser;

import com.semmle.js.ast.Position;
import com.semmle.util.exception.UserError;

/** A parse error including both a message and location information. */
public class ParseError extends Throwable {
  private static final long serialVersionUID = 1L;

  private Position position;

  public ParseError(String message, int line, int column, int offset) {
    this(message, new Position(line, column, offset));
  }

  public ParseError(String message, Position pos) {
    super(massage(message));
    this.position = pos;
  }

  /*
   * Helper function to remove location information included in the parser's
   * parse error messages.
   */
  private static String massage(String message) {
    if (message.contains("(")) return message.substring(0, message.lastIndexOf('(') - 1);
    return message;
  }

  /** Convert this parse error into a {@link UserError}. */
  public UserError asUserError() {
    return new UserError(getMessage() + ": " + position);
  }

  public Position getPosition() {
    return position;
  }

  public void setPosition(Position position) {
    this.position = position;
  }

  @Override
  public String toString() {
    return getMessage();
  }
}
