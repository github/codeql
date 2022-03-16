import python

abstract class XmlBytecodeExpr extends XMLElement { }

/** DEPRECATED: Alias for XmlBytecodeExpr */
deprecated class XMLBytecodeExpr = XmlBytecodeExpr;

class XmlBytecodeConst extends XmlBytecodeExpr {
  XmlBytecodeConst() { this.hasName("BytecodeConst") }

  string get_value_data_raw() { result = this.getAChild("value").getTextValue() }
}

/** DEPRECATED: Alias for XmlBytecodeConst */
deprecated class XMLBytecodeConst = XmlBytecodeConst;

class XmlBytecodeVariableName extends XmlBytecodeExpr {
  XmlBytecodeVariableName() { this.hasName("BytecodeVariableName") }

  string get_name_data() { result = this.getAChild("name").getTextValue() }
}

/** DEPRECATED: Alias for XmlBytecodeVariableName */
deprecated class XMLBytecodeVariableName = XmlBytecodeVariableName;

class XmlBytecodeAttribute extends XmlBytecodeExpr {
  XmlBytecodeAttribute() { this.hasName("BytecodeAttribute") }

  string get_attr_name_data() { result = this.getAChild("attr_name").getTextValue() }

  XmlBytecodeExpr get_object_data() { result.getParent() = this.getAChild("object") }
}

/** DEPRECATED: Alias for XmlBytecodeAttribute */
deprecated class XMLBytecodeAttribute = XmlBytecodeAttribute;

class XmlBytecodeSubscript extends XmlBytecodeExpr {
  XmlBytecodeSubscript() { this.hasName("BytecodeSubscript") }

  XmlBytecodeExpr get_key_data() { result.getParent() = this.getAChild("key") }

  XmlBytecodeExpr get_object_data() { result.getParent() = this.getAChild("object") }
}

/** DEPRECATED: Alias for XmlBytecodeSubscript */
deprecated class XMLBytecodeSubscript = XmlBytecodeSubscript;

class XmlBytecodeTuple extends XmlBytecodeExpr {
  XmlBytecodeTuple() { this.hasName("BytecodeTuple") }

  XmlBytecodeExpr get_elements_data(int index) {
    result = this.getAChild("elements").getChild(index)
  }
}

/** DEPRECATED: Alias for XmlBytecodeTuple */
deprecated class XMLBytecodeTuple = XmlBytecodeTuple;

class XmlBytecodeList extends XmlBytecodeExpr {
  XmlBytecodeList() { this.hasName("BytecodeList") }

  XmlBytecodeExpr get_elements_data(int index) {
    result = this.getAChild("elements").getChild(index)
  }
}

/** DEPRECATED: Alias for XmlBytecodeList */
deprecated class XMLBytecodeList = XmlBytecodeList;

class XmlBytecodeCall extends XmlBytecodeExpr {
  XmlBytecodeCall() { this.hasName("BytecodeCall") }

  XmlBytecodeExpr get_function_data() { result.getParent() = this.getAChild("function") }
}

/** DEPRECATED: Alias for XmlBytecodeCall */
deprecated class XMLBytecodeCall = XmlBytecodeCall;

class XmlBytecodeUnknown extends XmlBytecodeExpr {
  XmlBytecodeUnknown() { this.hasName("BytecodeUnknown") }

  string get_opname_data() { result = this.getAChild("opname").getTextValue() }
}

/** DEPRECATED: Alias for XmlBytecodeUnknown */
deprecated class XMLBytecodeUnknown = XmlBytecodeUnknown;

class XmlBytecodeMakeFunction extends XmlBytecodeExpr {
  XmlBytecodeMakeFunction() { this.hasName("BytecodeMakeFunction") }

  XmlBytecodeExpr get_qualified_name_data() {
    result.getParent() = this.getAChild("qualified_name")
  }
}

/** DEPRECATED: Alias for XmlBytecodeMakeFunction */
deprecated class XMLBytecodeMakeFunction = XmlBytecodeMakeFunction;

class XmlSomethingInvolvingScaryBytecodeJump extends XmlBytecodeExpr {
  XmlSomethingInvolvingScaryBytecodeJump() { this.hasName("SomethingInvolvingScaryBytecodeJump") }

  string get_opname_data() { result = this.getAChild("opname").getTextValue() }
}

/** DEPRECATED: Alias for XmlSomethingInvolvingScaryBytecodeJump */
deprecated class XMLSomethingInvolvingScaryBytecodeJump = XmlSomethingInvolvingScaryBytecodeJump;
