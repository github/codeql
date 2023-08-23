import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.Concepts

module NoSqlInjection {
  private newtype TFlowState =
    TStringInput() or
    TDictInput()

  abstract class FlowState extends TFlowState {
    abstract string toString();
  }

  class StringInput extends FlowState, TStringInput {
    override string toString() { result = "StringInput" }
  }

  class DictInput extends FlowState, TDictInput {
    override string toString() { result = "DictInput" }
  }

  abstract class StringSource extends DataFlow::Node { }

  abstract class DictSource extends DataFlow::Node { }

  abstract class StringSink extends DataFlow::Node { }

  abstract class DictSink extends DataFlow::Node { }

  abstract class StringToDictConversion extends DataFlow::Node {
    abstract DataFlow::Node getAnInput();

    abstract DataFlow::Node getOutput();
  }

  class RemoteFlowSourceAsStringSource extends RemoteFlowSource, StringSource { }

  class NoSqlQueryAsDictSink extends DictSink {
    NoSqlQueryAsDictSink() { this = any(NoSqlQuery noSqlQuery).getQuery() }
  }

  class JsonDecoding extends Decoding, StringToDictConversion {
    JsonDecoding() { this.getFormat() = "JSON" }

    override DataFlow::Node getAnInput() { result = Decoding.super.getAnInput() }

    override DataFlow::Node getOutput() { result = Decoding.super.getOutput() }
  }
}
