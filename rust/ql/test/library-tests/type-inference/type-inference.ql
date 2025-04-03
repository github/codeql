import rust
import utils.test.InlineExpectationsTest
import codeql.rust.internal.TypeInference as TypeInference
import TypeInference

query predicate inferType(AstNode n, TypePath path, Type t) {
  t = TypeInference::inferType(n, path)
}

module ResolveTest implements TestSig {
  string getARelevantTag() { result = ["method", "fieldof"] }

  private predicate functionHasValue(Function f, string value) {
    f.getAPrecedingComment().getCommentText() = value
    or
    not exists(f.getAPrecedingComment()) and
    value = f.getName().getText()
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstNode source, AstNode target |
      location = source.getLocation() and
      element = source.toString()
    |
      target = resolveMethodCallExpr(source) and
      functionHasValue(target, value) and
      tag = "method"
      or
      target = resolveStructFieldExpr(source) and
      any(Struct s | s.getStructField(_) = target).getName().getText() = value and
      tag = "fieldof"
      or
      target = resolveTupleFieldExpr(source) and
      any(Struct s | s.getTupleField(_) = target).getName().getText() = value and
      tag = "fieldof"
    )
  }
}

module TypeTest implements TestSig {
  string getARelevantTag() { result = "type" }

  predicate tagIsOptional(string expectedTag) { expectedTag = "type" }

  predicate hasActualResult(Location location, string element, string tag, string value) { none() }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    tag = "type" and
    exists(AstNode n, TypePath path, Type t |
      t = TypeInference::inferType(n, path) and
      location = n.getLocation() and
      element = n.toString() and
      if path.isEmpty()
      then value = element + ":" + t
      else value = element + ":" + path.toString() + "." + t.toString()
    )
  }
}

import MakeTest<MergeTests<ResolveTest, TypeTest>>
