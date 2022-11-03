/**
 * Provides predicates to determine whether a type is an aggregate or POD
 * (Plain Old Data), as defined by C++03.
 */

import cpp

/**
 * Holds if `t` is a scalar type, according to the rules specified in
 * C++03 3.9(10):
 *
 *   Arithmetic types (3.9.1), enumeration types, pointer types, and
 *   pointer to member types (3.9.2), and cv-qualified versions of these
 *   types (3.9.3) are collectively called scalar types.
 */
predicate isScalarType03(Type t) {
  exists(Type ut | ut = t.getUnderlyingType() |
    ut instanceof ArithmeticType or
    ut instanceof Enum or
    ut instanceof FunctionPointerType or
    ut instanceof PointerToMemberType or
    ut instanceof PointerType or
    isScalarType03(ut.(SpecifiedType).getUnspecifiedType())
  )
}

/**
 * Holds if `c` is an aggregate class, according to the rules specified in
 * C++03 8.5.1(1):
 *
 *   An aggregate [class] is ... a class (clause 9) with no user-declared
 *   constructors (12.1), no private or protected non-static data members
 *   (clause 11), no base classes (clause 10), and no virtual functions
 *   (10.3).
 */
predicate isAggregateClass03(Class c) {
  not c instanceof TemplateClass and
  not exists(Constructor cons |
    cons.getDeclaringType() = c and
    not cons.isCompilerGenerated()
  ) and
  not exists(Variable v |
    v.getDeclaringType() = c and
    not v.isStatic()
  |
    v.hasSpecifier("private") or
    v.hasSpecifier("protected")
  ) and
  not exists(c.getABaseClass()) and
  not exists(VirtualFunction f | f.getDeclaringType() = c)
}

/**
 * Holds if `t` is an aggregate type, according to the rules specified in
 * C++03 8.5.1(1):
 *
 *   An aggregate is an array or a class (clause 9) with no user-declared
 *   constructors (12.1), no private or protected non-static data members
 *   (clause 11), no base classes (clause 10), and no virtual functions
 *   (10.3).
 */
predicate isAggregateType03(Type t) {
  exists(Type ut | ut = t.getUnderlyingType() |
    ut instanceof ArrayType or
    isAggregateClass03(ut)
  )
}

/**
 * Holds if `c` is a POD class, according to the rules specified in
 * C++03 9(4):
 *
 *   A POD-struct is an aggregate class that has no non-static data members
 *   of type non-POD-struct, non-POD-union (or array of such types) or
 *   reference, and has no user-defined copy assignment operator and no
 *   user-defined destructor. Similarly, a POD-union is an aggregate union
 *   that has no non-static data members of type non-POD-struct,
 *   non-POD-union (or array of such types) or reference, and has no
 *   user-defined copy assignment operator and no user-defined destructor.
 *   A POD class is a class that is either a POD-struct or a POD-union.
 */
predicate isPODClass03(Class c) {
  isAggregateClass03(c) and
  not exists(Variable v |
    v.getDeclaringType() = c and
    not v.isStatic()
  |
    not isPODType03(v.getType())
    or
    exists(ArrayType at |
      at = v.getType() and
      not isPODType03(at.getBaseType())
    )
    or
    v.getType() instanceof ReferenceType
  ) and
  not exists(CopyAssignmentOperator o |
    o.getDeclaringType() = c and
    not o.isCompilerGenerated()
  ) and
  not exists(Destructor dest |
    dest.getDeclaringType() = c and
    not dest.isCompilerGenerated()
  )
}

/**
 * Holds if `t` is a POD type, according to the rules specified in
 * C++03 3.9(10):
 *
 *   Scalar types, POD-struct types, POD-union types (clause 9), arrays of
 *   such types and cv-qualified versions of these types (3.9.3) are
 *   collectively called POD types.
 */
predicate isPODType03(Type t) {
  exists(Type ut | ut = t.getUnderlyingType() |
    isScalarType03(ut)
    or
    isPODClass03(ut)
    or
    exists(ArrayType at | at = ut and isPODType03(at.getBaseType()))
    or
    isPODType03(ut.(SpecifiedType).getUnspecifiedType())
  )
}
