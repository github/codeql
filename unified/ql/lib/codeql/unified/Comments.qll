/** Provides classes for working with comments. */

private import unified

/**
 * A comment appearing in the source code.
 */
class Comment extends TriviaToken {
  // At the moment, comments are the only type trivia token we extract
  /**
   * Gets the text inside this comment, not counting the delimeters.
   */
  string getCommentText() {
    result = this.getValue().regexpCapture("//(.*)", 1)
    or
    result = this.getValue().regexpCapture("(?s)/\\*(.*)\\*/", 1)
  }
}
