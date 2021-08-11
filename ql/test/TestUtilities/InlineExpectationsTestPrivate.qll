import ruby
import codeql.ruby.ast.internal.TreeSitter

/**
 * A class representing line comments in Ruby.
 */
class LineComment extends Ruby::Comment {
  string getContents() { result = this.getValue().suffix(1) }
}
