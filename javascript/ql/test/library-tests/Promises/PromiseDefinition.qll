import javascript

query predicate test_PromiseDefinition(PromiseDefinition res) {
  res = any(PromiseDefinition pd | any() | pd)
}
