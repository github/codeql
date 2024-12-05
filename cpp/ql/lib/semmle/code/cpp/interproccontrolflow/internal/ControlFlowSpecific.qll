/**
 * Provides IR-specific definitions for use in the data flow library.
 */

private import cpp
private import semmle.code.cpp.interproccontrolflow.shared.ControlFlow

module Private {
  import ControlFlowPrivate
}

module Public {
  import ControlFlowPublic
}

module CppControlFlow implements InputSig<Location> {
  import Private
  import Public
}
