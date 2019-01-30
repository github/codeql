import python
private import semmle.python.pointsto.Base

private cached predicate is_an_object(@py_object obj) {
    /* CFG nodes for numeric literals, all of which have a @py_cobject for the value of that literal */
    not obj.(ControlFlowNode).getNode() instanceof ImmutableLiteral
    and
    not (
        /* @py_cobjects for modules which have a corresponding Python module */
        exists(@py_cobject mod_type | py_special_objects(mod_type, "ModuleType") and py_cobjecttypes(obj, mod_type)) and
        exists(Module m | py_cobjectnames(obj, m.getName()))
    )
}

private newtype TObject = 
    TBuiltinObject(@py_cobject obj) {
        not (
            /* @py_cobjects for modules which have a corresponding Python module */
            exists(@py_cobject mod_type | py_special_objects(mod_type, "ModuleType") and py_cobjecttypes(obj, mod_type)) and
            exists(Module m | py_cobjectnames(obj, m.getName()))
        )
    }
    or
    TSourceObject(@py_flow_node obj) {
        not obj.(ControlFlowNode).getNode() instanceof ImmutableLiteral
    }

/** Instances of this class represent objects in the Python program. However, since
 *  the QL database is static and Python programs are dynamic, there are necessarily a
 *  number of approximations. 
 *
 *  Each point in the control flow graph where a new object can be created is treated as
 *  an object. Many builtin objects, such as integers, strings and builtin classes, are 
 *  also treated as 'objects'. Hence each 'object', that is an instance of this class, 
 *  represents a set of actual Python objects in the actual program. 
 *
 *  Ideally each set would contain only one member, but that is not possible in practice. 
 *  Many instances of this class will represent many actual Python objects, especially 
 *  if the point in the control flow graph to which they refer is in a loop. Others may not 
 *  refer to any objects. However, for many important objects such as classes and functions, 
 *  there is a one-to-one relation.
 */
class Object extends TObject {

    /** INTERNAL -- Do not use */
    @py_cobject asBuiltin() {
        this = TBuiltinObject(result)
    }

    /** INTERNAL -- Do not use */
    @py_flow_node asCfgNode() {
        this = TSourceObject(result)
    }

    Object getBuiltinClass() {
        py_cobjecttypes(this.asBuiltin(), result.asBuiltin()) and not this = unknownValue()
    }

    string getBuiltinName() {
        py_cobjectnames(this.asBuiltin(), result)
    }

    /** Gets an inferred type for this object, without using inter-procedural analysis.
     * WARNING: The lack of context makes this less accurate than f.refersTo(this, result, _)
     * for a control flow node 'f' */
    ClassObject getAnInferredType() {
        exists(ControlFlowNode somewhere | somewhere.refersTo(this, result, _))
        or
        result = this.getBuiltinClass()
        or
        this = unknownValue() and result = theUnknownType()
    }

    /** Whether this a builtin object. A builtin object is one defined by the implementation, 
        such as the integer 4 or by a native extension, such as a NumPy array class. */
    predicate isBuiltin() {
        this = TBuiltinObject(_)
    }

    /** Retained for backwards compatibility. See Object.isBuiltin() */
    predicate isC() {
        this.isBuiltin()
    }

    /** Gets the point in the source code from which this object "originates".
     *
     *  WARNING: The lack of context makes this less accurate than f.refersTo(this, _, result)
     * for a control flow node 'f'.
     */
    AstNode getOrigin() {
        py_flow_bb_node(this.asCfgNode(), result, _, _)
    }

    private predicate hasOrigin() {
        py_flow_bb_node(this.asCfgNode(), _, _, _)
    }

    predicate hasLocationInfo(string filepath, int bl, int bc, int el, int ec) {
        this.hasOrigin() and this.getOrigin().getLocation().hasLocationInfo(filepath, bl, bc, el, ec)
        or
        not this.hasOrigin() and filepath = ":Compiled Code" and bl = 0 and bc = 0 and el = 0 and ec = 0
   }

