private import cpp
private import semmle.code.cpp.ir.dataflow.FlowSteps
private import semmle.code.cpp.dataflow.new.DataFlow

/**
 * The `CA2AEX` (and related) classes from the Windows Active Template library.
 */
class Ca2Aex extends Class {
  Ca2Aex() { this.hasGlobalName(["CA2AEX", "CA2CAEX", "CA2WEX"]) }
}

private class Ca2AexTaintInheritingContent extends TaintInheritingContent, DataFlow::FieldContent {
  Ca2AexTaintInheritingContent() {
    // The two members m_psz and m_szBuffer
    this.getField().getDeclaringType() instanceof Ca2Aex
  }
}
