/**
 * Provides default sources, sinks and sanitizers for reasoning about unsafe
 * deserialization, as well as extension points for adding your own.
 */

private import codeql.ruby.AST
private import codeql.ruby.ApiGraphs
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources
private import codeql.ruby.frameworks.ActiveJob
private import codeql.ruby.frameworks.core.Module
private import codeql.ruby.frameworks.core.Kernel
private import Yaml

module UnsafeYamlDeserialization {
  /** Flow states used to distinguish whether we are using a yaml parse node or a yaml load node. */
  module FlowState {
    private newtype TState =
      TParse() or
      TLoad()

    /** A flow state used to distinguish whether we have a middle node that use `YAML.load*` or `YAML.parse*` */
    class State extends TState {
      /**
       * Gets a string representation of this state.
       */
      string toString() { result = this.getStringRepresentation() }

      /**
       * Gets a canonical string representation of this state.
       */
      string getStringRepresentation() {
        this = TParse() and result = "parse"
        or
        this = TLoad() and result = "load"
      }
    }

    /**
     * A flow state used for `YAML.parse*` methods.
     */
    class Parse extends State, TParse { }

    /**
     * A flow state used for `YAML.load*` methods.
     */
    class Load extends State, TLoad { }
  }

  /**
   * A data flow source for unsafe deserialization vulnerabilities.
   */
  abstract class Source extends DataFlow::Node {
    /** Gets a string that describes the source. */
    string describe() { result = "user-provided value" }
  }

  /**
   * A data flow sink for unsafe deserialization vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for unsafe deserialization vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /** A source of remote user input, considered as a flow source for unsafe deserialization. */
  class RemoteFlowSourceAsSource extends Source instanceof RemoteFlowSource { }

  /** A read of data from `STDIN`/`ARGV`, considered as a flow source for unsafe deserialization. */
  class StdInSource extends UnsafeYamlDeserialization::Source {
    boolean stdin;

    StdInSource() {
      this = API::getTopLevelMember(["STDIN", "ARGF"]).getAMethodCall(["gets", "read"]) and
      stdin = true
      or
      // > $stdin == STDIN
      // => true
      // but $stdin is special in that it is a global variable and not a constant. `API::getTopLevelMember` only gets constants.
      exists(DataFlow::Node dollarStdin |
        dollarStdin.asExpr().getExpr().(GlobalVariableReadAccess).getVariable().getName() = "$stdin" and
        this = dollarStdin.getALocalSource().getAMethodCall(["gets", "read"])
      ) and
      stdin = true
      or
      // ARGV.
      this.asExpr().getExpr().(GlobalVariableReadAccess).getVariable().getName() = "ARGV" and
      stdin = false
      or
      this.(Kernel::KernelMethodCall).getMethodName() = ["gets", "readline", "readlines"] and
      stdin = true
    }

    override string describe() {
      if stdin = true then result = "value from stdin" else result = "value from ARGV"
    }
  }

  /**
   * An argument in a call to `YAML.unsafe_*` and `YAML.load_stream` , considered a sink
   * for unsafe deserialization. The `YAML` module is an alias of `Psych` in
   * recent versions of Ruby.
   */
  class YamlLoadArgument extends Sink {
    YamlLoadArgument() {
      // Note: this is safe in psych/yaml >= 4.0.0.
      this = yamlLibrary().getAMethodCall("load").getArgument(0)
      or
      this =
        yamlLibrary()
            .getAMethodCall(["unsafe_load_file", "unsafe_load", "load_stream"])
            .getArgument(0)
      or
      this = yamlLibrary().getAMethodCall(["unsafe_load", "load_stream"]).getKeywordArgument("yaml")
      or
      this = yamlLibrary().getAMethodCall("unsafe_load_file").getKeywordArgument("filename")
    }
  }

  /**
   * An argument in a call to `YAML.parse*`, considered a sink for unsafe deserialization
   * if there is a call to `to_ruby` on the returned value of any Successor.
   */
  class YamlParseArgument extends Sink {
    YamlParseArgument() {
      this =
        yamlParseNode(yamlLibrary().getMethod(["parse", "parse_stream", "parse_file"]))
            .getMethod(["to_ruby", "transform"])
            .getReturn()
            .asSource()
    }
  }
}
