import python
import semmle.python.types.Builtins
import semmle.python.objects.Callables
import lib.BytecodeExpr

/** The XML data for a recorded call (includes all data). */
class XMLRecordedCall extends XMLElement {
  XMLRecordedCall() { this.hasName("recorded_call") }

  /** Gets the XML data for the call. */
  XMLCall getXMLCall() { result.getParent() = this }

  /** Gets a call matching the recorded information. */
  Call getACall() { result = this.getXMLCall().getACall() }

  /** Gets the XML data for the callee. */
  XMLCallee getXMLCallee() { result.getParent() = this }

  /** Gets a python function matching the recorded information of the callee. */
  Function getAPythonCallee() { result = this.getXMLCallee().(XMLPythonCallee).getACallee() }

  /** Gets a builtin function matching the recorded information of the callee. */
  Builtin getABuiltinCallee() { result = this.getXMLCallee().(XMLExternalCallee).getACallee() }

  /** Get a different `XMLRecordedCall` with the same result-set for `getACall`. */
  XMLRecordedCall getOtherWithSameSetOfCalls() {
    // `rc` is for a different bytecode instruction on same line
    not result.getXMLCall().get_inst_index_data() = this.getXMLCall().get_inst_index_data() and
    result.getXMLCall().get_filename_data() = this.getXMLCall().get_filename_data() and
    result.getXMLCall().get_linenum_data() = this.getXMLCall().get_linenum_data() and
    // set of calls are equal
    forall(Call call | call = this.getACall() or call = result.getACall() |
      call = this.getACall() and call = result.getACall()
    )
  }

  override string toString() {
    exists(string path |
      path =
        any(File file | file.getAbsolutePath() = this.getXMLCall().get_filename_data())
            .getRelativePath()
      or
      not exists(File file |
        file.getAbsolutePath() = this.getXMLCall().get_filename_data() and
        exists(file.getRelativePath())
      ) and
      path = this.getXMLCall().get_filename_data()
    |
      result = this.getName() + ": " + path + ":" + this.getXMLCall().get_linenum_data()
    )
  }
}

/** The XML data for the call part a recorded call. */
class XMLCall extends XMLElement {
  XMLCall() { this.hasName("Call") }

  string get_filename_data() { result = this.getAChild("filename").getTextValue() }

  int get_linenum_data() { result = this.getAChild("linenum").getTextValue().toInt() }

  int get_inst_index_data() { result = this.getAChild("inst_index").getTextValue().toInt() }

  /** Gets a call that matches the recorded information. */
  Call getACall() {
    // TODO: do we handle calls spanning multiple lines?
    this.matchBytecodeExpr(result, this.getAChild("bytecode_expr").getAChild())
  }

  /** Holds if `expr` can be fully matched with `bytecode`. */
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
      //
      // I considered allowing a partial match as well. That is, if the bytecode
      // expression information only tells us `<unknown>.foo()`, and we find an AST
      // expression that matches on `.foo()`, that is good enough.
      //
      // However, we cannot assume that all calls are recorded (such as `range(10)`),
      // and we cannot assume that for all recorded calls there exists a corresponding
      // AST call (such as for list-comprehensions).
      //
      // So allowing partial matches is not safe, since we might end up matching a
      // recorded call not in the AST together with an unrecorded call visible in the
      // AST.
    )
  }
}

/** The XML data for the callee part a recorded call. */
abstract class XMLCallee extends XMLElement { }

/** The XML data for the callee part a recorded call, when the callee is a Python function. */
class XMLPythonCallee extends XMLCallee {
  XMLPythonCallee() { this.hasName("PythonCallee") }

  string get_filename_data() { result = this.getAChild("filename").getTextValue() }

  int get_linenum_data() { result = this.getAChild("linenum").getTextValue().toInt() }

  string get_funcname_data() { result = this.getAChild("funcname").getTextValue() }

  Function getACallee() {
    result.getLocation().hasLocationInfo(this.get_filename_data(), this.get_linenum_data(), _, _, _)
    or
    // if function has decorator, the call will be recorded going to the first
    result
        .getADecorator()
        .getLocation()
        .hasLocationInfo(this.get_filename_data(), this.get_linenum_data(), _, _, _)
  }
}

/** The XML data for the callee part a recorded call, when the callee is a C function or builtin. */
class XMLExternalCallee extends XMLCallee {
  XMLExternalCallee() { this.hasName("ExternalCallee") }

