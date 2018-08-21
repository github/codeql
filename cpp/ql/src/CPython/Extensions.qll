import cpp
import CPython.ArgParse


/* Root class of all 'C' objects */
abstract class CObject extends Element {

    abstract string getTrapID();
}



/**
A Python class is an instance of PyTypeObject.
*/
class PythonClass extends Variable, CObject {

    PythonClass() {
        getType().hasName("PyTypeObject")
    }

    /** Gets the function table (if any) associated with the class. */
    PythonFunctionTable getFunctionTable() {
        exists(ClassAggregateLiteral l, TypedefType tt, Field f |
             l = getInitializer().getExpr()
             and tt.hasName("PyTypeObject")
             and f.hasName("tp_methods")
             and f.getDeclaringType() = tt.getBaseType()
             and result.getAnAccess() = l.getFieldExpr(f)
        )
    }

    /** Gets the getset table (if any) associated with the class. */
    PythonGetSetTable getGetSetTable() {
        exists(ClassAggregateLiteral l, TypedefType tt, Field f |
             l = getInitializer().getExpr()
             and tt.hasName("PyTypeObject")
             and f.hasName("tp_getset")
             and f.getDeclaringType() = tt.getBaseType()
             and result.getAnAccess() = l.getFieldExpr(f)
        )
    }

     /** Gets the Python module (if any) containing this class. */
    PythonModule getModule() {
        result = getFile()
    }

    Expr getSlot(string name) {
        exists(ClassAggregateLiteral l, TypedefType tt, Field f |
            l = getInitializer().getExpr()
            and tt.hasName("PyTypeObject")
            and f.hasName(name)
            and f.getDeclaringType() = tt.getBaseType()
            and l.getFieldExpr(f) = result
        )
     }

    string getTpName() {
        exists(StringLiteral lit |
            lit = this.getSlot("tp_name") |
            result = lit.getValue()
        )
    }

    Expr getSizeOf() {
        exists(ClassAggregateLiteral l, TypedefType tt, Field f |
            l = getInitializer().getExpr()
            and tt.hasName("PyTypeObject")
            and f.hasName("tp_basicsize")
            and f.getDeclaringType() = tt.getBaseType()
            and l.getFieldExpr(f) = result
        )
    }

    override string getTrapID() {
         /* This needs to be kept in sync with extractor-python/semmle/passes/type.py */
         result = "C_type$" + this.getTpName()
    }

    /** Gets a textual representation of this element. */
    override string toString() {
        result = Variable.super.toString()
    }
}

/**
A call to a Py_InitModule function. These functions register a Python module.
*/
class Py_InitModuleCall extends FunctionCall {
  Py_InitModuleCall() {
    // Py_InitModule itself is actually a macro, ultimately defined to be something like Py_InitModule4_64.
    getTarget().getName().matches("Py\\_Init%")
  }

  /** Gets the name of the module being registered. */
  string getModuleName() {
    result = getArgument(0).(StringLiteral).getValue()
  }

  /** Gets the function table associated with this Py_InitModule call. */
  PythonFunctionTable getFunctionTable() {
    exists(VariableAccess va |
      va = getArgument(1)
      and result = va.getTarget()
    )
  }
}

/**
A Python module, represented by the file containing an initialising call for it.
*/
class PythonModule extends File {
  PythonModule() {
     exists(PythonModuleDefinition def | def.getFile() = this)
     or
     exists(FunctionCall c | c.getFile() = this |
         c.getTarget().getName().matches("Py\\_InitModule%")
     )
  }

  /** Gets a Python class that is in this module. */
  PythonClass getAClass() {
    result.getFile() = this
  }

  /** Gets the function table associated with the module. */
  PythonFunctionTable getFunctionTable() {
    result = this.getDefinition().getFunctionTable()
    or
    exists(FunctionCall c | c.getFile() = this |
        c.getTarget().getName().matches("Py\\_InitModule%") and
        c.getAnArgument() = result.getAnAccess()
    )
  }

