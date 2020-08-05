import python
private import semmle.python.objects.ObjectAPI
private import semmle.python.objects.ObjectInternal
private import semmle.python.types.Builtins

cached
private predicate is_an_object(@py_object obj) {
  /* CFG nodes for numeric literals, all of which have a @py_cobject for the value of that literal */
  obj instanceof ControlFlowNode and
  not obj.(ControlFlowNode).getNode() instanceof IntegerLiteral and
  not obj.(ControlFlowNode).getNode() instanceof StrConst
  or
  obj instanceof Builtin
}

/**
 * Instances of this class represent objects in the Python program. However, since
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
class Object extends @py_object {
  Object() { is_an_object(this) }

  /**
   * Gets an inferred type for this object, without using inter-procedural analysis.
   * WARNING: The lack of context makes this less accurate than f.refersTo(this, result, _)
   * for a control flow node 'f'
   */
  ClassObject getAnInferredType() {
    exists(ControlFlowNode somewhere | somewhere.refersTo(this, result, _))
    or
    this.asBuiltin().getClass() = result.asBuiltin() and not this = unknownValue()
    or
    this = unknownValue() and result = theUnknownType()
  }

  /**
   * Whether this is a builtin object. A builtin object is one defined by the implementation,
   * such as the integer 4 or by a native extension, such as a NumPy array class.
   */
  predicate isBuiltin() { exists(this.asBuiltin()) }

  /** Retained for backwards compatibility. See Object.isBuiltin() */
  predicate isC() { this.isBuiltin() }

  /**
   * Gets the point in the source code from which this object "originates".
   *
   * WARNING: The lack of context makes this less accurate than f.refersTo(this, _, result)
   * for a control flow node 'f'.
   */
  AstNode getOrigin() { py_flow_bb_node(this, result, _, _) }

  private predicate hasOrigin() { py_flow_bb_node(this, _, _, _) }

  /**
   * Holds if this element is at the specified location.
   * The location spans column `startcolumn` of line `startline` to
   * column `endcolumn` of line `endline` in file `filepath`.
   * For more information, see
   * [Locations](https://help.semmle.com/QL/learn-ql/ql/locations.html).
   */
  predicate hasLocationInfo(
    string filepath, int startline, int startcolumn, int endline, int endcolumn
  ) {
    this.hasOrigin() and
    this
        .getOrigin()
        .getLocation()
        .hasLocationInfo(filepath, startline, startcolumn, endline, endcolumn)
    or
    not this.hasOrigin() and
    filepath = ":Compiled Code" and
    startline = 0 and
    startcolumn = 0 and
    endline = 0 and
    endcolumn = 0
  }

  /** INTERNAL -- Do not use */
  Builtin asBuiltin() { result = this }

  /** Gets a textual representation of this element. */
  string toString() {
    not this = undefinedVariable() and
    not this = unknownValue() and
    exists(ClassObject type | type.asBuiltin() = this.asBuiltin().getClass() |
      result = type.getName() + " " + this.asBuiltin().getName()
    )
    or
    result = this.getOrigin().toString()
  }

  /**
   * Gets the class of this object for simple cases, namely constants, functions,
   * comprehensions and built-in objects.
   *
   *  This exists primarily for internal use. Use getAnInferredType() instead.
   */
  cached
  ClassObject simpleClass() {
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
    result.(Object).asBuiltin() = this.asBuiltin().getClass()
  }

  private ClassObject declaringClass(string name) { result.declaredAttribute(name) = this }

  /**
   * Whether this overrides o. In this context, "overrides" means that this object
   * is a named attribute of a some class C and `o` is a named attribute of another
   * class S, both attributes having the same name, and S is a super class of C.
   */
  predicate overrides(Object o) {
    exists(string name | declaringClass(name).getASuperType() = o.declaringClass(name))
  }

  private boolean booleanFromValue() {
    exists(ObjectInternal obj | obj.getSource() = this | result = obj.booleanValue())
  }

  /**
   * The Boolean value of this object if it always evaluates to true or false.
   * For example:
   *     false for None, true for 7 and no result for int(x)
   */
  boolean booleanValue() {
    result = this.booleanFromValue() and
    not this.maybe()
  }

  final predicate maybe() {
    booleanFromValue() = true and
    booleanFromValue() = false
  }

  predicate notClass() { any() }

  /**
   * Holds if this object can be referred to by `longName`
   * For example, the modules `dict` in the `sys` module
   * has the long name `sys.modules` and the name `os.path.join`
   * will refer to the path joining function even though it might
   * be declared in the `posix` or `nt` modules.
   * Long names can have no more than three dots after the module name.
   */
  cached
  predicate hasLongName(string longName) {
    this = findByName0(longName)
    or
    this = findByName1(longName)
    or
    this = findByName2(longName)
    or
    this = findByName3(longName)
    or
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

private Object findByName0(string longName) { result.(ModuleObject).getName() = longName }

private Object findByName1(string longName) {
  exists(string owner, string attrname | longName = owner + "." + attrname |
    result = findByName0(owner).(ModuleObject).attr(attrname)
    or
    result = findByName0(owner).(ClassObject).lookupAttribute(attrname)
  ) and
  not result = findByName0(_)
}

private Object findByName2(string longName) {
  exists(string owner, string attrname | longName = owner + "." + attrname |
    result = findByName1(owner).(ModuleObject).attr(attrname)
    or
    result = findByName1(owner).(ClassObject).lookupAttribute(attrname)
  ) and
  not result = findByName0(_) and
  not result = findByName1(_)
}

private Object findByName3(string longName) {
  exists(string owner, string attrname | longName = owner + "." + attrname |
    result = findByName2(owner).(ModuleObject).attr(attrname)
    or
    result = findByName2(owner).(ClassObject).lookupAttribute(attrname)
  ) and
  not result = findByName0(_) and
  not result = findByName1(_) and
  not result = findByName2(_)
}

/**
 * Numeric objects (ints and floats).
 * Includes those occurring in the source as a literal
 * or in a builtin module as a value.
 */
class NumericObject extends Object {
  NumericObject() {
    this.asBuiltin().getClass() = theIntType().asBuiltin() or
    this.asBuiltin().getClass() = theLongType().asBuiltin() or
    this.asBuiltin().getClass() = theFloatType().asBuiltin()
  }

  /**
   * Gets the Boolean value that this object
   * would evaluate to in a Boolean context,
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
    (
      this.asBuiltin().getClass() = theIntType().asBuiltin() or
      this.asBuiltin().getClass() = theLongType().asBuiltin()
    ) and
    result = this.asBuiltin().getName().toInt()
  }

  /** Gets the value of this object if it is a constant float */
  float floatValue() {
    this.asBuiltin().getClass() = theFloatType().asBuiltin() and
    result = this.asBuiltin().getName().toFloat()
  }

  /** Gets the string representation of this object, equivalent to calling repr() in Python */
  string repr() {
    exists(string s | s = this.asBuiltin().getName() |
      if this.asBuiltin().getClass() = theLongType().asBuiltin()
      then result = s + "L"
      else result = s
    )
  }
}

/**
 * String objects (unicode or bytes).
 * Includes those occurring in the source as a literal
 * or in a builtin module as a value.
 */
class StringObject extends Object {
  StringObject() {
    this.asBuiltin().getClass() = theUnicodeType().asBuiltin() or
    this.asBuiltin().getClass() = theBytesType().asBuiltin()
  }

  /** Whether this string is composed entirely of ascii encodable characters */
  predicate isAscii() { this.getText().regexpMatch("^\\p{ASCII}*$") }

  override boolean booleanValue() {
    this.getText() = "" and result = false
    or
    this.getText() != "" and result = true
  }

  /** Gets the text for this string */
  cached
  string getText() {
    exists(string quoted_string |
      quoted_string = this.asBuiltin().getName() and
      result = quoted_string.regexpCapture("[bu]'([\\s\\S]*)'", 1)
    )
  }
}

/**
 * Sequence objects (lists and tuples)
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
  Object getBuiltinElement(int n) { result.asBuiltin() = this.asBuiltin().getItem(n) }

  /** Gets the nth source element of this sequence */
  ControlFlowNode getSourceElement(int n) { result = this.(SequenceNode).getElement(n) }

  Object getInferredElement(int n) {
    result = this.getBuiltinElement(n)
    or
    this.getSourceElement(n).refersTo(result)
  }
}