  string get_module_data() { result = this.getAChild("module").getTextValue() }

  string get_qualname_data() { result = this.getAChild("qualname").getTextValue() }

  Builtin getACallee() {
    exists(Builtin mod |
      mod.isModule() and
      mod.getName() = this.get_module_data()
    |
      result = traverse_qualname(mod, this.get_qualname_data())
    )
  }
}

/**
 * Helper predicate. If parent = `builtins` and qualname = `list.append`, it will
 * return the result of `builtins.list.append`.class
 */
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
 * Class of recorded calls where we can identify both the `call` and the `callee` uniquely.
 */
class IdentifiedRecordedCall extends XMLRecordedCall {
  IdentifiedRecordedCall() {
    strictcount(this.getACall()) = 1 and
    (
      strictcount(this.getAPythonCallee()) = 1
      or
      strictcount(this.getABuiltinCallee()) = 1
    )
    or
    // Handle case where the same function is called multiple times in one line, for
    // example `func(); func()`. This only works if:
    // - all the callees for these calls is the same
    // - all these calls were recorded
    //
    // without this `strictcount`, in the case `func(); func(); func()`, if 1 of the calls
    // is not recorded, we would still mark the other two recorded calls as valid
    // (which is not following the rules above). + 1 to count `this` as well.
    strictcount(this.getACall()) = strictcount(this.getOtherWithSameSetOfCalls()) + 1 and
    forex(XMLRecordedCall rc | rc = this.getOtherWithSameSetOfCalls() |
      unique(Function f | f = this.getAPythonCallee()) =
        unique(Function f | f = rc.getAPythonCallee())
      or
      unique(Builtin b | b = this.getABuiltinCallee()) =
        unique(Builtin b | b = rc.getABuiltinCallee())
    )
  }

  override string toString() {
    exists(string callee_str |
      exists(Function callee, string path | callee = this.getAPythonCallee() |
        (
          path = callee.getLocation().getFile().getRelativePath()
          or
          not exists(callee.getLocation().getFile().getRelativePath()) and
          path = callee.getLocation().getFile().getAbsolutePath()
        ) and
        callee_str =
          callee.toString() + " (" + path + ":" + callee.getLocation().getStartLine() + ")"
      )
      or
      callee_str = this.getABuiltinCallee().toString()
    |
      result = super.toString() + " --> " + callee_str
    )
  }
}

/**
 * Class of recorded calls where we cannot identify both the `call` and the `callee` uniquely.
 */
class UnidentifiedRecordedCall extends XMLRecordedCall {
  UnidentifiedRecordedCall() { not this instanceof IdentifiedRecordedCall }
}

/**
 * Recorded calls made from outside project folder, that can be ignored when evaluating
 * call-graph quality.
 */
class IgnoredRecordedCall extends XMLRecordedCall {
  IgnoredRecordedCall() {
    not exists(
      any(File file | file.getAbsolutePath() = this.getXMLCall().get_filename_data())
          .getRelativePath()
    )
  }
}

/** Provides classes for call-graph resolution by using points-to. */
module PointsToBasedCallGraph {
  /** An IdentifiedRecordedCall that can be resolved with points-to */
  class ResolvableRecordedCall extends IdentifiedRecordedCall {
    Value calleeValue;

    ResolvableRecordedCall() {
      exists(Call call, XMLCallee xmlCallee |
        call = this.getACall() and
        calleeValue.getACall() = call.getAFlowNode() and
        xmlCallee = this.getXMLCallee() and
        (
          xmlCallee instanceof XMLPythonCallee and
          (
            // normal function
            calleeValue.(PythonFunctionValue).getScope() = xmlCallee.(XMLPythonCallee).getACallee()
            or
            // class instantiation -- points-to says the call goes to the class
            calleeValue.(ClassValue).lookup("__init__").(PythonFunctionValue).getScope() =
              xmlCallee.(XMLPythonCallee).getACallee()
          )
          or
          xmlCallee instanceof XMLExternalCallee and
          calleeValue.(BuiltinFunctionObjectInternal).getBuiltin() =
            xmlCallee.(XMLExternalCallee).getACallee()
          or
          xmlCallee instanceof XMLExternalCallee and
          calleeValue.(BuiltinMethodObjectInternal).getBuiltin() =
            xmlCallee.(XMLExternalCallee).getACallee()
        )
      )
    }

    Value getCalleeValue() { result = calleeValue }
  }
}
