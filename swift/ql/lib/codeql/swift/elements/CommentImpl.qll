private import codeql.swift.generated.Comment

module Impl {
  class Comment extends Generated::Comment {
    /** toString */
    override string toString() { result = this.getText() }
  }
}