class TupleObject extends SequenceObject {
  TupleObject() {
    this.asBuiltin().getClass() = theTupleType().asBuiltin()
    or
    this instanceof TupleNode
    or
    exists(Function func | func.getVararg().getAFlowNode() = this)
  }
}

module TupleObject {
  TupleObject empty() {
    exists(Builtin empty |
      empty = result.asBuiltin() and
      empty.getClass() = theTupleType().asBuiltin() and
      not exists(empty.getItem(_))
    )
  }
}

class NonEmptyTupleObject extends TupleObject {
  NonEmptyTupleObject() { exists(Function func | func.getVararg().getAFlowNode() = this) }

  override boolean booleanValue() { result = true }
}

class ListObject extends SequenceObject {
  ListObject() {
    this.asBuiltin().getClass() = theListType().asBuiltin()
    or
    this instanceof ListNode
  }
}

/** The `builtin` module */
BuiltinModuleObject theBuiltinModuleObject() { result.asBuiltin() = Builtin::builtinModule() }

/** The `sys` module */
BuiltinModuleObject theSysModuleObject() { result.asBuiltin() = Builtin::special("sys") }

/** DEPRECATED -- Use `Object::builtin(name)` instead. */
deprecated Object builtin_object(string name) { result = Object::builtin(name) }

