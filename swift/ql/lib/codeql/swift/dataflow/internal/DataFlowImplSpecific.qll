/**
 * Provides Swift-specific definitions for use in the data flow library.
 */

// we need to export `Unit` for the DataFlowImpl* files
private import swift as Swift

module Private {
  import DataFlowPrivate
  import DataFlowDispatch
}

module Public {
  import DataFlowPublic
}
