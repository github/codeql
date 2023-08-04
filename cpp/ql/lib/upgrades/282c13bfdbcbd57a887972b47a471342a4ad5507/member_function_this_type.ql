/*
 * Upgrade script to populate the member_function_this_type table. It's a rough
 * approximation of what the extractor would do - for a member function C::f,
 * we say its type is C* (if that pointer type exists in the database).
 * CV-qualifiers are ignored.
 */

class Class extends @usertype {
  Class() {
    usertypes(this, _, 1) or
    usertypes(this, _, 2) or
    usertypes(this, _, 3) or
    usertypes(this, _, 6) or
    usertypes(this, _, 10) or
    usertypes(this, _, 11) or
    usertypes(this, _, 12)
  }

  string toString() { usertypes(this, result, _) }
}

class ClassPointerType extends @derivedtype {
  ClassPointerType() { derivedtypes(this, _, 1, _) }

  Class getBaseType() { derivedtypes(this, _, _, result) }

  string toString() { result = this.getBaseType().toString() + "*" }
}

class DefinedMemberFunction extends @function {
  DefinedMemberFunction() {
    exists(@fun_decl fd |
      fun_def(fd) and
      (
        fun_decls(fd, this, _, _, _)
        or
        exists(@function f | function_instantiation(this, f) and fun_decls(fd, f, _, _, _))
      )
    )
  }

  ClassPointerType getTypeOfThis() { member(result.getBaseType(), _, this) }

  string toString() { functions(this, result, _) }
}

from DefinedMemberFunction f
select f, f.getTypeOfThis()
