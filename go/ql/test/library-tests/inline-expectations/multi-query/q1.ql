/**
 * @id go/test/q1
 */

private import go

private predicate isFixtureFunction(Function function, string name) { function.getName() = name }

query predicate hit(Function function) {
  isFixtureFunction(function, ["sharedTarget", "qualifiedTarget", "foreignTarget", "noteTarget"])
}

query predicate mark(Function function, string value) {
  isFixtureFunction(function, "valuedTarget") and
  value = "q1"
}

query predicate one(Function function) { isFixtureFunction(function, "q1Target") }

query predicate spurious(Function function) { isFixtureFunction(function, "spuriousTarget") }
