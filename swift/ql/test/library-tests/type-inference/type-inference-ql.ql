import Common
import codeql.swift.internal.typeinference.Type
import codeql.swift.internal.typeinference.TypeInference as TypeInference
import TypeInference

query predicate inferType(AstNode n, TypePath path, Type t) {
  t = TypeInference::inferType(n, path) and
  t != TUnknownType() and
  toBeTested(n)
}

module ResolveTest implements TestSig {
  string getARelevantTag() { result = "target" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstNode source, Decl target |
      location = source.getLocation() and
      element = source.toString() and
      target =
        [
          TypeInference::getCallTarget(source).(Decl),
          source.(EnumElementPattern).getElement()
        ] and
      declHasName(target, value) and
      tag = "target" and
      toBeTested(source)
    )
  }
}

module TypeTest implements TestSig {
  string getARelevantTag() { result = "type" }

  predicate hasActualResult(Location location, string element, string tag, string value) { none() }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(AstNode n, TypePath path, Type t, string at |
      t = TypeInference::inferType(n, path) and
      tag = "type" and
      location = n.getLocation() and
      (if path.isEmpty() then at = "" else at = "@" + TypePath::printTypePathVerbose(path)) and
      value = element + at + ":" + t.toString() and
      element = n.toString()
    )
  }
}

import MakeTest<MergeTests<ResolveTest, TypeTest>>
