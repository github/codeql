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

module UnsafeDeserialization {
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
  class StdInSource extends UnsafeDeserialization::Source {
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
   * An argument in a call to `Marshal.load` or `Marshal.restore`, considered a
   * sink for unsafe deserialization.
   */
  class MarshalLoadOrRestoreArgument extends Sink {
    MarshalLoadOrRestoreArgument() {
      this = API::getTopLevelMember("Marshal").getAMethodCall(["load", "restore"]).getArgument(0)
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
      this = yamlNode().getAMethodCall("load").getArgument(0)
      or
      this =
        yamlNode().getAMethodCall(["unsafe_load_file", "unsafe_load", "load_stream"]).getArgument(0)
      or
      this = yamlNode().getAMethodCall(["unsafe_load", "load_stream"]).getKeywordArgument("yaml")
      or
      this = yamlNode().getAMethodCall("unsafe_load_file").getKeywordArgument("filename")
    }
  }

  private API::Node yamlNode() { result = API::getTopLevelMember(["YAML", "Psych"]) }

  /**
   * An argument in a call to `YAML.parse*`, considered a sink for unsafe deserialization
   * if there is a call to `to_ruby` on the returned value.
   */
  class YamlParseArgument extends Sink {
    YamlParseArgument() {
      this =
        yamlNode().getAMethodCall(["parse", "parse_stream", "parse_file"]).getAMethodCall("to_ruby")
    }
  }

  /**
   * An argument in a call to `JSON.load` or `JSON.restore`, considered a sink
   * for unsafe deserialization.
   */
  class JsonLoadArgument extends Sink {
    JsonLoadArgument() {
      this = API::getTopLevelMember("JSON").getAMethodCall(["load", "restore"]).getArgument(0)
    }
  }

  /**
   * The first argument in a call to `Hash.from_trusted_xml`, considered as a
   * sink for unsafe deserialization.
   */
  class HashFromTrustedXmlArgument extends Sink {
    HashFromTrustedXmlArgument() {
      this = API::getTopLevelMember("Hash").getAMethodCall("from_trusted_xml").getArgument(0)
    }
  }

  /**
   * Oj/Ox common code to establish whether a deserialization mode is defined.
   */
  private predicate isModePair(CfgNodes::ExprNodes::PairCfgNode p, string modeValue) {
    p.getKey().getConstantValue().isStringlikeValue("mode") and
    DataFlow::exprNode(p.getValue()).getALocalSource().getConstantValue().isSymbol(modeValue)
  }

  /**
   * A node representing a hash that contains the key `:mode`.
   */
  private class OptionsHashWithModeKey extends DataFlow::Node {
    private string modeValue;

    OptionsHashWithModeKey() {
      exists(DataFlow::LocalSourceNode options |
        options.flowsTo(this) and
        isModePair(options.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair(),
          modeValue)
      )
    }

    /**
     * Holds if this hash node contains the `:mode`
     */
    predicate hasKnownMode(string mode) { modeValue = mode }
  }

  /**
   * Unsafe deserialization utilizing the Oj gem
   * See: https://github.com/ohler55/oj
   */
  private string getAKnownOjModeName(boolean isSafe) {
    result = ["compat", "custom", "json", "null", "rails", "strict", "wab"] and isSafe = true
    or
    result = "object" and isSafe = false
  }

  /**
   * A call node that sets `Oj.default_options`.
   *
   * ```rb
   * Oj.default_options = { allow_blank: true, mode: :compat }
   * ```
   */
  private class SetOjDefaultOptionsCall extends DataFlow::CallNode {
    SetOjDefaultOptionsCall() {
      this = API::getTopLevelMember("Oj").getAMethodCall("default_options=")
    }

    /**
     * Gets the value being assigned to `Oj.default_options`.
     */
    DataFlow::Node getValue() { result = this.getArgument(0) }
  }

  /**
   * A call to `Oj.load`.
   */
  private class OjLoadCall extends DataFlow::CallNode {
    OjLoadCall() { this = API::getTopLevelMember("Oj").getAMethodCall("load") }

    /**
     * Holds if this call to `Oj.load` includes an explicit options hash
     * argument that sets the mode to one that is known to be `isSafe`.
     */
    predicate hasExplicitKnownMode(boolean isSafe) {
      exists(DataFlow::Node arg, int i | i >= 1 and arg = this.getArgument(i) |
        arg.(OptionsHashWithModeKey).hasKnownMode(getAKnownOjModeName(isSafe))
        or
        isModePair(arg.asExpr(), getAKnownOjModeName(isSafe))
      )
    }
  }

