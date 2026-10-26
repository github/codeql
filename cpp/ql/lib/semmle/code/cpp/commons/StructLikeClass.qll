import semmle.code.cpp.Class

/**
 * A class that is either a `struct` or just has getters and setters
 * for its members. In either case it just stores data and has no
 * real encapsulation.
 */
class StructLikeClass extends Class {
  StructLikeClass() {
    this instanceof Struct
    or
    forall(MemberFunction f | f = this.getAMemberFunction() |
      exists(MemberVariable v | setter(v, f, this) or getter(v, f, this))
      or
      f instanceof Constructor
      or
      f instanceof Destructor
      or
      // Allow the copy and move assignment ops - still struct-like
      f instanceof CopyAssignmentOperator
      or
      f instanceof MoveAssignmentOperator
    )
  }

  /**
   * Gets a setter function in this class, setting the given variable.
   * This is a function whose name begins "set"... that assigns to this variable and no other
   * member variable of the class. In addition, it takes a single parameter of
   * type the type of the corresponding member variable.
   */
  MemberFunction getASetter(MemberVariable v) { setter(v, result, this) }

  /**
   * Gets a getter function in this class, getting the given variable.
   * This is a function whose name begins "get"... that reads this variable and no other
   * member variable of the class. In addition, its return type is the type
   * of the corresponding member variable.
   */
  MemberFunction getAGetter(MemberVariable v) { getter(v, result, this) }
}

/**
 * Holds if `f` is a setter member function for `v`, in class `c`.
 * See `StructLikeClass.getASetter`.
 */
predicate setter(MemberVariable v, MemberFunction f, Class c) {
  f.getDeclaringType() = c and
  v.getDeclaringType() = c and
  f.getName().matches("set%") and
  v.getAnAssignedValue().getEnclosingFunction() = f and
  forall(MemberVariable v2 | v2.getAnAssignedValue().getEnclosingFunction() = f | v2 = v) and
  f.getNumberOfParameters() = 1 and
  f.getParameter(0).getType().stripType() = v.getType().stripType()
}

/**
 * Holds if `f` is a getter member function for `v`, in class `c`.
 * See `StructLikeClass.getAGetter`.
 */
predicate getter(MemberVariable v, MemberFunction f, Class c) {
  f.getDeclaringType() = c and
  v.getDeclaringType() = c and
  f.getName().matches("get%") and
  v.getAnAccess().getEnclosingFunction() = f and
  forall(MemberVariable v2 | v2.getAnAccess().getEnclosingFunction() = f | v2 = v) and
  f.getNumberOfParameters() = 0 and
  f.getType().stripType() = v.getType().stripType()
}
