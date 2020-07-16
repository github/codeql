import python

import semmle.python.types.Builtins

class RecordedCall extends XMLElement {
  RecordedCall() { this.hasName("recorded_call") }

  string call_filename() { result = this.getAttributeValue("call_filename") }

  int call_linenum() { result = this.getAttributeValue("call_linenum").toInt() }

  int call_inst_index() { result = this.getAttributeValue("call_inst_index").toInt() }

  Call getCall() {
    // TODO: handle calls spanning multiple lines
    result.getLocation().hasLocationInfo(this.call_filename(), this.call_linenum(), _, _, _)
  }
}

class RecordedPythonCall extends RecordedCall {
  RecordedPythonCall() {
    this.hasAttribute("pythoncallee_filename") and
    this.hasAttribute("pythoncallee_linenum") and
    this.hasAttribute("pythoncallee_funcname")
  }

  string pythoncallee_filename() { result = this.getAttributeValue("pythoncallee_filename") }

  int pythoncallee_linenum() { result = this.getAttributeValue("pythoncallee_linenum").toInt() }

  string pythoncallee_funcname() { result = this.getAttributeValue("pythoncallee_funcname") }

  Function getCallee() {
    result.getLocation().hasLocationInfo(this.pythoncallee_filename(), this.pythoncallee_linenum(), _, _, _)
  }
}

class RecordedBuiltinCall extends RecordedCall {
  RecordedBuiltinCall() {
    this.hasAttribute("externalcallee_module") and
    this.hasAttribute("externalcallee_qualname") and
    this.getAttributeValue("externalcallee_is_builtin") = "True"
  }

  string externalcallee_module() { result = this.getAttributeValue("externalcallee_module") }

  string externalcallee_qualname() { result = this.getAttributeValue("externalcallee_qualname") }

  Builtin getCallee() {
    exists(Builtin mod |
      not externalcallee_module() = "None" and
      mod.isModule() and
      mod.getName() = this.externalcallee_module()
      or
      externalcallee_module() = "None" and
      mod = Builtin::builtinModule()
    |
      result = traverse_qualname(mod, this.externalcallee_qualname())
    )
  }
}

Builtin traverse_qualname(Builtin parent, string qualname) {
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
class ValidRecordedCall extends RecordedCall {
  ValidRecordedCall() {
    strictcount(this.getCall()) = 1 and
    (
      strictcount(this.(RecordedPythonCall).getCall()) = 1
      or
      strictcount(this.(RecordedBuiltinCall).getCall()) = 1
    )
  }
}
