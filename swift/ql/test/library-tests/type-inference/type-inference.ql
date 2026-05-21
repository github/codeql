import swift
import Common

module ResolveTest implements TestSig {
  string getARelevantTag() { result = "target" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstNode source, Decl target |
      location = source.getLocation() and
      element = source.toString() and
      target =
        [
          source.(CallExpr).getStaticTarget().(Decl),
          source.(MethodLookupExpr).getMember(),
          source.(EnumElementPattern).getElement()
        ] and
      declHasName(target, value) and
      tag = "target" and
      toBeTested(source)
    )
  }
}

private Type getTypeAt(Type t, string path) {
  path = "" and
  result = t.getUnderlyingType()
  or
  exists(BoundGenericType b, GenericTypeDecl decl |
    b = t and
    decl = b.getDeclaration()
  |
    exists(string prefix, string suffix, int i |
      result = getTypeAt(b.getArgType(i).getUnderlyingType(), suffix) and
      prefix = decl.getName() + "<" + decl.getGenericTypeParam(i).getName() + ">" and
      if suffix = "" then path = prefix else path = prefix + "." + suffix
    )
  )
}

module TypeTest implements TestSig {
  string getARelevantTag() { result = "type" }

  predicate hasActualResult(Location location, string element, string tag, string value) { none() }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(Locatable e, string path, Type t, Type t0 |
      t = [e.(Expr).getType(), e.(VarDecl).getType()] and
      tag = "type" and
      location = e.getLocation() and
      t0 = getTypeAt(t, path) and
      exists(string name, string at |
        name = t0.(AnyGenericType).getDeclaration().getName()
        or
        not t0 instanceof AnyGenericType and
        name = t0.getName()
      |
        (if path = "" then at = "" else at = "@" + path) and
        value = element + at + ":" + name and
        element = e.toString()
      )
    )
  }
}

import MakeTest<MergeTests<ResolveTest, TypeTest>>
