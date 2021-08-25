/** Provides a class for representing source maps. */

import javascript

/**
 * A source mapping comment associating a source map with a file.
 */
class SourceMappingComment extends Comment {
  /** The `url` is a `sourceMappingURL` embedded in this comment. */
  string url;

  SourceMappingComment() {
    exists(string sourceMappingURLRegex |
      sourceMappingURLRegex = "[@#]\\s*sourceMappingURL\\s*=\\s*(.*)\\s*"
    |
      // either a line comment whose entire text matches the regex...
      url = this.(SlashSlashComment).getText().regexpCapture(sourceMappingURLRegex, 1)
      or
      // ...or a block comment one of whose lines matches the regex
      url = this.(SlashStarComment).getLine(_).regexpCapture("//" + sourceMappingURLRegex, 1)
    )
  }

  /** Gets the URL of the source map referenced by this comment. */
  string getSourceMappingURL() { result = url }
}
