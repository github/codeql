import python

abstract class XMLBytecodeExpr extends XMLElement { }

class XMLBytecodeConst extends XMLBytecodeExpr {
  XMLBytecodeConst() { this.hasName("BytecodeConst") }

  string get_value_data_raw() { result = this.getAChild("value").getTextValue() }
}

class XMLBytecodeVariableName extends XMLBytecodeExpr {
  XMLBytecodeVariableName() { this.hasName("BytecodeVariableName") }

  string get_name_data() { result = this.getAChild("name").getTextValue() }
}

class XMLBytecodeAttribute extends XMLBytecodeExpr {
  XMLBytecodeAttribute() { this.hasName("BytecodeAttribute") }

  string get_attr_name_data() { result = this.getAChild("attr_name").getTextValue() }

  XMLBytecodeExpr get_object_data() { result.getParent() = this.getAChild("object") }
}

class XMLBytecodeSubscript extends XMLBytecodeExpr {
  XMLBytecodeSubscript() { this.hasName("BytecodeSubscript") }

  XMLBytecodeExpr get_key_data() { result.getParent() = this.getAChild("key") }

  XMLBytecodeExpr get_object_data() { result.getParent() = this.getAChild("object") }
}

class XMLBytecodeTuple extends XMLBytecodeExpr {
  XMLBytecodeTuple() { this.hasName("BytecodeTuple") }

  XMLBytecodeExpr get_elements_data(int index) {
    result = this.getAChild("elements").getChild(index)
  }
}

class XMLBytecodeList extends XMLBytecodeExpr {
  XMLBytecodeList() { this.hasName("BytecodeList") }

  XMLBytecodeExpr get_elements_data(int index) {
    result = this.getAChild("elements").getChild(index)
  }
}

class XMLBytecodeCall extends XMLBytecodeExpr {
  XMLBytecodeCall() { this.hasName("BytecodeCall") }

  XMLBytecodeExpr get_function_data() { result.getParent() = this.getAChild("function") }
}

class XMLBytecodeUnknown extends XMLBytecodeExpr {
  XMLBytecodeUnknown() { this.hasName("BytecodeUnknown") }

  string get_opname_data() { result = this.getAChild("opname").getTextValue() }
}

class XMLBytecodeMakeFunction extends XMLBytecodeExpr {
  XMLBytecodeMakeFunction() { this.hasName("BytecodeMakeFunction") }

  XMLBytecodeExpr get_qualified_name_data() {
    result.getParent() = this.getAChild("qualified_name")
  }
}

class XMLSomethingInvolvingScaryBytecodeJump extends XMLBytecodeExpr {
  XMLSomethingInvolvingScaryBytecodeJump() { this.hasName("SomethingInvolvingScaryBytecodeJump") }

  string get_opname_data() { result = this.getAChild("opname").getTextValue() }
}
