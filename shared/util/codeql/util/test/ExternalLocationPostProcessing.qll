/**
 * Provides logic for creating a `@kind test-postprocess` query that converts
 * external locations to a special `{EXTERNAL LOCATION}` string.
 *
 * This is useful for writing tests that use real locations when executed in
 * VS Code, but prevents the "Location is outside of test directory" warning
 * when executed through `codeql test run`.
 */
module;

external private predicate queryResults(string relation, int row, int column, string data);

external private predicate queryRelations(string relation);

private signature string getSourceLocationPrefixSig();

module Make<getSourceLocationPrefixSig/0 getSourceLocationPrefix> {
  query predicate results(string relation, int row, int column, string data) {
    exists(string s | queryResults(relation, row, column, s) |
      if
        not s = "file://" + any(string suffix) or
        s = "file://:0:0:0:0" or
        s = getSourceLocationPrefix() + any(string suffix)
      then data = s
      else data = "{EXTERNAL LOCATION}"
    )
  }

  query predicate resultRelations(string relation) { queryRelations(relation) }
}
