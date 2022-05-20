package com.semmle.js.extractor;

import com.semmle.js.ast.AssignmentExpression;
import com.semmle.js.ast.BlockStatement;
import com.semmle.js.ast.CallExpression;
import com.semmle.js.ast.Expression;
import com.semmle.js.ast.ExpressionStatement;
import com.semmle.js.ast.IFunction;
import com.semmle.js.ast.Identifier;
import com.semmle.js.ast.IfStatement;
import com.semmle.js.ast.MemberExpression;
import com.semmle.js.ast.Node;
import com.semmle.js.ast.ParenthesizedExpression;
import com.semmle.js.ast.Program;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.TryStatement;
import com.semmle.js.ast.UnaryExpression;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.js.ast.VariableDeclarator;
import java.util.List;

/** A utility class for detecting Node.js code. */
public class NodeJSDetector {
  /**
   * Is {@code ast} a program that looks like Node.js code, that is, does it contain a top-level
   * {@code require} or an export?
   */
  public static boolean looksLikeNodeJS(Node ast) {
    if (!(ast instanceof Program)) return false;

    return hasToplevelRequireOrExport(((Program) ast).getBody());
  }

  /**
   * Does this program contain a statement that looks like a Node.js {@code require} or an export?
   *
   * <p>We recursively traverse argument-less immediately invoked function expressions (i.e., no UMD
   * modules), but not loops or if statements.
   */
  private static boolean hasToplevelRequireOrExport(List<Statement> stmts) {
    for (Statement stmt : stmts) if (hasToplevelRequireOrExport(stmt)) return true;
    return false;
  }

  private static boolean hasToplevelRequireOrExport(Statement stmt) {
    if (stmt instanceof ExpressionStatement) {
      Expression e = stripParens(((ExpressionStatement) stmt).getExpression());

      // check whether `e` is an iife; if so, recursively check its body

      // strip off unary operators to handle `!function(){...}()`
      if (e instanceof UnaryExpression) e = ((UnaryExpression) e).getArgument();

      if (e instanceof CallExpression && ((CallExpression) e).getArguments().isEmpty()) {
        Expression callee = stripParens(((CallExpression) e).getCallee());
        if (callee instanceof IFunction) {
          Node body = ((IFunction) callee).getBody();
          if (body instanceof BlockStatement)
            return hasToplevelRequireOrExport(((BlockStatement) body).getBody());
        }
      }

      if (isRequireCall(e) || isExport(e)) return true;

    } else if (stmt instanceof VariableDeclaration) {
      for (VariableDeclarator decl : ((VariableDeclaration) stmt).getDeclarations()) {
        Expression init = stripParens(decl.getInit());
        if (isRequireCall(init) || isExport(init)) return true;
      }

    } else if (stmt instanceof TryStatement) {
      return hasToplevelRequireOrExport(((TryStatement) stmt).getBlock());

    } else if (stmt instanceof BlockStatement) {
      return hasToplevelRequireOrExport(((BlockStatement) stmt).getBody());

    } else if (stmt instanceof IfStatement) {
      IfStatement is = (IfStatement) stmt;
      return hasToplevelRequireOrExport(is.getConsequent())
          || hasToplevelRequireOrExport(is.getAlternate());
    }

    return false;
  }

  private static Expression stripParens(Expression e) {
    if (e instanceof ParenthesizedExpression)
      return stripParens(((ParenthesizedExpression) e).getExpression());
    return e;
  }

  /**
   * Is {@code e} a call to a function named {@code require} with one argument, or an assignment
   * whose right hand side is the result of such a call?
   */
  private static boolean isRequireCall(Expression e) {
    if (e instanceof CallExpression) {
      CallExpression call = (CallExpression) e;
      Expression callee = call.getCallee();
      if (isIdentifier(callee, "require") && call.getArguments().size() == 1) return true;
      if (isRequireCall(callee)) return true;
      return false;
    } else if (e instanceof MemberExpression) {
      return isRequireCall(((MemberExpression) e).getObject());
    } else if (e instanceof AssignmentExpression) {
      AssignmentExpression assgn = (AssignmentExpression) e;

      // filter out compound assignments
      if (!"=".equals(assgn.getOperator())) return false;

      return isRequireCall(assgn.getRight());
    }
    return false;
  }

  /**
   * Does {@code e} look like a Node.js export?
   *
   * <p>Currently, three kinds of exports are recognised:
   *
   * <ul>
   *   <li><code>exports.foo = ...</code>
   *   <li><code>module.exports = ...</code>
   *   <li><code>module.exports.foo = ...</code>
   * </ul>
   *
   * Detection is done recursively, so <code>foo = exports.foo = ...</code> is handled correctly.
   */
  private static boolean isExport(Expression e) {
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

      // recursively check right hand side
      return isExport(assgn.getRight());
    }

    return false;
  }

  /** Is {@code me} a member expression {@code module.exports}? */
  private static boolean isModuleExports(MemberExpression me) {
    return !me.isComputed()
        && isIdentifier(me.getObject(), "module")
        && isIdentifier(me.getProperty(), "exports");
  }

  /** Is {@code e} an identifier with name {@code name}? */
  private static boolean isIdentifier(Expression e, String name) {
    return e instanceof Identifier && name.equals(((Identifier) e).getName());
  }
}
