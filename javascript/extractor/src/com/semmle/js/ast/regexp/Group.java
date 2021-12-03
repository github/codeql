package com.semmle.js.ast.regexp;

import com.semmle.js.ast.SourceLocation;

/** A parenthesized group in a regular expression. */
public class Group extends RegExpTerm {
  private final boolean capture;
  private final int number;
  private final String name;
  private final RegExpTerm operand;

  public Group(
      SourceLocation loc, boolean capture, Number number, String name, RegExpTerm operand) {
    super(loc, "Group");
    this.capture = capture;
    this.number = number.intValue();
    this.name = name;
    this.operand = operand;
  }

  @Override
  public void accept(Visitor v) {
    v.visit(this);
  }

  /** Is this a capture group? */
  public boolean isCapture() {
    return capture;
  }

  /** Get the index of this group. */
  public int getNumber() {
    return number;
  }

  /** Is this a named captured group? */
  public boolean isNamed() {
    return name != null;
  }

  /** Get the name of this group, if any. */
  public String getName() {
    return name;
  }

  /** Get the term inside the group. */
  public RegExpTerm getOperand() {
    return operand;
  }
}