  /** Gets the Py_InitModule call that was used to register the module. */
  //private
  PythonModuleDefinition getDefinition() {
    result.getFile() = this
  }

  /** Gets the name of the module. */
  string getModuleName() {
    result = this.getDefinition().getModuleName()
    or
    exists(FunctionCall c |c.getFile() = this |
        c.getTarget().getName().matches("Py\\_InitModule%") and
        c.getArgument(0).getValue() = result
    )
  }
}

/**
The function table for a Python module.
*/
class PythonFunctionTable extends Variable {

    PythonFunctionTable() {
        not(this instanceof Parameter)
        and exists(ArrayType at | at = getType().getUnspecifiedType() and at.getBaseType().hasName("PyMethodDef"))
    }

  /** Gets an entry in the table. */
  PythonFunctionTableEntry getATableEntry() {
    result = getInitializer().getExpr().getAChild()
    and exists(result.getRegisteredFunctionName())
  }

  /** Gets the class (if any) for which this is the function table. */
  PythonClass getClass() {
    result.getFunctionTable() = this
    or
    exists(FunctionAccess getattr, Call find_method |
        result.getSlot("tp_getattr") = getattr |
        find_method.getEnclosingFunction() = getattr.getTarget() and
        find_method.getArgument(0) = this.getAnAccess()
    )
  }

  /** Gets the module (if any) for which this is the function table. */
  PythonModule getModule() {
    result.getFunctionTable() = this
  }
}

/**
The getset table for a Python module or type
*/
class PythonGetSetTable extends Variable {

    PythonGetSetTable() {
        not(this instanceof Parameter) and
        exists(ArrayType at | at = getType() and at.getBaseType().hasName("PyGetSetDef"))
    }

    /** Gets the class (if any) for which this is the function table. */
    PythonClass getClass() {
        result.getGetSetTable() = this
    }

    /** Gets an entry in the table. */
    PythonGetSetTableEntry getATableEntry() {
        result = getInitializer().getExpr().getAChild()
        and exists(result.getRegisteredPropertyName())
    }

}

class PythonModuleDefinition extends Variable {

    PythonModuleDefinition() {
        not(this instanceof Parameter)
        and exists(Type moddef_t | moddef_t = this.getType() and moddef_t.hasName("PyModuleDef"))
    }

  /** Gets the function table (if any) associated with the class. */
  PythonFunctionTable getFunctionTable() {
    exists(ClassAggregateLiteral l, Type moddef_t, Field f |
      l = this.getInitializer().getExpr()
      and moddef_t.hasName("PyModuleDef")
      and f.hasName("m_methods")
      and f.getDeclaringType() = moddef_t
      and result.getAnAccess() = l.getFieldExpr(f)
    )
  }

  /** Gets the function table (if any) associated with the class. */
  string getModuleName() {
    exists(ClassAggregateLiteral l, Type moddef_t, Field f |
      l = this.getInitializer().getExpr()
      and moddef_t.hasName("PyModuleDef")
      and f.hasName("m_name")
      and f.getDeclaringType() = moddef_t
      and result = l.getFieldExpr(f).getValue()
    )
  }

}

/** A special (__xxx__) method implemented in C
*/
class PythonSpecialMethod extends Function  {

    PythonSpecialMethod() {
        class_special_methods(_, _, this)
    }

    PythonClass getClass() {
        class_special_methods(result, _, this)
    }

    string getPyName() {
        class_special_methods(_, result, this)
    }

}

