import java

/**
 * A class representing line comments in Java, which is simply Javadoc restricted
 * to EOL comments, with an extra accessor used by the InlineExpectations core code
 */
abstract class ExpectationComment extends Top {
  /** Gets the contents of the given comment, _without_ the preceding comment marker (`//`). */
  abstract string getContents();
}

private class JavadocExpectationComment extends Javadoc, ExpectationComment {
  JavadocExpectationComment() { isEolComment(this) }

  override string getContents() { result = this.getChild(0).toString() }
}

private class KtExpectationComment extends KtComment, ExpectationComment {
  KtExpectationComment() { this.isEolComment() }

  override string getContents() { result = this.getText().suffix(2).trim() }
}

private class XmlExpectationComment extends ExpectationComment instanceof XmlComment {
  override string getContents() { result = this.(XmlComment).getText().trim() }

  override Location getLocation() { result = this.(XmlComment).getLocation() }

  override predicate hasLocationInfo(string path, int sl, int sc, int el, int ec) {
    this.(XmlComment).hasLocationInfo(path, sl, sc, el, ec)
  }

  override string toString() { result = this.(XmlComment).toString() }
}
