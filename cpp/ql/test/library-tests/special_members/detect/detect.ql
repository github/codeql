import cpp

string functionName(Function f) {
  result = f.getQualifiedName() + "(" + f.getParameterString() + ")"
  or
  not exists(f.getQualifiedName()) and
  result = f.getName() + "(" + f.getParameterString() + ")"
}

from MemberFunction f, string description
where
  description = "1 constructor" and
  f instanceof Constructor and
  not f instanceof CopyConstructor and
  not f instanceof MoveConstructor
  or
  description = "2 copy constructor" and f instanceof CopyConstructor
  or
  description = "3 move constructor" and f instanceof MoveConstructor
  or
  description = "4 copy assignment" and f instanceof CopyAssignmentOperator
  or
  description = "5 move assignment" and f instanceof MoveAssignmentOperator
  or
  description = "6 none of the above" and
  not f instanceof Constructor and
  not f instanceof CopyAssignmentOperator and
  not f instanceof MoveAssignmentOperator
select description, functionName(f)