predicate class_special_methods(PythonClass cls, string name, Function method) {

    exists(string slot, FunctionAccess fa |
           special_methods(name, slot) and cls.getSlot(slot) = fa and fa.getTarget() = method
           or
           number_methods(name, slot) and
           exists(ClassAggregateLiteral l, TypedefType tt, Field f |
                  l = cls.getSlot("tp_as_number")
                  and tt.hasName("PyNumberMethods")
                  and f.hasName(slot)
                  and f.getDeclaringType() = tt.getBaseType()
                  and l.getFieldExpr(f) = fa
                  and fa.getTarget() = method
          )
           or
           sequence_methods(name, slot) and
           exists(ClassAggregateLiteral l, TypedefType tt, Field f |
                  l = cls.getSlot("tp_as_sequence")
                  and tt.hasName("PySequenceMethods")
                  and f.hasName(slot)
                  and f.getDeclaringType() = tt.getBaseType()
                  and l.getFieldExpr(f) = fa
                  and fa.getTarget() = method
          )
           or
           mapping_methods(name, slot) and
           exists(ClassAggregateLiteral l, TypedefType tt, Field f |
                  l = cls.getSlot("tp_as_mapping")
                  and tt.hasName("PyMappingMethods")
                  and f.hasName(slot)
                  and f.getDeclaringType() = tt.getBaseType()
                  and l.getFieldExpr(f) = fa
                  and fa.getTarget() = method
          )
    )
}


predicate special_methods(string name, string slot_name) {
    name = "__getattr__" and slot_name = "tp_getattr"
    or
    name = "__hash__" and slot_name = "tp_hash"
    or
    name = "__call__" and slot_name = "tp_call"
    or
    name = "__str__" and slot_name = "tp_str"
    or
    name = "__getattribute__" and slot_name = "tp_getattro"
    or
    name = "__setattro__" and slot_name = "tp_setattro"
    or
    name = "__iter__" and slot_name = "tp_iter"
    or
    name = "__descr_get__" and slot_name = "tp_descr_get"
    or
    name = "__descr_set__" and slot_name = "tp_descr_set"
}

predicate number_methods(string name, string slot_name) {
    name = "__add__" and slot_name = "nb_add"
    or
    name = "__sub__" and slot_name = "nb_subtract"
    or
    name = "__mul__" and slot_name = "nb_multiply"
    or
    name = "__mod__" and slot_name = "nb_remainder"
    or
    name = "__pow__" and slot_name = "nb_power"
    or
    name = "__neg__" and slot_name = "nb_negative"
    or
    name = "__pos__" and slot_name = "nb_positive"
    or
    name = "__abs__" and slot_name = "nb_absolute"
    or
    name = "__bool__" and slot_name = "nb_bool"
    or
    name = "__bool__" and slot_name = "nb_bool"
    or
    name = "__invert__" and slot_name = "nb_invert"
    or
    name = "__lshift__" and slot_name = "nb_lshift"
    or
    name = "__rshift__" and slot_name = "nb_rshift"
    or
    name = "__and__" and slot_name = "nb_and"
    or
    name = "__xor__" and slot_name = "nb_xor"
    or
    name = "__or__" and slot_name = "nb_or"
    or
    name = "__int__" and slot_name = "nb_int"
    or
    name = "__long__" and slot_name = "nb_long"
    or
    name = "__float__" and slot_name = "nb_float"
    or
    name = "__iadd__" and slot_name = "nb_inplace_add"
    or
    name = "__isub__" and slot_name = "nb_inplace_subtract"
    or
    name = "__imul__" and slot_name = "nb_inplace_multiply"
    or
    name = "__imod__" and slot_name = "nb_inplace_remainder"
    or
    name = "__ilshift__" and slot_name = "nb_inplace_lshift"
    or
    name = "__irshift__" and slot_name = "nb_inplace_rshift"
    or
    name = "__iand__" and slot_name = "nb_inplace_and"
    or
    name = "__ixor__" and slot_name = "nb_inplace_xor"
    or
    name = "__ior__" and slot_name = "nb_inplace_or"
    or
    name = "__index__" and slot_name = "nb_index"
}

