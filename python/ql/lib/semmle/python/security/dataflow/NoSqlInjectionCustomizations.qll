/**
 * Provides default sources, sinks and sanitizers for detecting
 * "NoSql injection"
 * vulnerabilities, as well as extension points for adding your own.
 */

import python
import semmle.python.dataflow.new.DataFlow
import semmle.python.dataflow.new.RemoteFlowSources
import semmle.python.Concepts

/**
 * Provides default sources, sinks and sanitizers for detecting
 * "NoSql injection"
 * vulnerabilities, as well as extension points for adding your own.
 */
module NoSqlInjection {
  private newtype TFlowState =
    TString() or
    TDict()

  /** A flow state, tracking the structure of the data. */
  abstract class FlowState extends TFlowState {
    /** Gets a textual representation of this element. */
    abstract string toString();
  }

  /** A state where the tracked data is only a string. */
  class String extends FlowState, TString {
    override string toString() { result = "String" }
  }

  /**
   * A state where the tracked data has been converted to
   * a dictionary.
   *
   * We include cases where data represent JSON objects, so
   * it could actually still be just a string. It could
   * also contain query operators, or even JavaScript code.
   */
  class Dict extends FlowState, TDict {
    override string toString() { result = "Dict" }
  }

  /** A source allowing string inputs. */
  abstract class StringSource extends DataFlow::Node { }

  /** A source of allowing dictionaries. */
  abstract class DictSource extends DataFlow::Node { }

  /** A sink vulnerable to user controlled strings. */
  abstract class StringSink extends DataFlow::Node { }

  /** A sink vulnerable to user controlled dictionaries. */
  abstract class DictSink extends DataFlow::Node { }

  /** A data flow node where a string is converted into a dictionary. */
  abstract class StringToDictConversion extends DataFlow::Node {
    /** Gets the argument that specifies the string to be converted. */
    abstract DataFlow::Node getAnInput();

    /** Gets the resulting dictionary. */
    abstract DataFlow::Node getOutput();
  }

  /** A remote flow source considered a source of user controlled strings. */
  class RemoteFlowSourceAsStringSource extends RemoteFlowSource, StringSource { }

  /** A NoSQL query that is vulnerable to user controlled strings. */
  class NoSqlExecutionAsStringSink extends StringSink {
    NoSqlExecutionAsStringSink() {
      exists(NoSqlExecution noSqlExecution | this = noSqlExecution.getQuery() |
        noSqlExecution.vulnerableToStrings()
      )
    }
  }

  /** A NoSQL query that is vulnerable to user controlled dictionaries. */
  class NoSqlExecutionAsDictSink extends DictSink {
    NoSqlExecutionAsDictSink() {
      exists(NoSqlExecution noSqlExecution | this = noSqlExecution.getQuery() |
        noSqlExecution.interpretsDict()
      )
    }
  }

  /** A JSON decoding converts a string to a dictionary. */
  class JsonDecoding extends Decoding, StringToDictConversion {
    JsonDecoding() { this.getFormat() = "JSON" }

    override DataFlow::Node getAnInput() { result = Decoding.super.getAnInput() }

    override DataFlow::Node getOutput() { result = Decoding.super.getOutput() }
  }

  /** A NoSQL decoding interprets a string as a dictionary. */
  class NoSqlDecoding extends Decoding, StringToDictConversion {
    NoSqlDecoding() { this.getFormat() = "NoSQL" }

    override DataFlow::Node getAnInput() { result = Decoding.super.getAnInput() }

    override DataFlow::Node getOutput() { result = Decoding.super.getOutput() }
  }
}
