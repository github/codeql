/**
 * Provides Python-specific definitions for use in the data flow library.
 */

// we need to export `Unit` for the DataFlowImpl* files
private import python as Python

module Private {
  import DataFlowPrivate

  //   import DataFlowDispatch
  class Unit = Python::Unit;
}

module Public {
  import DataFlowPublic
  import DataFlowUtil
}