predicate sequence_methods(string name, string slot_name) {
    name = "__len__" and slot_name = "sq_length"
    or
    name = "__add__" and slot_name = "sq_concat"
    or
    name = "__mul__" and slot_name = "sq_repeat"
    or
    name = "__getitem__" and slot_name = "sq_item"
    or
    name = "__setitem__" and slot_name = "sq_ass_item"
    or
    name = "__contains__" and slot_name = "sq_contains"
    or
    name = "__iadd__" and slot_name = "sq_inplace_concat"
    or
    name = "__imul__" and slot_name = "sq_inplace_repeat"
}

predicate mapping_methods(string name, string slot_name) {
    name = "__len__" and slot_name = "mp_length"
    or
    name = "__getitem__" and slot_name = "mp_subscript"
    or
    name = "__setitem__" and slot_name = "mp_ass_subscript"
}


/**
An entry in the getset table for a Python class.
This is the C code item that corresponds 1-to-1 with the Python-level property
*/
class PythonGetSetTableEntry extends AggregateLiteral {

    PythonGetSetTableEntry() {
        this.getUnderlyingType().hasName("PyGetSetDef")
        and
        this.getChild(0) instanceof StringLiteral
    }

    Function getGetter() {
        exists(FunctionAccess fa | fa = getChild(1) and result = fa.getTarget())
    }

    Function getSetter() {
        exists(FunctionAccess fa | fa = getChild(2) and result = fa.getTarget())
    }

    StringLiteral getRegisteredPropertyName() {
        result = this.getChild(0)
    }

    PythonGetSetTable getTable() {
        result.getATableEntry() = this
    }
}

/**
An entry in the function table for a Python class or module.
This is the C code item that corresponds 1-to-1 with the Python-level function.
*/
class PythonFunctionTableEntry extends AggregateLiteral {

  PythonFunctionTableEntry() {
      this.getUnderlyingType().hasName("PyMethodDef")
      and
      this.getChild(0) instanceof StringLiteral
  }

  /** Gets the doc string to be associated with the function being registered. */
  string getDocString() {
    result = getChild(3).(StringLiteral).getValueText()
  }

  /** Gets the flags for the function being registered. */
  int getFlags() {
    result = getChild(2).getValue().toInt()
  }

  /** Gets the function being registered. */
  Function getFunction() {
    exists(FunctionAccess fa | fa = getChild(1) and result = fa.getTarget())
  }

  /** Gets the module containing the function table. */
  PythonModule getModule() {
    result = getTable().getModule()
  }

  /** Gets the name with which the function should be referenced from Python. */
  StringLiteral getRegisteredFunctionName() {
      result = this.getChild(0)
  }

  /** Gets the function table containing this entry. */
  PythonFunctionTable getTable() {
    result.getATableEntry() = this
  }

  /** Gets a flag associated with this function. */
  string getAFlag() {
    exists(int f | f = this.getFlags() |
      (f % 2 = 1 and result = "METH_VARARGS")
      or ((f / 2) % 2 = 1 and result = "METH_KEYWORDS")
      or ((f / 4) % 2 = 1 and result = "METH_NOARGS")
      or ((f / 8) % 2 = 1 and result = "METH_O")
      or ((f / 16) % 2 = 1 and result = "METH_CLASS")
      or ((f / 32) % 2 = 1 and result = "METH_STATIC")
      or ((f / 64) % 2 = 1 and result = "METH_COEXIST")
    )
  }

}

library class PythonBuildReturnCall extends FunctionCall {
  PythonBuildReturnCall() {
    exists(string name | name = getTarget().getName() |
      name = "Py_BuildValue"
      or name = "Py_VaBuildValue"
    )
  }

  string getFormatString() {
    result = getArgument(0).(StringLiteral).getValue()
  }

}

/**
An extension function for Python (written in C).
*/
class PythonExtensionFunction extends Function {
  PythonExtensionFunction() {
    exists(PythonFunctionTableEntry e | e.getFunction() = this)
    and exists(getAParameter())
  }

  /** Gets a function table entry registering this function. */
  PythonFunctionTableEntry getATableEntry() {
    result.getFunction() = this
  }

}

