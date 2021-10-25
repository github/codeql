package com.semmle.js.ast;

public abstract class ExportDeclaration extends Statement {

  public ExportDeclaration(String type, SourceLocation loc) {
    super(type, loc);
  }
}
