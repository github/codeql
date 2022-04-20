/**
 * Provides modeling for common XML libraries.
 */

private import codeql.ruby.Concepts
private import codeql.ruby.AST
private import codeql.ruby.DataFlow
private import codeql.ruby.typetracking.TypeTracker
private import codeql.ruby.ApiGraphs
private import codeql.ruby.controlflow.CfgNodes as CfgNodes

private class NokogiriXmlParserCall extends XmlParserCall::Range, DataFlow::CallNode {
  NokogiriXmlParserCall() {
    this =
      [
        API::getTopLevelMember("Nokogiri").getMember("XML"),
        API::getTopLevelMember("Nokogiri").getMember("XML").getMember("Document"),
        API::getTopLevelMember("Nokogiri")
            .getMember("XML")
            .getMember("SAX")
            .getMember("Parser")
            .getInstance()
      ].getAMethodCall("parse")
  }

  override DataFlow::Node getInput() { result = this.getArgument(0) }

  override predicate externalEntitiesEnabled() {
    this.getArgument(3) =
      [trackEnableFeature(TNOENT()), trackEnableFeature(TDTDLOAD()), trackDisableFeature(TNONET())]
    or
    // calls to methods that enable/disable features in a block argument passed to this parser call.
    // For example:
    // ```ruby
    // doc.parse(...) { |options| options.nononet; options.noent }
    // ```
    this.asExpr()
        .getExpr()
        .(MethodCall)
        .getBlock()
        .getAStmt()
        .getAChild*()
        .(MethodCall)
        .getMethodName() = ["noent", "dtdload", "nononet"]
  }
}

private class LibXmlRubyXmlParserCall extends XmlParserCall::Range, DataFlow::CallNode {
  LibXmlRubyXmlParserCall() {
    this =
      [API::getTopLevelMember("LibXML").getMember("XML"), API::getTopLevelMember("XML")]
          .getMember(["Document", "Parser"])
          .getAMethodCall(["file", "io", "string"])
  }

  override DataFlow::Node getInput() { result = this.getArgument(0) }

  override predicate externalEntitiesEnabled() {
    exists(CfgNodes::ExprNodes::PairCfgNode pair |
      pair =
        this.getArgument(1).asExpr().(CfgNodes::ExprNodes::HashLiteralCfgNode).getAKeyValuePair() and
      pair.getKey().getConstantValue().isStringlikeValue("options") and
      pair.getValue() =
        [
          trackEnableFeature(TNOENT()), trackEnableFeature(TDTDLOAD()),
          trackDisableFeature(TNONET())
        ].asExpr()
    )
  }
}

private newtype TFeature =
  TNOENT() or
  TNONET() or
  TDTDLOAD()

/**
 * A representation of XML features that can be enabled or disabled.
 * - `TNOENT`: Enables substitution of external entities.
 * - `TNONET`: Disables network access.
 * - `TDTDLOAD`: Disables loading of DTDs.
 */
class Feature extends TFeature {
  /**
   * Gets the bitmask value for this feature.
   */
  abstract int getValue();

  /**
   * Gets the string representation of this feature.
   */
  string toString() { result = this.getConstantName() }

  /**
   * Gets the name of this feature.
   */
  abstract string getConstantName();
}

private class FeatureNOENT extends Feature, TNOENT {
  override int getValue() { result = 2 }

  override string getConstantName() { result = "NOENT" }
}

private class FeatureNONET extends Feature, TNONET {
  override int getValue() { result = 2048 }

  override string getConstantName() { result = "NONET" }
}

private class FeatureDTDLOAD extends Feature, TDTDLOAD {
  override int getValue() { result = 4 }

  override string getConstantName() { result = "DTDLOAD" }
}

private API::Node parseOptionsModule() {
  result = API::getTopLevelMember("Nokogiri").getMember("XML").getMember("ParseOptions")
  or
  result =
    API::getTopLevelMember("LibXML").getMember("XML").getMember("Parser").getMember("Options")
  or
  result = API::getTopLevelMember("XML").getMember("Parser").getMember("Options")
}

private predicate bitWiseAndOr(CfgNodes::ExprNodes::OperationCfgNode operation) {
  operation.getExpr() instanceof BitwiseAndExpr or
  operation.getExpr() instanceof AssignBitwiseAndExpr or
  operation.getExpr() instanceof BitwiseOrExpr or
  operation.getExpr() instanceof AssignBitwiseOrExpr
}

private DataFlow::LocalSourceNode trackFeature(Feature f, boolean enable, TypeTracker t) {
  t.start() and
  (
    // An integer literal with the feature-bit enabled/disabled
    exists(int bitValue |
      bitValue = result.asExpr().getExpr().(IntegerLiteral).getValue().bitAnd(f.getValue())
    |
      if bitValue = 0 then enable = false else enable = true
    )
    or
    // Use of a constant f
    enable = true and
    result = parseOptionsModule().getMember(f.getConstantName()).getAUse()
    or
    // Treat `&`, `&=`, `|` and `|=` operators as if they preserve the on/off states
    // of their operands. This is an overapproximation but likely to work well in practice
    // because it makes little sense to explicitly set a feature to both `on` and `off` in the
    // same code.
    exists(CfgNodes::ExprNodes::OperationCfgNode operation |
      bitWiseAndOr(operation) and
      operation = result.asExpr() and
      operation.getAnOperand() = trackFeature(f, enable).asExpr()
    )
    or
    // The complement operator toggles a feature from enabled to disabled and vice-versa
    result.asExpr().getExpr() instanceof ComplementExpr and
    result.asExpr().(CfgNodes::ExprNodes::OperationCfgNode).getAnOperand() =
      trackFeature(f, enable.booleanNot()).asExpr()
    or
    // Nokogiri has a ParseOptions class that is a wrapper around the bit-fields and
    // provides methods for querying and updating the fields.
    result =
      API::getTopLevelMember("Nokogiri")
          .getMember("XML")
          .getMember("ParseOptions")
          .getAnInstantiation() and
    result.asExpr().(CfgNodes::ExprNodes::CallCfgNode).getArgument(0) =
      trackFeature(f, enable).asExpr()
    or
    // The Nokogiri ParseOptions class has methods for setting/unsetting features.
    // The method names are the lowercase variants of the constant names, with a "no"
    // prefix for unsetting a feature.
    exists(CfgNodes::ExprNodes::CallCfgNode call |
      enable = true and
      call.getExpr().(MethodCall).getMethodName() = f.getConstantName().toLowerCase()
      or
      enable = false and
      call.getExpr().(MethodCall).getMethodName() = "no" + f.getConstantName().toLowerCase()
    |
      (
        // these methods update the receiver
        result.flowsTo(any(DataFlow::Node n | n.asExpr() = call.getReceiver()))
        or
        // in addition they return the (updated) receiver to allow chaining calls.
        result.asExpr() = call
      )
    )
  )
  or
  exists(TypeTracker t2 | result = trackFeature(f, enable, t2).track(t2, t))
}

private DataFlow::Node trackFeature(Feature f, boolean enable) {
  trackFeature(f, enable, TypeTracker::end()).flowsTo(result)
}

private DataFlow::Node trackEnableFeature(Feature f) { result = trackFeature(f, true) }

private DataFlow::Node trackDisableFeature(Feature f) { result = trackFeature(f, false) }
