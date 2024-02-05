/**
 * Provides Actions-specific definitions for use in the data flow library.
 * Implementation of https://github.com/github/codeql/blob/main/shared/dataflow/codeql/dataflow/DataFlow.qll
 */

private import codeql.dataflow.DataFlow

module ActionsDataFlow implements InputSig {
  import DataFlowPrivate
  import DataFlowPublic
}
