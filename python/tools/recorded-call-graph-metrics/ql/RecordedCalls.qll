import python
import semmle.python.types.Builtins
import semmle.python.objects.Callables
import BytecodeExpr

class XMLRecordedCall extends XMLElement {
  XMLRecordedCall() { this.hasName("recorded_call") }

  Call getCall() { result = this.getXMLCall().getCall() }

  XMLCall getXMLCall() { result.getParent() = this }

  XMLCallee getXMLCallee() { result.getParent() = this }

  /** Get a different `XMLRecordedCall` with the same result-set for `getCall`. */
  XMLRecordedCall getOtherWithSameSetOfCalls() {
    // `rc` is for a different bytecode instruction on same line
    not result.getXMLCall().get_inst_index_data() = this.getXMLCall().get_inst_index_data() and
    result.getXMLCall().get_filename_data() = this.getXMLCall().get_filename_data() and
    result.getXMLCall().get_linenum_data() = this.getXMLCall().get_linenum_data() and
    // set of calls is equal
    // 1. this.getCall() issubset result.getCall()
    not exists(Call call | call = this.getCall() | not result.getCall() = call) and
    // 2. result.getCall() issubset this.getCall()
    not exists(Call call | call = result.getCall() | not this.getCall() = call)
  }

  override string toString() {
    result = this.getName() + " (<..>/" + this.getXMLCall().get_filename_data().regexpCapture(".*/([^/]+)$", 1) + ":" + this.getXMLCall().get_linenum_data() + ")"
  }
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
      matchBytecodeExpr(expr.(Call).getFunc(), bytecode.(XMLBytecodeCall).get_function_data())
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
    or
    // if function has decorator, the call will be recorded going to the first
    result.getADecorator().getLocation().hasLocationInfo(this.get_filename_data(), this.get_linenum_data(), _, _, _)

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
 * Class of recorded calls where we can identify both the `call` and the `callee`.
 */
class IdentifiedRecordedCall extends XMLRecordedCall {
  IdentifiedRecordedCall() {
    strictcount(this.getCall()) = 1 and
    (
      strictcount(this.getXMLCallee().(XMLPythonCallee).getCallee()) = 1
      or
      strictcount(this.getXMLCallee().(XMLExternalCallee).getCallee()) = 1
    )
    or
    // Handle case where the same function is called multiple times in one line, for
    // example `func(); func()`. This only works if:
    // - all the callees for these calls is the same
    // - all these calls were recorded
    //
    // without this `strictcount`, in the case `func(); func(); func()`, if 1 of the calls
    // is not recorded, we woulld still mark the other two recorded calls as valid
    // (which is not following the rules above). + 1 to count `this` as well.
    strictcount(this.getCall()) = strictcount(this.getOtherWithSameSetOfCalls()) + 1 and
    forex(XMLRecordedCall rc |
      rc = this.getOtherWithSameSetOfCalls()
    |
      unique(Function f | f = this.getXMLCallee().(XMLPythonCallee).getCallee()) =
        unique(Function f | f = rc.getXMLCallee().(XMLPythonCallee).getCallee())
      or
      unique(Builtin b | b = this.getXMLCallee().(XMLExternalCallee).getCallee()) =
        unique(Builtin b | b = rc.getXMLCallee().(XMLExternalCallee).getCallee())
    )
  }
}

class UnidentifiedRecordedCall extends XMLRecordedCall {
  UnidentifiedRecordedCall() { not this instanceof IdentifiedRecordedCall }
}

module PointsToBasedCallGraph {
  class ResolvableRecordedCall extends IdentifiedRecordedCall {
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
