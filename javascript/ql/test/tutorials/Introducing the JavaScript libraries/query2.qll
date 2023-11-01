import javascript

class CommaToken extends PunctuatorToken {
  CommaToken() { this.getValue() = "," }
}

query predicate test_query2(CommaToken comma, string res) {
  comma.getNextToken() instanceof CommaToken and res = "Omitted array elements are bad style."
}
