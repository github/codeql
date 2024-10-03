import semmle.code.powershell.dataflow.DataFlow::DataFlow as DataFlow
private import powershell
private import semmle.code.powershell.dataflow.internal.DataFlowImplSpecific
private import semmle.code.powershell.dataflow.internal.TaintTrackingImplSpecific
private import codeql.dataflow.internal.DataFlowImplConsistency

private module Input implements InputSig<Location, PowershellDataFlow> {
  private import PowershellDataFlow
}

import MakeConsistency<Location, PowershellDataFlow, PowershellTaintTracking, Input>
