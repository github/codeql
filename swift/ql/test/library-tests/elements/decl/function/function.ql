import swift

string describe(Function f) {
  result = "getName:" + f.getName()
  or
  exists(string a |
    f.hasName(a) and
    result = "hasName:" + a
  )
  or
  result = "Method" and f instanceof Method
  or
  exists(string a, string b |
    f.(Method).hasQualifiedName(a, b) and
    result = "hasQualifiedName(2):" + a + "." + b
  )
  or
  exists(string a, string b, string c |
    f.(Method).hasQualifiedName(a, b, c) and
    result = "hasQualifiedName(3):" + a + "." + b + "." + c
  )
  or
  exists(Decl td | td.getAMember() = f |
    result = "memberOf:" + td.asNominalTypeDecl().getFullName()
  )
}

from Function f
where
  not f.getFile() instanceof UnknownFile and
  not f.getName().matches("%init%")
select f, concat(describe(f), ", ")
