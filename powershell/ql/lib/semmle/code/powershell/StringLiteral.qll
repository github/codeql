import powershell

class StringLiteral extends @string_literal {
  int getNumContinuations() { string_literal_line(this, result, _) }

  string getContinuation(int index) { string_literal_line(this, index, result) }

  /** Get the full string literal with all its parts concatenated */
  string toString() {
    result = concat(int i | i = [0 .. getNumContinuations()] | getContinuation(i), "\n")
  }

  SourceLocation getLocation() { string_literal_location(this, result) }
}
