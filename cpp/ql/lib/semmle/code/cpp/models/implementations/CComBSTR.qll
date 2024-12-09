private import cpp
private import semmle.code.cpp.ir.dataflow.FlowSteps
private import semmle.code.cpp.dataflow.new.DataFlow

/** The `CComBSTR` class from the Microsoft "Active Template Library". */
class CcomBstr extends Class {
  CcomBstr() { this.hasGlobalName("CComBSTR") }
}

private class Mstr extends Field {
  Mstr() { this.getDeclaringType() instanceof CcomBstr and this.hasName("m_str") }
}

private class MstrTaintInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  MstrTaintInheritingContent() { this.getField() instanceof Mstr }
}
