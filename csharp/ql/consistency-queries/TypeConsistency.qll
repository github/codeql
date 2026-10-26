import csharp
import semmle.code.csharp.Unification

query predicate missingGvn(Type t, string cls) {
  not exists(Gvn::getGlobalValueNumber(t)) and
  cls = t.getPrimaryQlClasses()
}

query predicate multipleGvn(Type t, Gvn::GvnType g, string cls) {
  g = Gvn::getGlobalValueNumber(t) and
  strictcount(Gvn::getGlobalValueNumber(t)) > 1 and
  cls = t.getPrimaryQlClasses()
}
