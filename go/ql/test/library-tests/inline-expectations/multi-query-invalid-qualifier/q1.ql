/**
 * @id go/test/q1
 */

private import go

query predicate hit(Function function) { function.getName() = "sharedTarget" }
