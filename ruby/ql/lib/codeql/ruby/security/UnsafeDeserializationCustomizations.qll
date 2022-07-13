/**
 * Provides default sources, sinks and sanitizers for reasoning about unsafe
 * deserialization, as well as extension points for adding your own.
 */

private import ruby
private import codeql.ruby.ApiGraphs
private import codeql.ruby.CFG
private import codeql.ruby.DataFlow
private import codeql.ruby.dataflow.RemoteFlowSources

module UnsafeDeserialization {
  /**
   * A data flow source for unsafe deserialization vulnerabilities.
   */
  abstract class Source extends DataFlow::Node { }

  /**
   * A data flow sink for unsafe deserialization vulnerabilities.
   */
  abstract class Sink extends DataFlow::Node { }

  /**
   * A sanitizer for unsafe deserialization vulnerabilities.
   */
  abstract class Sanitizer extends DataFlow::Node { }

  /**
   * Additional taint steps for "unsafe deserialization" vulnerabilities.
   */
  predicate isAdditionalTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    base64DecodeTaintStep(fromNode, toNode)
  }

  /** A source of remote user input, considered as a flow source for unsafe deserialization. */
  class RemoteFlowSourceAsSource extends Source {
    RemoteFlowSourceAsSource() { this instanceof RemoteFlowSource }
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
   * An argument in a call to `YAML.load`, considered a sink for unsafe
   * deserialization.
   */
  class YamlLoadArgument extends Sink {
    YamlLoadArgument() {
      this = API::getTopLevelMember("YAML").getAMethodCall("load").getArgument(0)
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

  private string getAKnownOjModeName(boolean isSafe) {
    result = ["compat", "custom", "json", "null", "rails", "strict", "wab"] and isSafe = true
    or
    result = "object" and isSafe = false
  }

  private predicate isOjModePair(CfgNodes::ExprNodes::PairCfgNode p, string modeValue) {
    p.getKey().getConstantValue().isStringlikeValue("mode") and
    exists(DataFlow::LocalSourceNode symbolLiteral, DataFlow::Node value |
      symbolLiteral.asExpr().getExpr().getConstantValue().isSymbol(modeValue) and
      symbolLiteral.flowsTo(value) and
      value.asExpr() = p.getValue()
    )
  }

  /**
   * A node representing a hash that contains the key `:mode`.
   */
  private class OjOptionsHashWithModeKey extends DataFlow::Node {
    private string modeValue;

    OjOptionsHashWithModeKey() {
      exists(DataFlow::LocalSourceNode options |
        options.flowsTo(this) and
        isOjModePair(options.asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair(),
          modeValue)
      )
    }

    /**
     * Holds if this hash node contains a `:mode` key whose value is one known
     * to be `isSafe` with untrusted data.
     */
    predicate hasKnownMode(boolean isSafe) { modeValue = getAKnownOjModeName(isSafe) }

    /**
     * Holds if this hash node contains a `:mode` key whose value is one of the
     * `Oj` modes known to be safe to use with untrusted data.
     */
    predicate hasSafeMode() { this.hasKnownMode(true) }
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
    DataFlow::Node getValue() {
      result.asExpr() =
        this.getArgument(0).asExpr().(CfgNodes::ExprNodes::AssignExprCfgNode).getRhs()
    }
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
        arg.(OjOptionsHashWithModeKey).hasKnownMode(isSafe)
        or
        isOjModePair(arg.asExpr(), getAKnownOjModeName(isSafe))
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
            setOpts.getValue().(OjOptionsHashWithModeKey).hasSafeMode()
          )
        )
      )
    }
  }

  /**
   * `Base64.decode64` propagates taint from its argument to its return value.
   */
  predicate base64DecodeTaintStep(DataFlow::Node fromNode, DataFlow::Node toNode) {
    exists(DataFlow::CallNode callNode |
      callNode =
        API::getTopLevelMember("Base64")
            .getAMethodCall(["decode64", "strict_decode64", "urlsafe_decode64"])
    |
      fromNode = callNode.getArgument(0) and
      toNode = callNode
    )
  }
}