    string toString() {
        not this = undefinedVariable() and not this = unknownValue() and
        exists(ClassObject type, string typename, string objname |
            py_cobjecttypes(this.asBuiltin(), type.asBuiltin()) and py_cobjectnames(this.asBuiltin(), objname) and typename = type.getName() |
            result = typename + " " + objname
        )
        or
        result = this.getOrigin().toString()
    }

    /** Gets the class of this object for simple cases, namely constants, functions, 
     * comprehensions and built-in objects.
     *
     *  This exists primarily for internal use. Use getAnInferredType() instead.
     */
    cached ClassObject simpleClass() {
        result = comprehension(this.getOrigin())
        or
        result = collection_literal(this.getOrigin())
        or
        result = string_literal(this.getOrigin())
        or
        this.getOrigin() instanceof CallableExpr and result = thePyFunctionType()
        or
        this.getOrigin() instanceof Module and result = theModuleType()
        or
        py_cobjecttypes(this.asBuiltin(), result.asBuiltin())
    }

    private
    ClassObject declaringClass(string name) {
        result.declaredAttribute(name) = this
    }

    /** Whether this overrides o. In this context, "overrides" means that this object
     *  is a named attribute of a some class C and `o` is a named attribute of another
     *  class S, both attributes having the same name, and S is a super class of C.
     */
    predicate overrides(Object o) {
        exists(string name |
            declaringClass(name).getASuperType() = o.declaringClass(name)
        )
    }

    /** The Boolean value of this object if it always evaluates to true or false.
     * For example:
     *     false for None, true for 7 and no result for int(x)
     */
    boolean booleanValue() {
        this = theNoneObject() and result = false 
        or
        this = theTrueObject() and result = true 
        or
        this = theFalseObject() and result = false 
        or
        this = theEmptyTupleObject() and result = false 
        or
        exists(Tuple t | t = this.getOrigin() |
            exists(t.getAnElt()) and result = true
            or
            not exists(t.getAnElt()) and result = false
        )
        or
        exists(Unicode s | s.getLiteralObject() = this |
            s.getS() = "" and result = false
            or
            s.getS() != "" and result = true
        )
        or
        exists(Bytes s | s.getLiteralObject() = this |
            s.getS() = "" and result = false
            or
            s.getS() != "" and result = true
        )
    }

    final predicate maybe() {
        not exists(this.booleanValue())
    }

    predicate notClass() {
        any()
    }

    /** Holds if this object can be referred to by `longName`
     * For example, the modules `dict` in the `sys` module
     * has the long name `sys.modules` and the name `os.path.join`
     * will refer to the path joining function even though it might
     * be declared in the `posix` or `nt` modules.
     * Long names can have no more than three dots after the module name.
     */
    cached predicate hasLongName(string longName) {
        this = findByName0(longName) or
        this = findByName1(longName) or
        this = findByName2(longName) or
        this = findByName3(longName) or
        exists(ClassMethodObject cm |
            cm.hasLongName(longName) and
            cm.getFunction() = this
        )
        or
        exists(StaticMethodObject cm |
            cm.hasLongName(longName) and
            cm.getFunction() = this
        )
    }

}


module Object {

    Object fromCfgNode(ControlFlowNode f) {
        result = TSourceObject(f)
    }

}

private Object findByName0(string longName) {
    result.(ModuleObject).getName() = longName
}

private Object findByName1(string longName) {
    exists(string owner, string attrname |
        longName = owner + "." + attrname
        |
        result = findByName0(owner).(ModuleObject).getAttribute(attrname)
        or
        result = findByName0(owner).(ClassObject).lookupAttribute(attrname)
    )
    and
    not result = findByName0(_)
}

private Object findByName2(string longName) {
    exists(string owner, string attrname |
        longName = owner + "." + attrname
        |
        result = findByName1(owner).(ModuleObject).getAttribute(attrname)
        or
        result = findByName1(owner).(ClassObject).lookupAttribute(attrname)
    )
    and not result = findByName0(_)
    and not result = findByName1(_)
}

private Object findByName3(string longName) {
    exists(string owner, string attrname |
        longName = owner + "." + attrname
        |
        result = findByName2(owner).(ModuleObject).getAttribute(attrname)
        or
        result = findByName2(owner).(ClassObject).lookupAttribute(attrname)
    )
    and not result = findByName0(_)
    and not result = findByName1(_)
    and not result = findByName2(_)
}


