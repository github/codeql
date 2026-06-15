import python

abstract class XmlBytecodeExpr extends XmlElement { }

class XmlBytecodeConst extends XmlBytecodeExpr {
  XmlBytecodeConst() { this.hasName("BytecodeConst") }

  string get_value_data_raw() { result = this.getAChild("value").getTextValue() }
}

class XmlBytecodeVariableName extends XmlBytecodeExpr {
  XmlBytecodeVariableName() { this.hasName("BytecodeVariableName") }

  string get_name_data() { result = this.getAChild("name").getTextValue() }
}

class XmlBytecodeAttribute extends XmlBytecodeExpr {
  XmlBytecodeAttribute() { this.hasName("BytecodeAttribute") }

  string get_attr_name_data() { result = this.getAChild("attr_name").getTextValue() }

  XmlBytecodeExpr get_object_data() { result.getParent() = this.getAChild("object") }
}

class XmlBytecodeSubscript extends XmlBytecodeExpr {
  XmlBytecodeSubscript() { this.hasName("BytecodeSubscript") }

  XmlBytecodeExpr get_key_data() { result.getParent() = this.getAChild("key") }

  XmlBytecodeExpr get_object_data() { result.getParent() = this.getAChild("object") }
}

class XmlBytecodeTuple extends XmlBytecodeExpr {
  XmlBytecodeTuple() { this.hasName("BytecodeTuple") }

  XmlBytecodeExpr get_elements_data(int index) {
    result = this.getAChild("elements").getChild(index)
  }
}

class XmlBytecodeList extends XmlBytecodeExpr {
  XmlBytecodeList() { this.hasName("BytecodeList") }

  XmlBytecodeExpr get_elements_data(int index) {
    result = this.getAChild("elements").getChild(index)
  }
}

class XmlBytecodeCall extends XmlBytecodeExpr {
  XmlBytecodeCall() { this.hasName("BytecodeCall") }

  XmlBytecodeExpr get_function_data() { result.getParent() = this.getAChild("function") }
}

class XmlBytecodeUnknown extends XmlBytecodeExpr {
  XmlBytecodeUnknown() { this.hasName("BytecodeUnknown") }

  string get_opname_data() { result = this.getAChild("opname").getTextValue() }
}

class XmlBytecodeMakeFunction extends XmlBytecodeExpr {
  XmlBytecodeMakeFunction() { this.hasName("BytecodeMakeFunction") }

  XmlBytecodeExpr get_qualified_name_data() {
    result.getParent() = this.getAChild("qualified_name")
  }
}

class XmlSomethingInvolvingScaryBytecodeJump extends XmlBytecodeExpr {
  XmlSomethingInvolvingScaryBytecodeJump() { this.hasName("SomethingInvolvingScaryBytecodeJump") }

  string get_opname_data() { result = this.getAChild("opname").getTextValue() }
}
