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
    this.asExpr()
        .getExpr()
        .(MethodCall)
        .getBlock()
        .getAStmt()
        .getAChild*()
        .(MethodCall)
        .getMethodName() = ["noent", "nononet"]
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
    exists(Pair pair |
      pair = this.getArgument(1).asExpr().getExpr().(HashLiteral).getAKeyValuePair() and
      pair.getKey().(Literal).getValueText() = "options" and
      pair.getValue() =
        [
          trackEnableFeature(TNOENT()), trackEnableFeature(TDTDLOAD()),
          trackDisableFeature(TNONET())
        ].asExpr().getExpr()
    )
  }
}

private newtype TFeature =
  TNOENT() or
  TNONET() or
  TDTDLOAD()

class Feature extends TFeature {
  abstract int getValue();

  string toString() { result = getConstantName() }

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

private DataFlow::LocalSourceNode trackFeature(Feature f, boolean enable, TypeTracker t) {
  t.start() and
  (
    result.asExpr().getExpr().(IntegerLiteral).getValue().bitAnd(f.getValue()) = f.getValue() and
    enable = true
    or
    enable = true and
    result =
      API::getTopLevelMember("Nokogiri")
          .getMember("XML")
          .getMember("ParseOptions")
          .getMember(f.getConstantName())
          .getAUse()
    or
    enable = true and
    result =
      [API::getTopLevelMember("LibXML").getMember("XML"), API::getTopLevelMember("XML")]
          .getMember("Options")
          .getMember(f.getConstantName())
          .getAUse()
    or
    (
      result.asExpr().getExpr() instanceof BitwiseOrExpr or
      result.asExpr().getExpr() instanceof AssignBitwiseOrExpr or
      result.asExpr().getExpr() instanceof BitwiseAndExpr or
      result.asExpr().getExpr() instanceof AssignBitwiseAndExpr
    ) and
    result.asExpr().(CfgNodes::ExprNodes::OperationCfgNode).getAnOperand() =
      trackFeature(f, enable).asExpr()
    or
    result.asExpr().getExpr() instanceof ComplementExpr and
    result.asExpr().(CfgNodes::ExprNodes::OperationCfgNode).getAnOperand() =
      trackFeature(f, enable.booleanNot()).asExpr()
    or
    result =
      API::getTopLevelMember("Nokogiri")
          .getMember("XML")
          .getMember("ParseOptions")
          .getAnInstantiation() and
    result.asExpr().(CfgNodes::ExprNodes::CallCfgNode).getArgument(0) =
      trackFeature(f, enable).asExpr()
    or
    exists(CfgNodes::ExprNodes::CallCfgNode call |
      enable = true and
      call.getExpr().(MethodCall).getMethodName() = f.getConstantName().toLowerCase()
      or
      enable = false and
      call.getExpr().(MethodCall).getMethodName() = "no" + f.getConstantName().toLowerCase()
    |
      (
        result.asExpr() = call
        or
        result.flowsTo(any(DataFlow::Node n | n.asExpr() = call.getReceiver()))
      )
    )
    or
    exists(CfgNodes::ExprNodes::CallCfgNode call |
      trackFeature(f, enable).asExpr() = call.getReceiver() and
      result.asExpr() = call
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
