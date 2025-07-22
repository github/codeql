/**
 * Provides default sources, sinks and sanitizers for reasoning about
 * unsafe deserialization vulnerabilities, as well as extension points for
 * adding your own.
 */

private import semmle.code.powershell.dataflow.DataFlow
import semmle.code.powershell.ApiGraphs
private import semmle.code.powershell.dataflow.flowsources.FlowSources
private import semmle.code.powershell.Cfg

module UnsafeDeserialization {
  /**
   * A data flow source for SQL-injection vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the type of this flow source. */
    abstract string getSourceType();
  }

  /**
   * A data flow sink for SQL-injection vulnerabilities.
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

  class BinaryFormatterDeserializeSink extends Sink {
    BinaryFormatterDeserializeSink() {
      exists(DataFlow::ObjectCreationNode ocn, DataFlow::CallNode cn | 
        cn.getQualifier().getALocalSource() = ocn and 
        ocn.getExprNode().getExpr().(CallExpr).getAnArgument().getValue().asString() = "System.Runtime.Serialization.Formatters.Binary.BinaryFormatter" and
        cn.getLowerCaseName() = "deserialize" and
        cn.getAnArgument() = this
    )
    }

    override string getSinkType() { result = "call to BinaryFormatter.Deserialize" }

  }
}
