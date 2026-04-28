/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe deserialization vulnerabilities, as well as extension points for
 * adding your own.
 */

private import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
private import semmle.code.powershell.dataflow.flowsources.FlowSources
private import semmle.code.powershell.Cfg
private import powershell

module UnsafeDeserialization {
  /**
   * A data flow source for unsafe deserialization vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this flow source. */
    abstract string getSourceType();
  }

  /**
   * A data flow sink for unsafe deserialization vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node {
    /** Gets a description of this sink. */
    abstract string getSinkType();
  }

  /**
   * A sanitizer for Unsafe Deserialization vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of user input, considered as a flow source for unsafe deserialization. */
  class FlowSourceAsSource extends Source instanceof SourceNode {
    override string getSourceType() { result = SourceNode.super.getSourceType() }
  }

  /**
   * Holds if the `ObjectCreationNode` `ocn` constructs a type whose fully qualified name
   * (lowercase) matches `fullTypeName`. Handles both `New-Object TypeName` and
   * `[TypeName]::new()` patterns.
   */
  private predicate objectCreationMatchesType(
    DataFlow::ObjectCreationNode ocn, string fullTypeName
  ) {
    // New-Object TypeName: getLowerCaseConstructedTypeName() returns the full qualified name
    ocn.getLowerCaseConstructedTypeName() = fullTypeName
    or
    // [TypeName]::new(): access the qualifier TypeNameExpr for the full qualified name
    ocn.getExprNode().getExpr().(ConstructorCall).getQualifier().(TypeNameExpr)
        .getPossiblyQualifiedName() = fullTypeName
  }

  /**
   * Holds if `typeName` (lowercase, fully qualified) is a known unsafe deserializer type
   * and `methodName` (lowercase) is an unsafe deserialization instance method on that type.
   */
  private predicate unsafeInstanceDeserializer(string typeName, string methodName) {
    typeName = "system.runtime.serialization.formatters.soap.soapformatter" and
    methodName = "deserialize"
    or
    typeName = "system.web.ui.objectstateformatter" and
    methodName = "deserialize"
    or
    typeName = "system.runtime.serialization.netdatacontractserializer" and
    methodName = ["deserialize", "readobject"]
    or
    typeName = "system.web.ui.losformatter" and
    methodName = "deserialize"
    or
    typeName = "system.data.dataset" and
    methodName = "readxmlschema"
    or
    typeName = "system.data.datatable" and
    methodName = ["readxmlschema", "readxml"]
    or
    typeName = "yamldotnet.serialization.deserializer" and
    methodName = "deserialize"
  }

  /**
   * Holds if `typeName` (lowercase, fully qualified) has a static method
   * `methodName` (lowercase) that is an unsafe deserializer.
   */
  private predicate unsafeStaticDeserializer(string typeName, string methodName) {
    typeName = "system.windows.markup.xamlreader" and
    methodName = ["parse", "load", "loadasync"]
    or
    typeName = "system.workflow.componentmodel.activity" and
    methodName = "load"
    or
    typeName = "memorypack.memorypackserializer" and
    methodName = "deserialize"
  }

  /**
   * Holds if creating an instance of `typeName` (lowercase, fully qualified) with
   * untrusted arguments is an unsafe deserialization.
   */
  private predicate unsafeDeserializerConstructor(string typeName) {
    typeName = "system.resources.resourcereader"
    or
    typeName = "system.resources.resxresourcereader"
  }

  /**
   * An argument to a BinaryFormatter deserialization method call, including
   * Deserialize, UnsafeDeserialize, and UnsafeDeserializeMethodResponse.
   */
  class BinaryFormatterDeserializeSink extends Sink {
    BinaryFormatterDeserializeSink() {
      exists(DataFlow::ObjectCreationNode ocn, DataFlow::CallNode cn |
        cn.getQualifier().getALocalSource() = ocn and
        objectCreationMatchesType(ocn,
          "system.runtime.serialization.formatters.binary.binaryformatter") and
        cn.getLowerCaseName() =
          ["deserialize", "unsafedeserialize", "unsafedeserializemethodresponse"] and
        cn.getAnArgument() = this
      )
    }

    override string getSinkType() { result = "call to BinaryFormatter.Deserialize" }
  }

  /**
   * An argument to an unsafe deserialization instance method call.
   * Covers SoapFormatter, ObjectStateFormatter, NetDataContractSerializer,
   * LosFormatter, DataSet, DataTable, and YamlDotNet deserializers.
   */
  class InstanceDeserializerSink extends Sink {
    string typeName;
    string methodName;

    InstanceDeserializerSink() {
      unsafeInstanceDeserializer(typeName, methodName) and
      exists(DataFlow::ObjectCreationNode ocn, DataFlow::CallNode cn |
        cn.getQualifier().getALocalSource() = ocn and
        objectCreationMatchesType(ocn, typeName) and
        cn.getLowerCaseName() = methodName and
        cn.getAnArgument() = this
      )
    }

    override string getSinkType() { result = "call to " + typeName + "." + methodName }
  }

  /**
   * An argument to an unsafe static deserialization method call.
   * Covers XamlReader, Activity.Load, and MemoryPackSerializer.
   */
  class StaticDeserializerSink extends Sink {
    string typeName;
    string methodName;

    StaticDeserializerSink() {
      unsafeStaticDeserializer(typeName, methodName) and
      exists(DataFlow::CallNode cn |
        cn.getAnArgument() = this and
        cn.getLowerCaseName() = methodName and
        exists(InvokeMemberExpr ime |
          ime = cn.getExprNode().getExpr() and
          ime.isStatic() and
          ime.getQualifier().(TypeNameExpr).getPossiblyQualifiedName() = typeName
        )
      )
    }

    override string getSinkType() {
      result = "call to [" + typeName + "]::" + methodName
    }
  }

  /**
   * An argument to a constructor of an unsafe deserializer type.
   * Covers ResourceReader and ResXResourceReader constructors.
   */
  class UnsafeConstructorSink extends Sink {
    string typeName;

    UnsafeConstructorSink() {
      unsafeDeserializerConstructor(typeName) and
      exists(DataFlow::ObjectCreationNode ocn |
        objectCreationMatchesType(ocn, typeName) and
        ocn.getAnArgument() = this
      )
    }

    override string getSinkType() { result = "constructor of " + typeName }
  }
}
