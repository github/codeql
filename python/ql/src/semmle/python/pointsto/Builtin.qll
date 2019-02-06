
import python

/** INTERNAL -- Do not use directly
 *  A database entity representing builtin objects
 */
class Builtin extends @py_cobject {

    Builtin() {
        not py_special_objects(this, "_1") and
        not py_special_objects(this, "_semmle_unknown_type")
    }

    string toString() {
        result = "DB builtin object " + this.getName()
    }

    BuiltinClass getType() {
        py_cobjecttypes(this, result)
    }

    string getName() {
        py_cobjectnames(this, result)
    }

    Builtin getAttribute(string name) {
        not name = ".super." and
        py_cmembers_versioned(this, name, result, _)
    }

    Builtin getItem(int n) {
        py_citems(this, n, result)
    }

}

module Builtin {

    Builtin special(string name) {
        py_special_objects(result, name)
    }

}

/**INTERNAL -- Do not use directly
 *   A database entity representing builtin classes 
 */
class BuiltinClass extends Builtin {

    BuiltinClass getSuperType() {
        py_cmembers_versioned(this, ".super.", result, _)
    }

    /** Holds if this class declares (rather than inherits) the attribute `name` */
    predicate declaresAttribute(string name) {
        exists(Builtin attr |
            attr = this.getAttribute(name) and
            not attr = this.getSuperType().getAttribute(name)
        )
    }

}

class BuiltinModule extends Builtin {

    BuiltinModule() {
        exists(BuiltinClass moduleType |
            py_special_objects(moduleType, "ModuleType") and
            py_cobjecttypes(this, moduleType)
        )
    }

}

module BuiltinModule {

    BuiltinModule builtins() {
        py_special_objects(result, "builtin_module_2") and major_version() = 2
        or
        py_special_objects(result, "builtin_module_3") and major_version() = 3
    }

    BuiltinModule sys() {
        py_special_objects(result, "sys")
    }

    /** Gets a builtin from the builtin namespace, such as `list` or `None` */
    Builtin builtin(string name) {
        result = builtins().getAttribute(name)
    }
}