class TypedPythonExtensionProperty extends PythonGetSetTableEntry, CObject {

    override
    string toString() {
        result = PythonGetSetTableEntry.super.toString()
    }

    PythonClass getPropertyType() {
        result = py_return_type(this.getGetter())
    }

    private string trapClass() {
        result = this.getClass().getTrapID()
    }

    override string getTrapID() {
        result = this.trapClass() + "$" + this.getPyName()
    }

    string getPyName() {
        result = this.getRegisteredPropertyName().getValue()
    }

    /** Gets the class containing this function. */
    PythonClass getClass() {
        result = this.getTable().getClass()
    }

}


/* An extension function for Python (written in C); Python facing aspect */
abstract class TypedPythonExtensionFunction extends PythonFunctionTableEntry, CObject {

    override Location getLocation() {
        result = this.getRegisteredFunctionName().getLocation()
    }

    override
    string toString() {
        result = "MethodDef " + this.getRegisteredFunctionName().getValue()
    }

    abstract PythonClass getArgumentType(int index);

    abstract predicate argumentIsOptional(int index);

    abstract predicate argumentIsKwOnly(int index);

    PythonExtensionFunction getCode() {
        result.getATableEntry() = this
    }

    predicate isMethod() {
        exists(this.getTable().getClass()) and not this.getAFlag() = "METH_STATIC"
    }

    int c_index(int index) {
        index in [0..20] and result in [-1..20]
        and
        (if this.isMethod() then
            result = index - 1
         else
            result = index
        )
    }

    string getPyName() {
        result = this.getRegisteredFunctionName().getValue()
    }

    PythonClass getReturnType() {
        result = py_return_type(this.getCode())
    }


    /** Gets the module containing this function. */
    override PythonModule getModule() {
        result = getTable().getModule()
    }

    /** Gets the class containing this function. */
    PythonClass getClass() {
        result = getTable().getClass()
    }

    //private
    string trapModule() {
        result = this.getModule().getModuleName()
    }

    //private
    string trapClass() {
        result = this.getClass().getTrapID()
    }

    /* A globally unique name for use in trap files.
     */
    override string getTrapID() {
        result = "C_builtin_function_or_method$" + this.trapModule() + "." + this.getPyName()
        or
        result = this.trapClass() + "$" + this.getPyName()
    }

}

predicate src_dest_pair(Element src, ControlFlowNode dest) {
     exists(LocalScopeVariable v, ControlFlowNode def |
            definitionUsePair(v, def, dest) and
            exprDefinition(v, def, src) and
            not exists(AddressOfExpr addr | addr.getOperand() = v.getAnAccess())
     )
     or
     exists(Parameter p | dest = p.getAnAccess() and not definitionUsePair(_, _, dest) and src = p)
}

cached
predicate local_flows_to(Element src, ControlFlowNode dest) {
   not unreachable(src) and not unreachable(dest) and
    (src = dest
     or
     src_dest_pair(src, dest)
     or
     exists(Element mid | local_flows_to(src, mid) and src_dest_pair(mid, dest))
    )
}

PythonClass py_return_type(Function f) {
    exists(ReturnStmt ret |
        ret.getEnclosingFunction() = f and
        result = python_type(ret.getExpr()) and
        not ret.getExpr().getValue() = "0"
    )
    or
    exists(Macro m | m.getAnInvocation().getEnclosingFunction() = f and m.getName() = "Py_RETURN_NONE" and result.getTpName() = "NoneType")
    or
    exists(Macro m | m.getAnInvocation().getEnclosingFunction() = f and m.getName() = "Py_RETURN_TRUE" and result.getTpName() = "bool")
    or
    exists(Macro m | m.getAnInvocation().getEnclosingFunction() = f and m.getName() = "Py_RETURN_FALSE" and result.getTpName() = "bool")
}

