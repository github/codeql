/**
 * @name AV Rule 76
 * @description A copy constructor and an assignment operator shall be declared for classes that contain pointers to data items or nontrivial destructors. If the copy constructor and assignment operators are not required, they should be explicitly disallowed.
 * @kind problem
 * @id cpp/jsf/av-rule-76
 * @problem.severity warning
 * @tags maintainability
 *       external/jsf
 */

import cpp

predicate hasPointerMember(Class c) {
  // Note: any function pointers are fine
  exists(MemberVariable v, Type t |
    v.getDeclaringType() = c and
    t = v.getType().getUnderlyingType() and
    (t instanceof PointerType or t instanceof PointerToMemberType) and
    not t instanceof FunctionPointerType and
    not t.(PointerToMemberType).getBaseType() instanceof RoutineType
  )
}

class TrivialStmt extends Stmt {
  TrivialStmt() {
    this instanceof EmptyStmt
    or
    this instanceof ReturnStmt and not this.(ReturnStmt).hasExpr()
  }
}

// What is a nontrivial destructor? JSF is unclear about that. We'll just
// take any nonempty destructor as nontrivial. Exclude the generated 'return' stmt
predicate hasNontrivialDestructor(Class c) {
  exists(Stmt s | s = c.getDestructor().getBlock().getAStmt() | not s instanceof TrivialStmt)
}

from Class c
where
  (hasPointerMember(c) or hasNontrivialDestructor(c)) and
  not (
    c.getAMemberFunction() instanceof CopyConstructor and
    c.getAMemberFunction() instanceof CopyAssignmentOperator
  ) and
  not c instanceof Struct
select c,
  "AV Rule 76: A copy constructor and an assignment operator shall be declared for classes that contain pointers to data items or nontrivial destructors."
