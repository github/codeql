/**
 * Provides additional AST-like classes outside the generated tree-sitter classes.
 */

private import unified
private import codeql.unified.internal.NameBindingPlugin

module Public {
  /** A plain assignment expression. */
  class AssignExpr extends BinaryExpr {
    AssignExpr() { this.getOperator().getValue() = "=" }

    /** Gets the target of this assignment. */
    Expr getTarget() { result = this.getLeft() }

    /** Gets the value assigned by this assignment. */
    Expr getValue() { result = this.getRight() }
  }

  /** A compound assignment expression. */
  class CompoundAssignExpr extends BinaryExpr {
    CompoundAssignExpr() {
      this.getOperator().getValue() =
        ["+=", "-=", "*=", "/=", "%=", "<<=", ">>=", "&=", "|=", "^=", "&+=", "&-=", "&*="]
    }

    /** Gets the target of this assignment. */
    Expr getTarget() { result = this.getLeft() }

    /** Gets the value assigned by this assignment. */
    Expr getValue() { result = this.getRight() }
  }

  /** A short-circuiting logical AND expression. */
  class LogicalAndExpr extends BinaryExpr {
    LogicalAndExpr() { this.getOperator().getValue() = "&&" }
  }

  /** A short-circuiting logical OR expression. */
  class LogicalOrExpr extends BinaryExpr {
    LogicalOrExpr() { this.getOperator().getValue() = "||" }
  }

  /** A short-circuiting null-coalescing expression. */
  class NullCoalescingExpr extends BinaryExpr {
    NullCoalescingExpr() { this.getOperator().getValue() = "??" }
  }

  /** A logical NOT expression. */
  class LogicalNotExpr extends UnaryExpr {
    LogicalNotExpr() { this.getOperator().(PrefixOperator).getValue() = "!" }
  }

  /**
   * Declaration of a local or top-level variable.
   */
  class LocalVariableDeclaration extends VariableDeclaration {
    LocalVariableDeclaration() { not isStaticMember(this) and not isInstanceMember(this) }
  }

  /**
   * Declaration of a local or top-level function.
   */
  class LocalFunctionDeclaration extends FunctionDeclaration {
    LocalFunctionDeclaration() { not isStaticMember(this) and not isInstanceMember(this) }
  }

  /**
   * A comment appearing in the source code.
   */
  class Comment extends TriviaToken {
    // At the moment, comments are the only type trivia token we extract
    /**
     * Gets the text inside this comment, not counting the delimiters.
     */
    string getCommentText() {
      result = this.getValue().regexpCapture("//(.*)", 1)
      or
      result = this.getValue().regexpCapture("(?s)/\\*(.*)\\*/", 1)
    }
  }

  /** A `Stmt` at the top-level. */
  final class TopLevelStmt extends Stmt {
    TopLevelStmt() { this = any(TopLevel t).getBody().getAStmt() }
  }

  /** An identifier appearing in the context of a break/continue label, argument/parameter name, or name of a member lookup. */
  final class IdentifierLabel extends Identifier {
    IdentifierLabel() {
      this = any(MemberAccessExpr e).getMemberNameNode() or
      this = any(Argument a).getNameNode() or
      this = any(Parameter p).getExternalNameNode() or
      this = any(LabeledStmt stmt).getLabelNameNode() or
      this = any(BreakExpr expr).getLabelNameNode() or
      this = any(ContinueExpr expr).getLabelNameNode()
    }
  }

  /** An identifier appearing in the context of an expression, pattern, or type annotation. */
  final class IdentifierExpr extends Identifier {
    IdentifierExpr() { not this instanceof IdentifierLabel }
  }
}
