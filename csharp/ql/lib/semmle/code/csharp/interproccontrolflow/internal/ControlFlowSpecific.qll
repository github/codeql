/**
 * Provides C#-specific definitions for use in the control-flow library.
 */

private import csharp
private import codeql.globalcontrolflow.ControlFlow

module Private {
  import ControlFlowPrivate
}

module Public {
  import ControlFlowPublic
}

module CSharpControlFlow implements InputSig<Location> {
  import Private
  import Public
}
