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
import com.semmle.js.ast.SequenceExpression;
import com.semmle.js.ast.Statement;
import com.semmle.js.ast.TryStatement;
import com.semmle.js.ast.UnaryExpression;
import com.semmle.js.ast.VariableDeclaration;
import com.semmle.js.ast.VariableDeclarator;
import java.util.List;

/**
 * A utility base class for running detection logic on statements/expressions by
 * visiting each node. It performs recursive decent into assignment expressions and
 * callee expressions for call-expressions (to handle detection of `foo` in `foo()()`)
 * */
public abstract class AbstractDetector {
  protected boolean programDetection(Node ast) {
    if (!(ast instanceof Program)) return false;

    return visitStatements(((Program) ast).getBody());
  }

  protected boolean visitStatements(List<Statement> stmts) {
    for (Statement stmt : stmts) if (visitStatement(stmt)) return true;
    return false;
  }

  protected boolean visitStatement(Statement stmt) {
    if (stmt instanceof ExpressionStatement) {
      return visitExpression(((ExpressionStatement) stmt).getExpression());
    } else if (stmt instanceof VariableDeclaration) {
      for (VariableDeclarator decl : ((VariableDeclaration) stmt).getDeclarations()) {
        Expression init = decl.getInit();
        if (visitExpression(init)) return true;
      }

    } else if (stmt instanceof TryStatement) {
      return visitStatement(((TryStatement) stmt).getBlock());

    } else if (stmt instanceof BlockStatement) {
      return visitStatements(((BlockStatement) stmt).getBody());

    } else if (stmt instanceof IfStatement) {
      IfStatement is = (IfStatement) stmt;
      return visitStatement(is.getConsequent())
          || visitStatement(is.getAlternate());
    }

    return false;
  }

  /**
   * Recursively check {@code e} if it's a call or an assignment.
   */
  protected boolean visitExpression(Expression e) {
    if (e instanceof ParenthesizedExpression) {
      return visitExpression(((ParenthesizedExpression) e).getExpression());
    } else if (e instanceof CallExpression) {
      CallExpression call = (CallExpression) e;
      Expression callee = call.getCallee();
      // recurse, to handle things like `foo()()`
      if (visitExpression(callee)) return true;
      return false;
    } else if (e instanceof MemberExpression) {
      return visitExpression(((MemberExpression) e).getObject());
    } else if (e instanceof AssignmentExpression) {
      AssignmentExpression assgn = (AssignmentExpression) e;

      // filter out compound assignments
      if (!"=".equals(assgn.getOperator())) return false;

      return visitExpression(assgn.getRight());
    } else if (e instanceof UnaryExpression) {
      return visitExpression(((UnaryExpression) e).getArgument());
    } else if (e instanceof IFunction) {
      Node body = ((IFunction) e).getBody();
      if (body instanceof BlockStatement) {
      return visitStatement((BlockStatement) body);
      }
    } else if (e instanceof SequenceExpression) {
      SequenceExpression seq = (SequenceExpression) e;
      for (Expression child : seq.getExpressions()) {
        if (visitExpression(child)) return true;
      }
    }
    return false;
  }

  /** Is {@code e} an identifier with name {@code name}? */
  protected static boolean isIdentifier(Expression e, String name) {
    return e instanceof Identifier && name.equals(((Identifier) e).getName());
  }
}
