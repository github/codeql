/**
 * Provides class and predicates to track external data that
 * may represent malicious XML objects.
 */

private import python
private import semmle.python.dataflow.new.DataFlow
private import semmle.python.Concepts
private import semmle.python.ApiGraphs

private module SaxBasedParsing {
  /**
   * A call to the `setFeature` method on a XML sax parser.
   *
   * See https://docs.python.org/3.10/library/xml.sax.reader.html#xml.sax.xmlreader.XMLReader.setFeature
   */
  private class SaxParserSetFeatureCall extends DataFlow::MethodCallNode {
    SaxParserSetFeatureCall() {
      this =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("make_parser")
            .getReturn()
            .getMember("setFeature")
            .getACall()
    }

    // The keyword argument names does not match documentation. I checked (with Python
    // 3.9.5) that the names used here actually works.
    DataFlow::Node getFeatureArg() { result in [this.getArg(0), this.getArgByName("name")] }

    DataFlow::Node getStateArg() { result in [this.getArg(1), this.getArgByName("state")] }
  }

  /** Gets a back-reference to the `setFeature` state argument `arg`. */
  private DataFlow::TypeTrackingNode saxParserSetFeatureStateArgBacktracker(
    DataFlow::TypeBackTracker t, DataFlow::Node arg
  ) {
    t.start() and
    arg = any(SaxParserSetFeatureCall c).getStateArg() and
    result = arg.getALocalSource()
    or
    exists(DataFlow::TypeBackTracker t2 |
      result = saxParserSetFeatureStateArgBacktracker(t2, arg).backtrack(t2, t)
    )
  }

  /** Gets a back-reference to the `setFeature` state argument `arg`. */
  DataFlow::LocalSourceNode saxParserSetFeatureStateArgBacktracker(DataFlow::Node arg) {
    result = saxParserSetFeatureStateArgBacktracker(DataFlow::TypeBackTracker::end(), arg)
  }

  /**
   * Gets a reference to a XML sax parser that has `feature_external_ges` turned on.
   *
   * See https://docs.python.org/3/library/xml.sax.handler.html#xml.sax.handler.feature_external_ges
   */
  private DataFlow::Node saxParserWithFeatureExternalGesTurnedOn(DataFlow::TypeTracker t) {
    t.start() and
    exists(SaxParserSetFeatureCall call |
      call.getFeatureArg() =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("handler")
            .getMember("feature_external_ges")
            .getAUse() and
      saxParserSetFeatureStateArgBacktracker(call.getStateArg())
          .asExpr()
          .(BooleanLiteral)
          .booleanValue() = true and
      result = call.getObject()
    )
    or
    exists(DataFlow::TypeTracker t2 |
      t = t2.smallstep(saxParserWithFeatureExternalGesTurnedOn(t2), result)
    ) and
    // take account of that we can set the feature to False, which makes the parser safe again
    not exists(SaxParserSetFeatureCall call |
      call.getObject() = result and
      call.getFeatureArg() =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("handler")
            .getMember("feature_external_ges")
            .getAUse() and
      saxParserSetFeatureStateArgBacktracker(call.getStateArg())
          .asExpr()
          .(BooleanLiteral)
          .booleanValue() = false
    )
  }

  /**
   * Gets a reference to a XML sax parser that has `feature_external_ges` turned on.
   *
   * See https://docs.python.org/3/library/xml.sax.handler.html#xml.sax.handler.feature_external_ges
   */
  DataFlow::Node saxParserWithFeatureExternalGesTurnedOn() {
    result = saxParserWithFeatureExternalGesTurnedOn(DataFlow::TypeTracker::end())
  }

  /**
   * A call to the `parse` method on a SAX XML parser.
   */
  private class XMLSaxInstanceParsing extends DataFlow::MethodCallNode, XML::XMLParsing::Range {
    XMLSaxInstanceParsing() {
      this =
        API::moduleImport("xml")
            .getMember("sax")
            .getMember("make_parser")
            .getReturn()
            .getMember("parse")
            .getACall()
    }

    override DataFlow::Node getAnInput() { result in [this.getArg(0), this.getArgByName("source")] }

    override predicate vulnerableTo(XML::XMLParsingVulnerabilityKind kind) {
      // always vuln to these
      (kind.isBillionLaughs() or kind.isQuadraticBlowup())
      or
      // can be vuln to other things if features has been turned on
      this.getObject() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() {
      // note: the output of parsing with SAX is that the content handler gets the
      // data... but we don't currently model this (it's not trivial to do, and won't
      // really give us any value, at least not as of right now).
      none()
    }
  }

  /**
   * A call to either `parse` or `parseString` from `xml.sax` module.
   *
   * See:
   * - https://docs.python.org/3.10/library/xml.sax.html#xml.sax.parse
   * - https://docs.python.org/3.10/library/xml.sax.html#xml.sax.parseString
   */
  private class XMLSaxParsing extends DataFlow::MethodCallNode, XML::XMLParsing::Range {
    XMLSaxParsing() {
      this =
        API::moduleImport("xml").getMember("sax").getMember(["parse", "parseString"]).getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // parseString
          this.getArgByName("string"),
          // parse
          this.getArgByName("source"),
        ]
    }

    override predicate vulnerableTo(XML::XMLParsingVulnerabilityKind kind) {
      // always vuln to these
      (kind.isBillionLaughs() or kind.isQuadraticBlowup())
      or
      // can be vuln to other things if features has been turned on
      this.getObject() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() {
      // note: the output of parsing with SAX is that the content handler gets the
      // data... but we don't currently model this (it's not trivial to do, and won't
      // really give us any value, at least not as of right now).
      none()
    }
  }

  /**
   * A call to the `parse` or `parseString` methods from `xml.dom.minidom` or `xml.dom.pulldom`.
   *
   * Both of these modules are based on SAX parsers.
   */
  private class XMLDomParsing extends DataFlow::CallCfgNode, XML::XMLParsing::Range {
    XMLDomParsing() {
      this =
        API::moduleImport("xml")
            .getMember("dom")
            .getMember(["minidom", "pulldom"])
            .getMember(["parse", "parseString"])
            .getACall()
    }

    override DataFlow::Node getAnInput() {
      result in [
          this.getArg(0),
          // parseString
          this.getArgByName("string"),
          // minidom.parse
          this.getArgByName("file"),
          // pulldom.parse
          this.getArgByName("stream_or_string"),
        ]
    }

    DataFlow::Node getParserArg() { result in [this.getArg(1), this.getArgByName("parser")] }

    override predicate vulnerableTo(XML::XMLParsingVulnerabilityKind kind) {
      this.getParserArg() = saxParserWithFeatureExternalGesTurnedOn() and
      (kind.isXxe() or kind.isDtdRetrieval())
      or
      (kind.isBillionLaughs() or kind.isQuadraticBlowup())
    }

    override predicate mayExecuteInput() { none() }

    override DataFlow::Node getOutput() { result = this }
  }
}