PythonClass python_type_from_size(Expr e) {
    exists(Type t, string name |
        t = e.getUnderlyingType().(PointerType).getBaseType() and name = t.getName() and name.matches("Py\\_%Object") |
        exists(PythonClass cls | cls.getSizeOf().getValueText() = "sizeof(" + t.getName() + ")" |
            result = cls and not result.getTpName() = "int" and not result.getTpName() = "bool"
        )
    )
}

predicate py_bool(Expr e) {
    exists(MacroInvocation mi, string name |
        mi.getExpr() = e and name = mi.getMacroName() |
        name = "Py_False" or name = "Py_True"
    )
}

PythonClass python_type_from_name(Expr e) {
    exists(Type t, string name |
        t = e.getUnderlyingType().(PointerType).getBaseType() and name = t.getName() |
        name = "PyBytesObject" and result.getTpName() = "bytes"
        or
        name = "PyTupleObject" and result.getTpName() = "tuple"
        or
        name = "PyLongObject" and result.getTpName() = "int" and not py_bool(e)
        or
        name = "PyIntObject" and result.getTpName() = "int" and not py_bool(e)
        or
        name = "PyStringObject" and result.getTpName() = "str" and cpython_major_version() = 2
        or
        name = "PyStringObject" and result.getTpName() = "bytes" and cpython_major_version() = 3
        or
        name = "PyUnicodeObject" and result.getTpName() = "unicode" and cpython_major_version() = 2
        or
        name = "PyUnicodeObject" and result.getTpName() = "str" and cpython_major_version() = 3
    )
}

PythonClass python_type(Expr e) {
    result = python_type_from_size(e)
    or
    result = python_type_from_name(e)
    or
    call_to_new(e, result)
    or
    exists(Element src | result = python_type(src) and local_flows_to(src, e))
    or
    result = type_from_build_value(e)
    or
    result = type_from_call(e)
    or
    py_bool(e) and result.getTpName() = "bool"
    or
    call_to_type(e, result)
    or
    exists(MacroInvocation mi |
        mi.getExpr() = e and mi.getMacroName() = "Py_None" |
        result.getTpName() = "NoneType"
    )
}

predicate build_value_function(Function f) {
    f.getName().regexpMatch("_?Py_(Va)?BuildValue(_SizeT)?")
}

PythonClass type_from_build_value(Expr e) {
    exists(FunctionCall c |
        c = e |
        build_value_function(c.getTarget()) and
        result = type_from_build_value_code(c.getArgument(0).getValue())
    )
}

PythonClass type_from_call(Expr e) {
    exists(Function f |
        not build_value_function(f) and
        /* Do not type to infer return type of the interpreter */
        not f.getName().matches("PyEval%") and
        f = e.(FunctionCall).getTarget() and
        result = py_return_type(f)
    )
    or
    exists(Function f |
        f = e.(FunctionCall).getTarget() and
        result.getTpName() = "dict"
        |
        f.hasName("PyEval_GetBuiltins") or
        f.hasName("PyEval_GetGlobals") or
        f.hasName("PyEval_GetLocals")
   )
}

PythonClass type_from_build_value_code(string s) {
    exists(FunctionCall c | c.getArgument(0).getValue() = s)
    and
    (result = type_from_simple_code(s)
     or
     result.getTpName() = "dict" and s.charAt(0) = "{"
     or
     result.getTpName() = "tuple" and not exists(type_from_simple_code(s)) and not s.charAt(0) = "{"
    )
}

private PythonClass theBytesClass() {
    cpython_major_version() = 2 and result.getTpName() = "str"
    or
    cpython_major_version() = 3 and result.getTpName() = "bytes"
}

private PythonClass theUnicodeClass() {
    cpython_major_version() = 2 and result.getTpName() = "unicode"
    or
    cpython_major_version() = 3 and result.getTpName() = "str"
}

