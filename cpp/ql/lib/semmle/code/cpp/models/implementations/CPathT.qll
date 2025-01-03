private import cpp
private import semmle.code.cpp.ir.dataflow.FlowSteps
private import semmle.code.cpp.dataflow.new.DataFlow

/** The `CPathT` class from the Microsoft "Active Template Library". */
class CPathT extends Class {
  CPathT() { this.hasGlobalName("CPathT") }
}

private class MStrPath extends Field {
  MStrPath() { this.getDeclaringType() instanceof CPathT and this.hasName("m_strPath") }
}

private class MStrPathTaintInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  MStrPathTaintInheritingContent() { this.getField() instanceof MStrPath }
}
