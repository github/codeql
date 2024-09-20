package com.semmle.js.extractor;

import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.CallExpression;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.Node;

/** A utility class for detecting Node.js code. */
public class NodeJSDetector extends AbstractDetector {
  /**
   * Is {@code ast} a program that looks like Node.js code, that is, does it contain a top-level
   * {@code require} or an {@code module.exports = ...}/{@code exports = ...}?
   */
  public static boolean looksLikeNodeJS(Node ast) {
    return new NodeJSDetector().programDetection(ast);
  }

  @Override
  protected boolean visitExpression(Expression e) {
    // require('...')
    if (e instanceof CallExpression) {
      CallExpression call = (CallExpression) e;
      Expression callee = call.getCallee();
      if (isIdentifier(callee, "require") && call.getArguments().size() == 1) return true;
    }

    if (e instanceof AssignmentExpression) {
      AssignmentExpression assgn = (AssignmentExpression) e;

      // filter out compound assignments
      if (!"=".equals(assgn.getOperator())) return false;

      if (assgn.getLeft() instanceof MemberExpression) {
        MemberExpression target = (MemberExpression) assgn.getLeft();

        // `exports.foo = ...;`
        if (isIdentifier(target.getObject(), "exports")) return true;

        // `module.exports = ...;`
        if (isModuleExports(target)) return true;

        if (target.getObject() instanceof MemberExpression) {
          MemberExpression targetBase = (MemberExpression) target.getObject();

          // `module.exports.foo = ...;`
          if (isModuleExports(targetBase)) return true;
        }
      }
    }

    return super.visitExpression(e);
  }

  /** Is {@code me} a member expression {@code module.exports}? */
  private static boolean isModuleExports(MemberExpression me) {
    return !me.isComputed()
        && isIdentifier(me.getObject(), "module")
        && isIdentifier(me.getProperty(), "exports");
  }
}