PythonClass type_from_simple_code(string s) {
    (s = "s" or s = "s#" or s = "z" or s = "z#") and result.getTpName() = "str"
    or
    (s = "u" or s = "u#" or s = "U" or s = "U#" or s = "C") and result = theUnicodeClass()
    or
    (s = "y" or s = "y#" or s = "c") and result = theBytesClass()
    or
    (s = "i" or s = "I" or s = "b" or s = "B" or s = "h" or s = "H" or
     s = "k" or s = "K" or s = "l" or s = "L" or s = "n"
    ) and result.getTpName() = "int"
    or
    (s = "f" or s = "d") and result.getTpName() = "float"
    or
    s = "D" and result.getTpName() = "complex"
    or
    (s = "O" or s = "O&" or s = "N") and result.getTpName() = "object"
}

predicate call_to_new(FunctionCall call, PythonClass cls) {
    exists(string name |
        name = call.getTarget().getName() |
        name = "_PyObject_New" or
        name = "_PyObject_GC_New" or
        name = "_PyObject_NewVar" or
        name = "_PyObject_GC_NewVar"
    ) and
    exists(AddressOfExpr addr |
        addr = call.getArgument(0) |
        addr.getAddressable() = cls
    )
}

predicate call_to_type(FunctionCall call, PythonClass cls) {
    exists(AddressOfExpr aoe |
        call.getTarget().getName().matches("PyObject\\_Call%") and
        call.getArgument(0) = aoe and
        aoe.getAddressable() = cls
    )
}

predicate pyargs_function(PythonFunctionTableEntry func, PyArgParseTupleCall call) {
    func.getFunction().getParameter(1).getAnAccess() = call.getArgument(0)
}


class PyArgsFunction extends TypedPythonExtensionFunction {

    PyArgsFunction() {
        this.getAFlag() = "METH_VARARGS"
    }

    PyArgParseTupleCall getParseArgsCall() {
        strictcount(PyArgParseTupleCall other | this.getCode().getParameter(1).getAnAccess() = other.getArgument(0)) = 1 and
        pyargs_function(this, result)
    }

    override PythonClass getArgumentType(int index) {
        this.isMethod() and index = 0 and result = this.getTable().getClass()
        or
        result.getTpName() = this.getParseArgsCall().getPyArgumentType(this.c_index(index))
   }

    override predicate argumentIsOptional(int index) {
         this.getParseArgsCall().pyArgumentIsOptional(this.c_index(index))
    }

    override predicate argumentIsKwOnly(int index) {
         this.getParseArgsCall().pyArgumentIsKwOnly(this.c_index(index))
    }

}

class PyOFunction extends TypedPythonExtensionFunction {

    PyOFunction() {
        this.getAFlag() = "METH_O"
    }

    override PythonClass getArgumentType(int index) {
        this.isMethod() and index = 0 and result = this.getTable().getClass()
        or
        /* TO DO -- Better analysis */
        this.c_index(index) = 0 and result.getTpName() = "object"
   }

    override predicate argumentIsOptional(int index) {
         none()
    }

    override predicate argumentIsKwOnly(int index) {
         none()
    }
}

class PyNoArgFunction extends TypedPythonExtensionFunction {

    PyNoArgFunction() {
        this.getAFlag() = "METH_NOARGS"
    }

   override PythonClass getArgumentType(int index) {
        this.isMethod() and index = 0 and result = this.getTable().getClass()
   }

    override predicate argumentIsOptional(int index) {
         none()
    }

    override predicate argumentIsKwOnly(int index) {
         none()
    }
}

int cpython_major_version() {
    exists(MacroInvocation mi |
        mi.getMacroName() = "PY_MAJOR_VERSION" |
        result = mi.getExpr().getValue().toInt()
    )
}

int cpython_minor_version() {
    exists(MacroInvocation mi |
        mi.getMacroName() = "PY_MINOR_VERSION" |
        result = mi.getExpr().getValue().toInt()
    )
}

string cpython_version() {
    result = cpython_major_version().toString() + "." + cpython_minor_version().toString()
}
