import javascript

query predicate test_query4(AddExpr add, string res) {
  exists(ShiftExpr shift | add = shift.getAnOperand() |
    res = "This expression should be bracketed to clarify precedence rules."
  )
}