/** Numeric objects (ints and floats). 
 *  Includes those occurring in the source as a literal
 *  or in a builtin module as a value.
 */
class NumericObject extends Object {

    NumericObject() {
         py_cobjecttypes(this.asBuiltin(), theIntType().asBuiltin()) or 
         py_cobjecttypes(this.asBuiltin(), theLongType().asBuiltin()) or
         py_cobjecttypes(this.asBuiltin(), theFloatType().asBuiltin())
    }

    /** Gets the Boolean value that this object
     *  would evaluate to in a Boolean context,
     * such as `bool(x)` or `if x: ...`
     */
    override boolean booleanValue() {
        this.intValue() != 0 and result = true
        or
        this.intValue() = 0 and result = false
        or
        this.floatValue() != 0 and result = true
        or
        this.floatValue() = 0 and result = false
    }

    /** Gets the value of this object if it is a constant integer and it fits in a QL int */ 
    int intValue() {
        (py_cobjecttypes(this.asBuiltin(), theIntType().asBuiltin()) or py_cobjecttypes(this.asBuiltin(), theLongType().asBuiltin()))
        and
        exists(string s | py_cobjectnames(this.asBuiltin(), s) and result = s.toInt())
    }

    /** Gets the value of this object if it is a constant float */ 
    float floatValue() {
        (py_cobjecttypes(this.asBuiltin(), theFloatType().asBuiltin()))
        and
        exists(string s | py_cobjectnames(this.asBuiltin(), s) and result = s.toFloat())
    }

    /** Gets the string representation of this object, equivalent to calling repr() in Python */
    string repr() {
        exists(string s | 
            py_cobjectnames(this.asBuiltin(), s) |
            if py_cobjecttypes(this.asBuiltin(), theLongType().asBuiltin()) then
                result = s + "L"
            else
                result = s
        )
    }

}

/** String objects (unicode or bytes).
 *  Includes those occurring in the source as a literal
 *  or in a builtin module as a value.
 */
class StringObject extends Object {

    StringObject() {
        py_cobjecttypes(this.asBuiltin(), theUnicodeType().asBuiltin()) or
        py_cobjecttypes(this.asBuiltin(), theBytesType().asBuiltin())
    }

    /** Whether this string is composed entirely of ascii encodable characters */
    predicate isAscii() {
        this.getText().regexpMatch("^\\p{ASCII}*$")
    }

    override boolean booleanValue() {
        this.getText() = "" and result = false
        or
        this.getText() != "" and result = true
    }

    /** Gets the text for this string */
    cached string getText() {
        exists(string quoted_string |
            py_cobjectnames(this.asBuiltin(), quoted_string) and
            result = quoted_string.regexpCapture("[bu]'([\\s\\S]*)'", 1)
        )
    }

}

/** Sequence objects (lists and tuples)
 *  Includes those occurring in the source as a literal
 *  or in a builtin module as a value.
 */
abstract class SequenceObject extends Object {

    /** Gets the length of this sequence */
    int getLength() {
        result = strictcount(this.getBuiltinElement(_))
        or
        result = strictcount(this.getSourceElement(_))
    }

    /** Gets the nth item of this builtin sequence */
    Object getBuiltinElement(int n) {
        py_citems(this.asBuiltin(), n, result.asBuiltin())
    }

    /** Gets the nth source element of this sequence */
    ControlFlowNode getSourceElement(int n) {
        result = this.asCfgNode().(SequenceNode).getElement(n)
    }

    Object getInferredElement(int n) {
        result = this.getBuiltinElement(n)
        or
        this.getSourceElement(n).refersTo(result)
    }

}

class TupleObject extends SequenceObject {

    TupleObject() {
        py_cobjecttypes(this.asBuiltin(), theTupleType().asBuiltin())
        or
        this.asCfgNode() instanceof TupleNode
        or
        exists(Function func | func.getVararg().getAFlowNode() = this.asCfgNode())
    }

}

class NonEmptyTupleObject extends TupleObject {

    NonEmptyTupleObject() {
        exists(Function func | func.getVararg().getAFlowNode() = this.asCfgNode())
    }

