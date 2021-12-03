import cpp

string functionName(Function f) {
  result = f.getQualifiedName() + "(" + f.getParameterString() + ")"
  or
  not exists(f.getQualifiedName()) and
  result = f.getName() + "(" + f.getParameterString() + ")"
}

from Class c, Function f
where
  c.getName() = "C" and
  f.inMemberOrFriendOf(c) and
  not f.isCompilerGenerated()
select c, f, functionName(f)
