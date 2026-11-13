import codeql.unified.internal.typeinference.Type
import codeql.unified.internal.typeinference.TypeMention
import codeql.unified.internal.typeinference.TypeInference

private class Actual extends Identifier {
  Actual() {
    this.getValue().matches("bound%Actual") and
    this.getFile().getBaseName() = "variance.swift" and
    exists(inferType(this, TypePath::nil()))
  }

  Type getTypeAt(TypePath path) { result = inferType(this, path) }
}

private module Input implements VarianceMatchingInputSig<Actual, TypeMention> {
  predicate relevantConstraint(Actual actual, TypeMention constraint) {
    exists(actual) and
    constraint =
      any(FunctionDeclaration f |
        actual.getValue() = f.getName() + "Actual" and f.getFile().getBaseName() = "variance.swift"
      ).getParameter(0).getType()
  }
}

private module Match = VarianceMatching<Actual, TypeMention, Input>;

query predicate bounds(string name, string parameter, int relation, string path, string type) {
  exists(Actual actual, TypeMention constraint, TypeParameter tp, TypePath p, Type t |
    Match::typeBound(actual, constraint, tp, relation, p, t) and
    name = actual.getValue() and
    parameter = tp.toString() and
    path = TypePath::printTypePathVerbose(p) and
    type = t.toString()
  )
}

query predicate noBounds(string name) {
  exists(Actual actual | name = actual.getValue() and not Match::typeBound(actual, _, _, _, _, _))
}