/** The built-in object None */
Object theNoneObject() { result.asBuiltin() = Builtin::special("None") }

/** The built-in object True */
Object theTrueObject() { result.asBuiltin() = Builtin::special("True") }

/** The built-in object False */
Object theFalseObject() { result.asBuiltin() = Builtin::special("False") }

/** The NameError class */
Object theNameErrorType() { result = Object::builtin("NameError") }

/** The StandardError class */
Object theStandardErrorType() { result = Object::builtin("StandardError") }

/** The IndexError class */
Object theIndexErrorType() { result = Object::builtin("IndexError") }

/** The LookupError class */
Object theLookupErrorType() { result = Object::builtin("LookupError") }

/** DEPRECATED -- Use `Object::quitter(name)` instead. */
deprecated Object quitterObject(string name) { result = Object::quitter(name) }

/** DEPRECATED -- Use `Object::notImplemented()` instead. */
deprecated Object theNotImplementedObject() { result = Object::builtin("NotImplemented") }

/** DEPRECATED -- Use `TupleObject::empty()` instead. */
deprecated Object theEmptyTupleObject() { result = TupleObject::empty() }

module Object {
  Object builtin(string name) { result.asBuiltin() = Builtin::builtin(name) }

  /** The named quitter object (quit or exit) in the builtin namespace */
  Object quitter(string name) {
    (name = "quit" or name = "exit") and
    result = builtin(name)
  }

  /** The builtin object `NotImplemented`. Not be confused with `NotImplementedError`. */
  Object notImplemented() { result = builtin("NotImplemented") }
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

Object theUnknownType() { result.asBuiltin() = Builtin::unknownType() }

/* For backwards compatibility */
class SuperBoundMethod extends Object {
  string name;

  SuperBoundMethod() {
    this.(AttrNode).getObject(name).inferredValue().getClass() = Value::named("super")
  }

  override string toString() { result = "super()." + name }

  Object getFunction(string fname) {
    fname = name and
    exists(SuperInstance sup, BoundMethodObjectInternal m |
      sup = this.(AttrNode).getObject(name).inferredValue() and
      sup.attribute(name, m, _) and
      result = m.getFunction().getSource()
    )
  }
}
