import go

/**
 * Represents a line comment in the Go style.
 * include the preceding comment marker (`//`).
 */
class ExpectationComment extends Comment {
  /** Returns the contents of the given comment, _without_ the preceding comment marker (`//`). */
  string getContents() { result = this.getText() }
}
