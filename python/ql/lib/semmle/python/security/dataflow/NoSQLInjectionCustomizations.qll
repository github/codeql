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
    TDictInput()

  /** A flow state, tracking the structure of the input. */
  abstract class FlowState extends TFlowState {
    /** Gets a textual representation of this element. */
    abstract string toString();
  }

  /** A state where input is only a string. */
  class StringInput extends FlowState, TStringInput {
    override string toString() { result = "StringInput" }
  }

  /** A state where input is a dictionary. */
  class DictInput extends FlowState, TDictInput {
    override string toString() { result = "DictInput" }
  }

  /** A source allowing string inputs. */
  abstract class StringSource extends DataFlow::Node { }

  /** A source allowing dictionary inputs. */
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
  class NoSqlQueryAsStringSink extends StringSink {
    NoSqlQueryAsStringSink() {
      exists(NoSqlQuery noSqlQuery | this = noSqlQuery.getQuery() |
        noSqlQuery.vulnerableToStrings()
      )
    }
  }

  /** A NoSQL query that is vulnerable to user controlled dictionaries. */
  class NoSqlQueryAsDictSink extends DictSink {
    NoSqlQueryAsDictSink() { this = any(NoSqlQuery noSqlQuery).getQuery() }
  }

  /** A JSON decoding converts a string to a dictionary. */
  class JsonDecoding extends Decoding, StringToDictConversion {
    JsonDecoding() { this.getFormat() in ["JSON", "NoSQL"] }

    override DataFlow::Node getAnInput() { result = Decoding.super.getAnInput() }

    override DataFlow::Node getOutput() { result = Decoding.super.getOutput() }
  }
}
