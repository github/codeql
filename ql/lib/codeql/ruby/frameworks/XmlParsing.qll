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
    this.getArgument(3) = trackNoEnt()
    or
    this.asExpr()
        .getExpr()
        .(MethodCall)
        .getBlock()
        .getAStmt()
        .getAChild*()
        .(MethodCall)
        .getMethodName() = "noent"
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
      trackNoEnt().asExpr().getExpr() = pair.getValue()
    )
  }
}

private DataFlow::LocalSourceNode trackNoEnt(TypeTracker t) {
  t.start() and
  (
    result.asExpr().getExpr().(IntegerLiteral).getValue().bitAnd(2) = 2
    or
    result =
      API::getTopLevelMember("Nokogiri")
          .getMember("XML")
          .getMember("ParseOptions")
          .getMember("NOENT")
          .getAUse()
    or
    result =
      [API::getTopLevelMember("LibXML").getMember("XML"), API::getTopLevelMember("XML")]
          .getMember("Options")
          .getMember("NOENT")
          .getAUse()
    or
    result.asExpr().getExpr() instanceof BitwiseOrExpr and
    result.asExpr().(CfgNodes::ExprNodes::OperationCfgNode).getAnOperand() = trackNoEnt().asExpr()
    or
    result =
      API::getTopLevelMember("Nokogiri")
          .getMember("XML")
          .getMember("ParseOptions")
          .getAnInstantiation() and
    result.asExpr().(CfgNodes::ExprNodes::CallCfgNode).getArgument(0) = trackNoEnt().asExpr()
    or
    exists(CfgNodes::ExprNodes::CallCfgNode call |
      call.getExpr().(MethodCall).getMethodName() = "noent" and
      (
        result.asExpr() = call
        or
        result.flowsTo(any(DataFlow::Node n | n.asExpr() = call.getReceiver()))
      )
    )
    or
    exists(CfgNodes::ExprNodes::CallCfgNode call |
      trackNoEnt().asExpr() = call.getReceiver() and
      result.asExpr() = call
    )
  )
  or
  exists(TypeTracker t2 | result = trackNoEnt(t2).track(t2, t))
}

private DataFlow::Node trackNoEnt() { trackNoEnt(TypeTracker::end()).flowsTo(result) }
