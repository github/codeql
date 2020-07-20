import python
import semmle.python.types.Builtins
import semmle.python.objects.Callables
import BytecodeExpr

class XMLRecordedCall extends XMLElement {
  XMLRecordedCall() { this.hasName("recorded_call") }

  Call getCall() { result = this.getXMLCall().getCall() }

  XMLCall getXMLCall() { result.getParent() = this }

  XMLCallee getXMLCallee() { result.getParent() = this }
}

class XMLCall extends XMLElement {
  XMLCall() { this.hasName("Call") }

  string get_filename_data() { result = this.getAChild("filename").getTextValue() }

  int get_linenum_data() { result = this.getAChild("linenum").getTextValue().toInt() }

  int get_inst_index_data() { result = this.getAChild("inst_index").getTextValue().toInt() }

  Call getCall() {
    // TODO: do we handle calls spanning multiple lines?
    this.matchBytecodeExpr(result, this.getAChild("bytecode_expr").getAChild())
  }

  private predicate matchBytecodeExpr(Expr expr, XMLBytecodeExpr bytecode) {
    exists(Call parent_call, XMLBytecodeCall parent_bytecode_call |
      parent_call
          .getLocation()
          .hasLocationInfo(this.get_filename_data(), this.get_linenum_data(), _, _, _) and
      parent_call.getAChildNode*() = expr and
      parent_bytecode_call.getParent() = this.getAChild("bytecode_expr") and
      parent_bytecode_call.getAChild*() = bytecode
    ) and
    (
      expr.(Name).getId() = bytecode.(XMLBytecodeVariableName).get_name_data()
      or
      expr.(Attribute).getName() = bytecode.(XMLBytecodeAttribute).get_attr_name_data() and
      matchBytecodeExpr(expr.(Attribute).getObject(),
        bytecode.(XMLBytecodeAttribute).get_object_data())
      or
      matchBytecodeExpr(expr.(Call).getFunc(),
        bytecode.(XMLBytecodeCall).get_function_data())
    )
  }
}

abstract class XMLCallee extends XMLElement { }

class XMLPythonCallee extends XMLCallee {
  XMLPythonCallee() { this.hasName("PythonCallee") }

  string get_filename_data() { result = this.getAChild("filename").getTextValue() }

  int get_linenum_data() { result = this.getAChild("linenum").getTextValue().toInt() }

  string get_funcname_data() { result = this.getAChild("funcname").getTextValue() }

  Function getCallee() {
    result.getLocation().hasLocationInfo(this.get_filename_data(), this.get_linenum_data(), _, _, _)
  }
}

class XMLExternalCallee extends XMLCallee {
  XMLExternalCallee() { this.hasName("ExternalCallee") }

  string get_module_data() { result = this.getAChild("module").getTextValue() }

  string get_qualname_data() { result = this.getAChild("qualname").getTextValue() }

  Builtin getCallee() {
    exists(Builtin mod |
      not this.get_module_data() = "None" and
      mod.isModule() and
      mod.getName() = this.get_module_data()
      or
      this.get_module_data() = "None" and
      mod = Builtin::builtinModule()
    |
      result = traverse_qualname(mod, this.get_qualname_data())
    )
  }
}

private Builtin traverse_qualname(Builtin parent, string qualname) {
  not qualname = "__objclass__" and
  not qualname.matches("%.%") and
  result = parent.getMember(qualname)
  or
  qualname.matches("%.%") and
  exists(string before_dot, string after_dot, Builtin intermediate_parent |
    qualname = before_dot + "." + after_dot and
    not before_dot = "__objclass__" and
    intermediate_parent = parent.getMember(before_dot) and
    result = traverse_qualname(intermediate_parent, after_dot)
  )
}

/**
 * Class of recorded calls where we can uniquely identify both the `call` and the `callee`.
 */
class ValidRecordedCall extends XMLRecordedCall {
  ValidRecordedCall() {
    strictcount(this.getCall()) = 1 and
    (
      strictcount(this.getXMLCallee().(XMLPythonCallee).getCallee()) = 1
      or
      strictcount(this.getXMLCallee().(XMLExternalCallee).getCallee()) = 1
    )
  }
}

class InvalidRecordedCall extends XMLRecordedCall {
  InvalidRecordedCall() { not this instanceof ValidRecordedCall }
}

module PointsToBasedCallGraph {
  class ResolvableRecordedCall extends ValidRecordedCall {
    Value calleeValue;

    ResolvableRecordedCall() {
      exists(Call call, XMLCallee xmlCallee |
        call = this.getCall() and
        calleeValue.getACall() = call.getAFlowNode() and
        xmlCallee = this.getXMLCallee() and
        (
          xmlCallee instanceof XMLPythonCallee and
          calleeValue.(PythonFunctionValue).getScope() = xmlCallee.(XMLPythonCallee).getCallee()
          or
          xmlCallee instanceof XMLExternalCallee and
          calleeValue.(BuiltinFunctionObjectInternal).getBuiltin() =
            xmlCallee.(XMLExternalCallee).getCallee()
          or
          xmlCallee instanceof XMLExternalCallee and
          calleeValue.(BuiltinMethodObjectInternal).getBuiltin() =
            xmlCallee.(XMLExternalCallee).getCallee()
        )
      )
    }

    Value getCalleeValue() { result = calleeValue }
  }
}
