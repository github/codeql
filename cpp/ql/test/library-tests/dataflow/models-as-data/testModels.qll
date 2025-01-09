import semmle.code.cpp.security.FlowSources

/**
 * Models-as-data source models for this test.
 */
private class TestSources extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;localMadSource;;;ReturnValue;local",
        ";;false;remoteMadSource;;;ReturnValue;remote",
        ";;false;localMadSourceVoid;;;ReturnValue;local",
        ";;false;localMadSourceHasBody;;;ReturnValue;local",
        ";;false;remoteMadSourceIndirect;;;ReturnValue[*];remote",
        ";;false;remoteMadSourceDoubleIndirect;;;ReturnValue[**];remote",
        ";;false;remoteMadSourceIndirectArg0;;;Argument[*0];remote",
        ";;false;remoteMadSourceIndirectArg1;;;Argument[*1];remote",
        ";;false;remoteMadSourceVar;;;;remote",
        ";;false;remoteMadSourceVarIndirect;;;*;remote", // not correctly expressed
        ";;false;remoteMadSourceParam0;;;Parameter[0];remote",
        "MyNamespace;;false;namespaceLocalMadSource;;;ReturnValue;local",
        "MyNamespace;;false;namespaceLocalMadSourceVar;;;;local",
        "MyNamespace::MyNamespace2;;false;namespace2LocalMadSource;;;ReturnValue;local",
        ";MyClass;true;memberRemoteMadSource;;;ReturnValue;remote",
        ";MyClass;true;memberRemoteMadSourceIndirectArg0;;;Argument[*0];remote",
        ";MyClass;true;memberRemoteMadSourceVar;;;;remote",
        ";MyClass;true;subtypeRemoteMadSource1;;;ReturnValue;remote",
        ";MyClass;false;subtypeNonSource;;;ReturnValue;remote", // the tests define this in MyDerivedClass, so it should *not* be recongized as a source
        ";MyClass;true;qualifierSource;;;Argument[-1];remote",
        ";MyClass;true;qualifierFieldSource;;;Argument[-1].val;remote",
        ";MyDerivedClass;false;subtypeRemoteMadSource2;;;ReturnValue;remote",
      ]
  }
}

/**
 * Models-as-data sink models for this test.
 */
private class TestSinks extends SinkModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;madSinkArg0;;;Argument[0];test-sink",
        ";;false;madSinkArg1;;;Argument[1];test-sink",
        ";;false;madSinkArg01;;;Argument[0..1];test-sink",
        ";;false;madSinkArg02;;;Argument[0,2];test-sink",
        ";;false;madSinkIndirectArg0;;;Argument[*0];test-sink",
        ";;false;madSinkDoubleIndirectArg0;;;Argument[**0];test-sink",
        ";;false;madSinkVar;;;;test-sink",
        ";;false;madSinkVarIndirect;;;*;test-sink", // not correctly expressed
        ";;false;madSinkParam0;;;Parameter[0];test-sink",
        ";MyClass;true;memberMadSinkArg0;;;Argument[0];test-sink",
        ";MyClass;true;memberMadSinkVar;;;;test-sink",
        ";MyClass;true;qualifierSink;;;Argument[-1];test-sink",
        ";MyClass;true;qualifierArg0Sink;;;Argument[-1..0];test-sink",
        ";MyClass;true;qualifierFieldSink;;;Argument[-1].val;test-sink",
        "MyNamespace;MyClass;true;namespaceMemberMadSinkArg0;;;Argument[0];test-sink",
        "MyNamespace;MyClass;true;namespaceStaticMemberMadSinkArg0;;;Argument[0];test-sink",
        "MyNamespace;MyClass;true;namespaceMemberMadSinkVar;;;;test-sink",
        "MyNamespace;MyClass;true;namespaceStaticMemberMadSinkVar;;;;test-sink",
      ]
  }
}

/**
 * Models-as-data summary models for this test.
 */
private class TestSummaries extends SummaryModelCsv {
  override predicate row(string row) {
    row =
      [
        ";;false;madArg0ToReturn;;;Argument[0];ReturnValue;taint",
        ";;false;madArg0ToReturnIndirect;;;Argument[0];ReturnValue[*];taint",
        ";;false;madArg0ToReturnValueFlow;;;Argument[0];ReturnValue;value",
        ";;false;madArg0IndirectToReturn;;;Argument[*0];ReturnValue;taint",
        ";;false;madArg0DoubleIndirectToReturn;;;Argument[**0];ReturnValue;taint",
        ";;false;madArg0NotIndirectToReturn;;;Argument[0];ReturnValue;taint",
        ";;false;madArg0ToArg1Indirect;;;Argument[0];Argument[*1];taint",
        ";;false;madArg0IndirectToArg1Indirect;;;Argument[*0];Argument[*1];taint",
        ";;false;madArgsComplex;;;Argument[*0..1,2];ReturnValue;taint",
        ";;false;madAndImplementedComplex;;;Argument[2];ReturnValue;taint",
        ";;false;madArgsAny;;;Argument;ReturnValue;taint", // (syntax not supported)
        ";;false;madArg0FieldToReturn;;;Argument[0].Field[value];ReturnValue;taint",
        ";;false;madArg0IndirectFieldToReturn;;;Argument[*0].Field[value];ReturnValue;taint",
        ";;false;madArg0FieldIndirectToReturn;;;Argument[0].Field[*ptr];ReturnValue;taint",
        ";;false;madArg0ToReturnField;;;Argument[0];ReturnValue.Field[value];taint",
        ";;false;madArg0ToReturnIndirectField;;;Argument[0];ReturnValue[*].Field[value];taint",
        ";;false;madArg0ToReturnFieldIndirect;;;Argument[0];ReturnValue.Field[*ptr];taint",
        ";;false;madFieldToFieldVar;;;Field[value];Field[value2];taint",
        ";;false;madFieldToIndirectFieldVar;;;Field[value];Field[*ptr];taint",
        ";;false;madIndirectFieldToFieldVar;;;;Field[value];Field[value2];taint", // not correctly expressed
        ";MyClass;true;madArg0ToSelf;;;Argument[0];Argument[-1];taint",
        ";MyClass;true;madSelfToReturn;;;Argument[-1];ReturnValue;taint",
        ";MyClass;true;madArg0ToField;;;Argument[0];Argument[-1].Field[val];taint",
        ";MyClass;true;madFieldToReturn;;;Argument[-1].Field[val];ReturnValue;taint",
        "MyNamespace;MyClass;true;namespaceMadSelfToReturn;;;Argument[-1];ReturnValue;taint",
        ";;false;madCallArg0ReturnToReturn;;;Argument[0].ReturnValue;ReturnValue;value",
        ";;false;madCallArg0ReturnToReturnFirst;;;Argument[0].ReturnValue;ReturnValue.Field[first];value",
        ";;false;madCallArg0WithValue;;;Argument[1];Argument[0].Parameter[0];value",
        ";;false;madCallReturnValueIgnoreFunction;;;Argument[1];ReturnValue;value",
        ";StructWithTypedefInParameter<T>;true;parameter_ref_to_return_ref;(const T &);;Argument[*0];ReturnValue[*];value",
        ";;false;receive_array;(int[20]);;Argument[*0];ReturnValue;taint"
      ]
  }
}
