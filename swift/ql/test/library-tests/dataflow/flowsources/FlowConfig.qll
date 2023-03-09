import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.dataflow.ExternalFlow

/**
 * A models-as-data class expressing custom flow sources for this test. These
 * cases ensure that MaD source definitions are able to successfully match a
 * range of class fields and member functions.
 */
class CustomTestSourcesCsv extends SourceModelCsv {
  override predicate row(string row) {
    row =
      [
        ";MySimpleClass;true;source1;;;;remote", ";MySimpleClass;true;source2;;;;remote",
        ";MySimpleClass;true;source3();;;ReturnValue;remote",
        // ---
        ";MyGeneric;true;source1;;;;remote", ";MyGeneric;true;source2;;;;remote",
        ";MyGeneric;true;source3();;;ReturnValue;remote", ";MyDerived;true;source4;;;;remote",
        ";MyDerived;true;source5;;;;remote", ";MyDerived;true;source6();;;ReturnValue;remote",
        ";MyDerived;true;source7;;;;remote", ";MyDerived;true;source8();;;ReturnValue;remote",
        ";MyDerived2;true;source9;;;;remote", ";MyDerived2;true;source10;;;;remote",
        ";MyDerived2;true;source11();;;ReturnValue;remote", ";MyDerived2;true;source12;;;;remote",
        ";MyDerived2;true;source13();;;ReturnValue;remote",
        // ---
        ";MyParentProtocol;true;source0;;;;remote", ";MyProtocol;true;source1;;;;remote",
        ";MyProtocol;true;source2;;;;remote",
        // ---
        ";MyParentProtocol2;true;source0;;;;remote", ";MyProtocol2;true;source1;;;;remote",
        ";MyProtocol2;true;source2;;;;remote",
        // ---
        ";MyProtocol3;true;source1();;;ReturnValue;remote",
        ";MyProtocol3;true;source2();;;ReturnValue;remote",
        ";MyProtocol3;true;source3();;;ReturnValue;remote"
      ]
  }
}
