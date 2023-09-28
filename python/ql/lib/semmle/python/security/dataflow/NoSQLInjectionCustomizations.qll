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
    TStringInput() or
    TInterpretedStringInput()

  /** A flow state, tracking the structure of the input. */
  abstract class FlowState extends TFlowState {
    /** Gets a textual representation of this element. */
    abstract string toString();
  }

  /** A state where input is only a string. */
  class StringInput extends FlowState, TStringInput {
    override string toString() { result = "StringInput" }
  }

  /**
   * A state where input is a string that has been interpreted.
   * For instance, it could have been turned into a dictionary,
   * or evaluated as javascript code.
   */
  class InterpretedStringInput extends FlowState, TInterpretedStringInput {
    override string toString() { result = "InterpretedStringInput" }
  }

  /** A source allowing string inputs. */
  abstract class StringSource extends DataFlow::Node { }

  /** A source of interpreted strings. */
  abstract class InterpretedStringSource extends DataFlow::Node { }

  /** A sink vulnerable to user controlled strings. */
  abstract class StringSink extends DataFlow::Node { }

  /** A sink vulnerable to user controlled interpreted strings. */
  abstract class InterpretedStringSink extends DataFlow::Node { }

  /** A data flow node where a string is being interpreted. */
  abstract class StringInterpretation extends DataFlow::Node {
    /** Gets the argument that specifies the string to be interpreted. */
    abstract DataFlow::Node getAnInput();

    /** Gets the result of interpreting the string. */
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

  /** A NoSQL query that is vulnerable to user controlled InterpretedStringionaries. */
  class NoSqlExecutionAsInterpretedStringSink extends InterpretedStringSink {
    NoSqlExecutionAsInterpretedStringSink() { this = any(NoSqlExecution noSqlExecution).getQuery() }
  }

  /** A JSON decoding converts a string to a Dictionary. */
  class JsonDecoding extends Decoding, StringInterpretation {
    JsonDecoding() { this.getFormat() = "JSON" }

    override DataFlow::Node getAnInput() { result = Decoding.super.getAnInput() }

    override DataFlow::Node getOutput() { result = Decoding.super.getOutput() }
  }

  /** A NoSQL decoding interprets a string. */
  class NoSqlDecoding extends Decoding, StringInterpretation {
    NoSqlDecoding() { this.getFormat() = "NoSQL" }

    override DataFlow::Node getAnInput() { result = Decoding.super.getAnInput() }

    override DataFlow::Node getOutput() { result = Decoding.super.getOutput() }
  }
}
