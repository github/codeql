/**
 * @kind test-postprocess
 * @description Remove the query predicates that differ based on 32/64-bit architecture. This should leave behind `invalidModelRowAdd` and `testFailures` in case of test failures.
 */

/**
 * The input test results: query predicate `relation` contains `data` at (`row`, `column`).
 */
external private predicate queryResults(string relation, int row, int column, string data);

/** Holds if the test output's query predicate `relation` contains `data` at (`row`, `column`). */
query predicate results(string relation, int row, int column, string data) {
  queryResults(relation, row, column, data) and
  not relation in ["#select", "nodes", "edges"]
}
