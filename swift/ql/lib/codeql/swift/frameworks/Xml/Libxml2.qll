/**
 * Provides models for the libxml2 library.
 */

import swift

/**
 * A call to a `libxml2` function that parses XML.
 */
class Libxml2ParseCall extends ApplyExpr {
  int xmlArg;
  int optionsArg;

  Libxml2ParseCall() {
    exists(string fname | this.getStaticTarget().getName() = fname |
      fname = "xmlCtxtUseOptions(_:_:)" and xmlArg = 0 and optionsArg = 1
      or
      fname = "xmlReadFile(_:_:_:)" and xmlArg = 0 and optionsArg = 2
      or
      fname = ["xmlReadDoc(_:_:_:_:)", "xmlReadFd(_:_:_:_:)"] and
      xmlArg = 0 and
      optionsArg = 3
      or
      fname = ["xmlCtxtReadFile(_:_:_:_:)", "xmlParseInNodeContext(_:_:_:_:_:)"] and
      xmlArg = 1 and
      optionsArg = 3
      or
      fname = ["xmlCtxtReadDoc(_:_:_:_:_:)", "xmlCtxtReadFd(_:_:_:_:_:)"] and
      xmlArg = 1 and
      optionsArg = 4
      or
      fname = "xmlReadMemory(_:_:_:_:_:)" and xmlArg = 0 and optionsArg = 4
      or
      fname = "xmlCtxtReadMemory(_:_:_:_:_:_:)" and xmlArg = 1 and optionsArg = 5
      or
      fname = "xmlReadIO(_:_:_:_:_:_:)" and xmlArg = 0 and optionsArg = 5
      or
      fname = "xmlCtxtReadIO(_:_:_:_:_:_:_:)" and xmlArg = 1 and optionsArg = 6
    )
  }

  /**
   * Gets the argument that receives the XML raw data.
   */
  Expr getXml() { result = this.getArgument(xmlArg).getExpr() }

  /**
   * Gets the argument that specifies `xmlParserOption`s.
   */
  Expr getOptions() { result = this.getArgument(optionsArg).getExpr() }
}

/**
 * An `xmlParserOption` for `libxml2` that is considered unsafe.
 */
class Libxml2BadOption extends ConcreteVarDecl {
  Libxml2BadOption() { this.getName() = ["XML_PARSE_NOENT", "XML_PARSE_DTDLOAD"] }
}
