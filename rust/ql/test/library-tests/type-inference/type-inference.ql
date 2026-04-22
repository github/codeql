import rust
import utils.test.InlineExpectationsTest
import codeql.rust.internal.typeinference.Type
import codeql.rust.internal.typeinference.TypeInference as TypeInference
import TypeInference

private predicate relevantNode(AstNode n) {
  n.fromSource() and
  not n.isFromMacroExpansion() and
  not n instanceof IdentPat and // avoid overlap in the output with the underlying `Name` node
  not n instanceof LiteralPat // avoid overlap in the output with the underlying `Literal` node
}

query predicate inferCertainType(AstNode n, TypePath path, Type t) {
  t = TypeInference::CertainTypeInference::inferCertainType(n, path) and
  t != TUnknownType() and
  relevantNode(n)
}

query predicate inferType(AstNode n, TypePath path, Type t) {
  t = TypeInference::inferType(n, path) and
  t != TUnknownType() and
  relevantNode(n)
}

module ResolveTest implements TestSig {
  string getARelevantTag() { result = ["target", "fieldof"] }

  private predicate functionHasValue(Function f, string value) {
    f.getAPrecedingComment().getCommentText() = value and
    f.fromSource()
    or
    not any(f.getAPrecedingComment()).fromSource() and
    // TODO: Default to canonical path once that is available
    value = f.getName().getText()
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(AstNode source, AstNode target |
      location = source.getLocation() and
      element = source.toString() and
      source.fromSource() and
      not source.isFromMacroExpansion()
    |
      target = source.(Call).getStaticTarget() and
      functionHasValue(target, value) and
      // `isFromMacroExpansion` does not always work
      not target.(Function).getName().getText() = ["panic_fmt", "_print", "format", "must_use"] and
      tag = "target"
      or
      target = resolveStructFieldExpr(source, _) and
      any(Struct s | s.getStructField(_) = target).getName().getText() = value and
      tag = "fieldof"
      or
      target = resolveTupleFieldExpr(source, _) and
      any(Struct s | s.getTupleField(_) = target).getName().getText() = value and
      tag = "fieldof"
    )
  }
}

module TypeTest implements TestSig {
  string getARelevantTag() { result = ["type", "certainType"] }

  predicate tagIsOptional(string expectedTag) { expectedTag = "type" }

  predicate hasActualResult(Location location, string element, string tag, string value) { none() }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(AstNode n, TypePath path, Type t |
      t = TypeInference::inferType(n, path) and
      (
        tag = "type"
        or
        t = TypeInference::CertainTypeInference::inferCertainType(n, path) and
        tag = "certainType"
      ) and
      location = n.getLocation() and
      (
        if path.isEmpty()
        then value = element + ":" + t
        else value = element + ":" + path.toString() + "." + t.toString()
      ) and
      element = [n.toString(), n.(IdentPat).getName().getText()]
    )
  }
}

import MakeTest<MergeTests<ResolveTest, TypeTest>>
