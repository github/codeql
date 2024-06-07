private import cpp
private import semmle.code.cpp.Print as Print

string getIdentityString(Declaration decl) {
  if decl instanceof StaticLocalVariable
  then
    exists(StaticLocalVariable v | v = decl | result = v.getType().toString() + " " + v.getName())
  else result = Print::getIdentityString(decl)
}