    override boolean booleanValue() {
        result = true
    }

}


class ListObject extends SequenceObject {

    ListObject() {
        py_cobjecttypes(this.asBuiltin(), theListType().asBuiltin())
        or
        this.asCfgNode() instanceof ListNode
    }

}

/** The `builtin` module */
BuiltinModuleObject theBuiltinModuleObject() {
    py_special_objects(result.asBuiltin(), "builtin_module_2") and major_version() = 2
    or
    py_special_objects(result.asBuiltin(), "builtin_module_3") and major_version() = 3
}

/** The `sys` module */
BuiltinModuleObject theSysModuleObject() {
    py_special_objects(result.asBuiltin(), "sys")
}

Object builtin_object(string name) {
    py_cmembers_versioned(theBuiltinModuleObject().asBuiltin(), name, result.asBuiltin(), major_version().toString())
}

/** The built-in object None */
 Object theNoneObject() {
    py_special_objects(result.asBuiltin(), "None")
}

/** The built-in object True */
 Object theTrueObject() {
    py_special_objects(result.asBuiltin(), "True")
}

/** The built-in object False */
 Object theFalseObject() {
    py_special_objects(result.asBuiltin(), "False")
}

/** The builtin function apply (Python 2 only) */
 Object theApplyFunction() {
    result = builtin_object("apply")
}

/** The builtin function hasattr */
 Object theHasattrFunction() {
    result = builtin_object("hasattr")
}

/** The builtin function len */
 Object theLenFunction() {
    result = builtin_object("len")
}

/** The builtin function format */
 Object theFormatFunction() {
    result = builtin_object("format")
}

/** The builtin function open */
 Object theOpenFunction() {
    result = builtin_object("open")
}

/** The builtin function print (Python 2.7 upwards) */
 Object thePrintFunction() {
    result = builtin_object("print")
}

/** The builtin function input (Python 2 only) */
 Object theInputFunction() {
    result = builtin_object("input")
}

/** The builtin function locals */
 Object theLocalsFunction() {
    py_special_objects(result.asBuiltin(), "locals")
}

/** The builtin function globals */
 Object theGlobalsFunction() {
    py_special_objects(result.asBuiltin(), "globals")
}

/** The builtin function sys.exit */
 Object theExitFunctionObject() {
    py_cmembers_versioned(theSysModuleObject().asBuiltin(), "exit", result.asBuiltin(), major_version().toString())
}

/** The NameError class */
Object theNameErrorType() {
    result = builtin_object("NameError")
}

/** The StandardError class */
Object theStandardErrorType() {
    result = builtin_object("StandardError")
}

/** The IndexError class */
Object theIndexErrorType() {
    result = builtin_object("IndexError")
}

/** The LookupError class */
Object theLookupErrorType() {
    result = builtin_object("LookupError")
}

/** The named quitter object (quit or exit) in the builtin namespace */
Object quitterObject(string name) {
    (name = "quit" or name = "exit") and
    result = builtin_object(name)
}

/** The builtin object `NotImplemented`. Not be confused with `NotImplementedError`. */
Object theNotImplementedObject() {
    result = builtin_object("NotImplemented")
}

Object theEmptyTupleObject() {
    py_cobjecttypes(result.asBuiltin(), theTupleType().asBuiltin()) and not py_citems(result.asBuiltin(), _, _)
}


private ClassObject comprehension(Expr e) {
    e instanceof ListComp and result = theListType()
    or
    e instanceof SetComp and result = theSetType()
    or
    e instanceof DictComp and result = theDictType()
    or
    e instanceof GeneratorExp and result = theGeneratorType()
}

private ClassObject collection_literal(Expr e) {
    e instanceof List and result = theListType()
    or
    e instanceof Set and result = theSetType()
    or
    e instanceof Dict and result = theDictType()
    or
    e instanceof Tuple and result = theTupleType()
}

private ClassObject string_literal(Expr e) {
    e instanceof Bytes and result = theBytesType()
    or
    e instanceof Unicode and result = theUnicodeType()
}

Object theUnknownType() {
    py_special_objects(result.asBuiltin(), "_semmle_unknown_type")
}

