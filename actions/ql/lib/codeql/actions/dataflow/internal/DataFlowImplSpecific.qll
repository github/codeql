/**
 * Provides Actions-specific definitions for use in the data flow library.
 * Implementation of https://github.com/github/codeql/blob/main/shared/dataflow/codeql/dataflow/DataFlow.qll
 */

private import codeql.dataflow.DataFlow
private import codeql.Locations

module ActionsDataFlow implements InputSig<Location> {
  import DataFlowPrivate as Private
  import DataFlowPublic
  import Private

  predicate neverSkipInPathGraph = Private::neverSkipInPathGraph/1;
}
