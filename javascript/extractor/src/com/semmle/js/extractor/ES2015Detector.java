package com.semmle.js.extractor;

import com.semmle.js.ast.DynamicImport;
import com.semmle.js.ast.ExportDeclaration;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ImportDeclaration;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.Statement;

/** A utility class for detecting Node.js code. */
public class ES2015Detector extends AbstractDetector {
  /**
   * Is {@code ast} a program that uses ES2015 import/export code?
   */
  public static boolean looksLikeES2015(Node ast) {
    return new ES2015Detector().programDetection(ast);
  }

  @Override
  protected boolean visitStatement(Statement stmt) {
    if (stmt instanceof ImportDeclaration || stmt instanceof ExportDeclaration) {
      return true;
    }
    return super.visitStatement(stmt);
  }

  @Override
  protected boolean visitExpression(Expression e) {
    if (e instanceof DynamicImport) {
      return true;
    }
    return super.visitExpression(e);
  }
}
