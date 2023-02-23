import experimental.RA

class TestPredicate extends string {
  TestPredicate() { this = "p1" }

  string getLineOfRA(int line) {
    line = 1 and
    result = "    {1} r1 = CONSTANT(unique string)[\"p1\"]"
    or
    line = 2 and result = ""
    or
    line = 3 and
    result =
      "    {4} r2 = JOIN r1 WITH raparser#d14bb8db::TestPredicate#b ON FIRST 1 OUTPUT \"p1\", toString(\"p1\"), 123, \"  r1 = SCAN fubar\\n   r1\""
    or
    line = 4 and result = ""
    or
    line = 5 and result = "    {4} r3 = STREAM DEDUP r2"
    or
    line = 6 and
    result =
      "    {4} r4 = JOIN r1 WITH raparser#d14bb8db::TestPredicate#b ON FIRST 1 OUTPUT \"p1\", \"(no string representation)\", 123, \"  r1 = SCAN fubar\\n   r1\""
    or
    line = 7 and result = "    {4} r5 = STREAM DEDUP r4"
    or
    line = 8 and result = "    {4} r6 = r5 AND NOT project##select#query#ffff#nullary({})"
    or
    line = 9 and result = "    {4} r7 = r3 UNION r6"
    or
    line = 10 and result = "    return r7"
  }
}

query predicate children(
  RAParser<TestPredicate>::RAExpr parent, RAParser<TestPredicate>::RAExpr child
) {
  child = parent.getAChild()
}

from RAParser<TestPredicate>::RAExpr expr
select expr.getPredicate(), expr.getLine(), expr, expr.getLhs(), expr.getArity(),
  count(expr.getARhsPredicate()), count(expr.getARhsVariable())
