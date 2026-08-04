/**
 * Provides additional AST-like classes outside the generated tree-sitter classes.
 */

private import unified

module Public {
  /**
   * A logical 'and' expression with short-circuiting.
   */
  class LogicalAndExpr extends BinaryExpr {
    LogicalAndExpr() { this.getOperator().getValue() = "&&" }

    Expr getAnOperand() { result = [this.getLeft(), this.getRight()] }
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
}
