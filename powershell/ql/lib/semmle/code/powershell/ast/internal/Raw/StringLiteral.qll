private import Raw

class StringLiteral extends @string_literal {
  int getNumContinuations() { result = strictcount(int i | exists(this.getContinuation(i))) }

  string getContinuation(int index) { string_literal_line(this, index, result) }

  /** Get the full string literal with all its parts concatenated */
  string toString() { result = this.getValue() }

  string getValue() {
    result = concat(int i | i = [0 .. this.getNumContinuations()] | this.getContinuation(i), "\n")
  }

  SourceLocation getLocation() { string_literal_location(this, result) }
}
