/**
 * @id go/test/q2
 */

private import go

private predicate isFixtureFunction(Function function, string name) { function.getName() = name }

query predicate hit(Function function) {
  isFixtureFunction(function,
    [
      "sharedTarget", "qualifiedTarget", "foreignTarget", "suppressedSiblingTarget",
      "namedSpuriousTarget", "noteTarget"
    ])
}

query predicate mark(Function function, string value) {
  isFixtureFunction(function, "valuedTarget") and
  value = "q2"
}

query predicate two(Function function) {
  isFixtureFunction(function, ["q2Target", "survivingSiblingTarget"])
}
