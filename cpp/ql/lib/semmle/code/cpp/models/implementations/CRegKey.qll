private import cpp
private import semmle.code.cpp.models.interfaces.FlowSource
private import semmle.code.cpp.ir.dataflow.FlowSteps
private import semmle.code.cpp.dataflow.new.DataFlow

/** The `CRegKey` class from the Microsoft "Active Template Library". */
class CRegKey extends Class {
  CRegKey() { this.hasGlobalName("CRegKey") }
}

module CRegKey {
  /** The `m_hKey` member on a object of type `CRegKey`. */
  class MhKey extends Field {
    MhKey() {
      this.getDeclaringType() instanceof CRegKey and
      this.getName() = "m_hKey"
    }
  }

  private class MhKeyPathTaintInheritingContent extends TaintInheritingContent,
    DataFlow::FieldContent
  {
    MhKeyPathTaintInheritingContent() { this.getField() instanceof MhKey }
  }

  private class CRegKeyMemberFunction extends MemberFunction {
    string name;

    CRegKeyMemberFunction() { this.getClassAndName(name) instanceof CRegKey }
  }

  abstract private class CRegKeyFlowSource extends CRegKeyMemberFunction, LocalFlowSourceFunction {
    FunctionOutput output;

    final override predicate hasLocalFlowSource(FunctionOutput output_, string description) {
      output_ = output and
      description = "registry string read by " + name
    }
  }

  /** The `CRegKey::QueryBinaryValue` function from Win32. */
  class QueryBinaryValue extends CRegKeyFlowSource {
    QueryBinaryValue() { name = "QueryBinaryValue" and output.isParameterDeref(1) }
  }

  /** The `CRegKey::QueryDWORDValue` function from Win32. */
  class QueryDwordValue extends CRegKeyFlowSource {
    QueryDwordValue() { name = "QueryDWORDValue" and output.isParameterDeref(1) }
  }

  /** The `CRegKey::QueryGUIDValue` function from Win32. */
  class QueryGuidValue extends CRegKeyFlowSource {
    QueryGuidValue() { name = "QueryGUIDValue" and output.isParameterDeref(1) }
  }

  /** The `CRegKey::QueryMultiStringValue` function from Win32. */
  class QueryMultiStringValue extends CRegKeyFlowSource {
    QueryMultiStringValue() { name = "QueryMultiStringValue" and output.isParameterDeref(1) }
  }

  /** The `CRegKey::QueryQWORDValue` function from Win32. */
  class QueryQwordValue extends CRegKeyFlowSource {
    QueryQwordValue() { name = "QueryQWORDValue" and output.isParameterDeref(1) }
  }

  /** The `CRegKey::QueryStringValue` function from Win32. */
  class QueryStringValue extends CRegKeyFlowSource {
    QueryStringValue() { name = "QueryStringValue" and output.isParameterDeref(1) }
  }

  /** The `CRegKey::QueryValue` function from Win32. */
  class QueryValue extends CRegKeyFlowSource {
    QueryValue() {
      name = "QueryValue" and
      (
        this.getNumberOfParameters() = 4 and
        output.isParameterDeref(2)
        or
        this.getNumberOfParameters() = 2 and
        output.isParameterDeref(0)
        or
        this.getNumberOfParameters() = 3 and
        output.isParameterDeref(0)
      )
    }
  }
}
