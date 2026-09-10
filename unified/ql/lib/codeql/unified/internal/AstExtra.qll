/**
 * Provides additional AST-like classes outside the generated tree-sitter classes.
 */

private import unified

module Public {
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
    private Block block;

    LocalVariableDeclaration() { this = block.getStmt(_) }

    /** Gets the block in which this variable is declared. */
    Block getDeclaringBlock() { result = block }
  }

  /**
   * Declaration of a local or top-level function.
   */
  class LocalFunctionDeclaration extends FunctionDeclaration {
    private Block block;

    LocalFunctionDeclaration() { this = block.getStmt(_) }

    /** Gets the block in which this function is declared. */
    Block getDeclaringBlock() { result = block }
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
}
