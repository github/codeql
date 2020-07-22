import python

abstract class XMLBytecodeExpr extends XMLElement { }

class XMLBytecodeVariableName extends XMLBytecodeExpr {
  XMLBytecodeVariableName() { this.hasName("BytecodeVariableName") }

  string get_name_data() { result = this.getAChild("name").getTextValue() }
}

class XMLBytecodeAttribute extends XMLBytecodeExpr {
  XMLBytecodeAttribute() { this.hasName("BytecodeAttribute") }

  string get_attr_name_data() { result = this.getAChild("attr_name").getTextValue() }

  XMLBytecodeExpr get_object_data() { result.getParent() = this.getAChild("object") }
}

class XMLBytecodeCall extends XMLBytecodeExpr {
  XMLBytecodeCall() { this.hasName("BytecodeCall") }

  XMLBytecodeExpr get_function_data() { result.getParent() = this.getAChild("function") }
}

class XMLBytecodeUnknown extends XMLBytecodeExpr {
  XMLBytecodeUnknown() { this.hasName("BytecodeUnknown") }
}
