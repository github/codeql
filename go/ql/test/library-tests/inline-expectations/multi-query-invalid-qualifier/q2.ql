/**
 * @id go/test/q2
 */

private import go

query predicate hit(Function function) {
  function.getName() = ["emptyQualifierTarget", "repeatedQualifierTarget"]
}