  /**
   * An argument in a call to `Oj.load` where the mode is `:object` (which is
   * the default), considered a sink for unsafe deserialization.
   */
  class UnsafeOjLoadArgument extends Sink {
    UnsafeOjLoadArgument() {
      exists(OjLoadCall ojLoad |
        this = ojLoad.getArgument(0) and
        // Exclude calls that explicitly pass a safe mode option.
        not ojLoad.hasExplicitKnownMode(true) and
        (
          // Sinks to include:
          // - Calls with an explicit, unsafe mode option.
          ojLoad.hasExplicitKnownMode(false)
          or
          // - Calls with no explicit mode option, unless there exists a call
          // anywhere to set the default options to a known safe mode.
          not ojLoad.hasExplicitKnownMode(_) and
          not exists(SetOjDefaultOptionsCall setOpts |
            setOpts.getValue().(OptionsHashWithModeKey).hasKnownMode(getAKnownOjModeName(true))
          )
        )
      )
    }
  }

  /**
   * The first argument in a call to `Oj.object_load`, always considered as a
   * sink for unsafe deserialization. (global and local mode options are ignored)
   */
  private class OjObjectLoadArgument extends Sink {
    OjObjectLoadArgument() {
      this = API::getTopLevelMember("Oj").getAMethodCall("object_load").getArgument(0)
    }
  }

  /**
   * Unsafe deserialization utilizing the Ox gem
   * See: https://github.com/ohler55/ox
   */
  private string getAKnownOxModeName(boolean isSafe) {
    result = ["generic", "limited", "hash", "hash_no_attrs"] and isSafe = true
    or
    result = "object" and isSafe = false
  }

  /**
   * A call node that sets `Ox.default_options`.
   *
   * ```rb
   * Ox.default_options = { mode: :limited, effort: :tolerant }
   * ```
   */
  private class SetOxDefaultOptionsCall extends DataFlow::CallNode {
    SetOxDefaultOptionsCall() {
      this = API::getTopLevelMember("Ox").getAMethodCall("default_options=")
    }

    /**
     * Gets the value being assigned to `Ox.default_options`.
     */
    DataFlow::Node getValue() { result = this.getArgument(0) }
  }

  /**
   * A call to `Ox.load`.
   */
  private class OxLoadCall extends DataFlow::CallNode {
    OxLoadCall() { this = API::getTopLevelMember("Ox").getAMethodCall("load") }

    /**
     * Holds if this call to `Ox.load` includes an explicit options hash
     * argument that sets the mode to one that is known to be `isSafe`.
     */
    predicate hasExplicitKnownMode(boolean isSafe) {
      exists(DataFlow::Node arg, int i | i >= 1 and arg = this.getArgument(i) |
        arg.(OptionsHashWithModeKey).hasKnownMode(getAKnownOxModeName(isSafe))
        or
        isModePair(arg.asExpr(), getAKnownOxModeName(isSafe))
      )
    }
  }

  /**
   * An argument in a call to `Ox.load` where the mode is `:object` (not the default),
   * considered a sink for unsafe deserialization.
   */
  class UnsafeOxLoadArgument extends Sink {
    UnsafeOxLoadArgument() {
      exists(OxLoadCall oxLoad |
        this = oxLoad.getArgument(0) and
        // Exclude calls that explicitly pass a safe mode option.
        not oxLoad.hasExplicitKnownMode(true) and
        (
          // Sinks to include:
          // - Calls with an explicit, unsafe mode option.
          oxLoad.hasExplicitKnownMode(false)
          or
          // - Calls with no explicit mode option and there exists a call
          // anywhere to set the default options to an unsafe mode (object).
          not oxLoad.hasExplicitKnownMode(_) and
          exists(SetOxDefaultOptionsCall setOpts |
            setOpts.getValue().(OptionsHashWithModeKey).hasKnownMode(getAKnownOxModeName(false))
          )
        )
      )
    }
  }

  /**
   * The first argument in a call to `Ox.parse_obj`, always considered as a
   * sink for unsafe deserialization.
   */
  class OxParseObjArgument extends Sink {
    OxParseObjArgument() {
      this = API::getTopLevelMember("Ox").getAMethodCall("parse_obj").getArgument(0)
    }
  }

  /**
   * An argument in a call to `Plist.parse_xml` where `marshal` is `true` (which is
   * the default), considered a sink for unsafe deserialization.
   */
  class UnsafePlistParsexmlArgument extends Sink {
    UnsafePlistParsexmlArgument() {
      exists(DataFlow::CallNode plistParseXml |
        plistParseXml = API::getTopLevelMember("Plist").getAMethodCall("parse_xml")
      |
        this = [plistParseXml.getArgument(0), plistParseXml.getKeywordArgument("filename_or_xml")] and
        (
          plistParseXml.getKeywordArgument("marshal").getConstantValue().isBoolean(true)
          or
          plistParseXml.getNumberOfArguments() = 1
        )
      )
    }
  }
}
