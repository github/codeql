import python

class Builtin extends @py_cobject {
  Builtin() {
    not (
      /* @py_cobjects for modules which have a corresponding Python module */
      exists(@py_cobject mod_type |
        py_special_objects(mod_type, "ModuleType") and py_cobjecttypes(this, mod_type)
      ) and
      exists(Module m | py_cobjectnames(this, m.getName()))
    ) and
    (
      /* Exclude unmatched builtin objects in the library trap files */
      py_cobjectnames(this, _) or
      py_cobjecttypes(this, _) or
      py_special_objects(this, _)
    )
  }

  /** Gets a textual representation of this element. */
  string toString() {
    not this = undefinedVariable().asBuiltin() and
    not this = Builtin::unknown() and
    exists(Builtin type, string typename, string objname |
      py_cobjecttypes(this, type) and py_cobjectnames(this, objname) and typename = type.getName()
    |
      result = typename + " " + objname
    )
  }

  Builtin getClass() {
    py_cobjecttypes(this, result) and not this = Builtin::unknown()
    or
    this = Builtin::unknown() and result = Builtin::unknownType()
  }

  Builtin getMember(string name) {
    not name = ".super." and
    py_cmembers_versioned(this, name, result, major_version().toString())
  }

  Builtin getItem(int index) { py_citems(this, index, result) }

  Builtin getBaseClass() {
    /* The extractor uses the special name ".super." to indicate the super class of a builtin class */
    py_cmembers_versioned(this, ".super.", result, major_version().toString())
  }

  predicate inheritsFromType() {
    this = Builtin::special("type")
    or
    this.getBaseClass().inheritsFromType()
  }

  string getName() { if this.isStr() then result = "str" else py_cobjectnames(this, result) }

  private predicate isStr() {
    major_version() = 2 and this = Builtin::special("bytes")
    or
    major_version() = 3 and this = Builtin::special("unicode")
  }

  predicate isClass() {
    py_cobjecttypes(_, this)
    or
    this = Builtin::unknownType()
    or
    exists(Builtin meta | meta.inheritsFromType() and py_cobjecttypes(this, meta))
  }

  predicate isFunction() {
    this.getClass() = Builtin::special("BuiltinFunctionType") and
    exists(Builtin mod |
      mod.isModule() and
      mod.getMember(_) = this
    )
  }

  predicate isModule() { this.getClass() = Builtin::special("ModuleType") }

  predicate isMethod() {
    this.getClass() = Builtin::special("MethodDescriptorType")
    or
    this.getClass().getName() = "wrapper_descriptor"
  }

  int intValue() {
    (
      this.getClass() = Builtin::special("int") or
      this.getClass() = Builtin::special("long")
    ) and
    result = this.getName().toInt()
  }

  float floatValue() {
    this.getClass() = Builtin::special("float") and
    result = this.getName().toFloat()
  }

  string strValue() {
    (
      this.getClass() = Builtin::special("unicode") or
      this.getClass() = Builtin::special("bytes")
    ) and
    exists(string quoted_string |
      quoted_string = this.getName() and
      // Remove prefix ("b" or "u") and leading and trailing quotes (both "'").
      result = quoted_string.substring(2, quoted_string.length() - 1)
    )
  }
}

module Builtin {
  Builtin builtinModule() {
    py_special_objects(result, "builtin_module_2") and major_version() = 2
    or
    py_special_objects(result, "builtin_module_3") and major_version() = 3
  }

  Builtin builtin(string name) { result = builtinModule().getMember(name) }

  Builtin special(string name) { py_special_objects(result, name) }

  Builtin unknown() { py_special_objects(result, "_1") }

  Builtin unknownType() { py_special_objects(result, "_semmle_unknown_type") }
}
