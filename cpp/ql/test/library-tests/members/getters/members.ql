import cpp

newtype TMaybeClass =
  TClass(Class c) or
  TNoClass()

class MaybeClass extends TMaybeClass {
  abstract string toString();

  abstract Location getLocation();

  abstract string relation(Function f);
}

string relation(Class c, Function f) {
  exists(int i | f = c.getCanonicalMember(i) and result = "getCanonicalMember(" + i + ")")
  or
  exists(int i | f = c.getAMember(i) and result = "getAMember(" + i + ")")
  or
  f = c.getAMember() and result = "getAMember()"
  or
  f = c.getAMemberFunction() and result = "getAMemberFunction()"
  or
  f.getDeclaringType() = c and result = "getDeclaringType()"
}

class YesMaybeClass extends MaybeClass {
  Class c;

  YesMaybeClass() { this = TClass(c) }

  override string toString() { result = c.toString() }

  override Location getLocation() { result = c.getLocation() }

  override string relation(Function f) { result = relation(c, f) }
}

class NoMaybeClass extends MaybeClass {
  NoMaybeClass() { this = TNoClass() }

  override string toString() { result = "<none>" }

  override Location getLocation() { result instanceof UnknownLocation }

  override string relation(Function f) {
    not exists(relation(_, f)) and
    result = "Orphan"
  }
}

string functionName(Function f) {
  exists(string name, string templateArgs, string args |
    result = name + templateArgs + args and
    name = f.getQualifiedName() and
    (
      if exists(f.getATemplateArgument())
      then
        templateArgs =
          "<" + concat(int i | | f.getTemplateArgument(i).toString(), "," order by i) + ">"
      else templateArgs = ""
    ) and
    args = "(" + concat(int i | | f.getParameter(i).getType().toString(), "," order by i) + ")"
  )
}

from MaybeClass m, Function f
where
  not f.getDeclaringType().getName() = "__va_list_tag" and
  exists(m.relation(f))
select m, f, functionName(f), concat(m.relation(f), ", ")
