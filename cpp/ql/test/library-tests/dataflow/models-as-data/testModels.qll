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
        // TODO: remoteMadSourceIndirect
        ";;false;remoteMadSourceArg0;;;Argument[0];remote",
        ";;false;remoteMadSourceArg1;;;Argument[1];remote", ";;false;remoteMadSourceVar;;;;remote",
        ";;false;remoteMadSourceParam0;;;Parameter[0];remote",
        "MyNamespace;;false;namespaceLocalMadSource;;;ReturnValue;local",
        "MyNamespace;;false;namespaceLocalMadSourceVar;;;;local",
        "MyNamespace::MyNamespace2;;false;namespace2LocalMadSource;;;ReturnValue;local",
        ";MyClass;true;memberRemoteMadSource;;;ReturnValue;remote",
        ";MyClass;true;memberRemoteMadSourceArg0;;;Argument[0];remote",
        ";MyClass;true;memberRemoteMadSourceVar;;;;remote",
        ";MyClass;true;subtypeRemoteMadSource1;;;ReturnValue;remote",
        ";MyClass;false;subtypeNonSource;;;ReturnValue;remote", // the tests define this in MyDerivedClass, so it should *not* be recongized as a source
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
        // TODO: madSinkIndirectArg0
        ";;false;madSinkVar;;;;test-sink", ";;false;madSinkParam0;;;Parameter[0];test-sink",
        ";MyClass;true;memberMadSinkArg0;;;Argument[0];test-sink",
        ";MyClass;true;memberMadSinkVar;;;;test-sink",
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
        ";;false;madArg0ToReturnValueFlow;;;Argument[0];ReturnValue;value",
        // TODO: madArg0IndirectToReturn
        ";;false;madArg0ToArg1;;;Argument[0];Argument[1];taint",
        // TODO: madArg0IndirectToArg1
        ";;false;madArg0FieldToReturn;;;Argument[0].value;ReturnValue;taint",
        // TODO: madArg0IndirectFieldToReturn
        ";;false;madArg0ToReturnField;;;Argument[0];ReturnValue.value;taint",
        ";MyClass;true;madArg0ToSelf;;;Argument[0];Argument[-1];taint",
        ";MyClass;true;madSelfToReturn;;;Argument[-1];ReturnValue;taint",
        ";MyClass;true;madArg0ToField;;;Argument[0];Argument[-1].val;taint",
        ";MyClass;true;madFieldToReturn;;;Argument[-1].val;ReturnValue;taint",
        "MyNamespace;MyClass;true;namespaceMadSelfToReturn;;;Argument[-1];ReturnValue;taint",
        ";;false;madCallArg0ReturnToReturn;;;Argument[0].ReturnValue;ReturnValue;value",
        ";;false;madCallArg0ReturnToReturnFirst;;;Argument[0].ReturnValue;ReturnValue.first;value",
        ";;false;madCallArg0WithValue;;;Argument[1];Argument[0].Parameter[0];value",
      ]
  }
}
