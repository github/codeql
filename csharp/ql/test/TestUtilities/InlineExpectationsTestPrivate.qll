import csharp
import semmle.code.csharp.Comments

/**
 * A class representing line comments in C# used by the InlineExpectations core code
 */
class ExpectationComment extends SinglelineComment {
  /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = this.getText() }
}
