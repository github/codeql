import java

/**
 * A class representing line comments in Java, which is simply Javadoc restricted
 * to EOL comments, with an extra accessor used by the InlineExpectations core code
 */
class ExpectationComment extends Javadoc {
  ExpectationComment() { isEolComment(this) }

  /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = this.getChild(0).toString() }
}
