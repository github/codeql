private import unified
private import CommentUtil
private import codeql.unified.internal.NameBinding
private import codeql.unified.internal.typeinference.TypeInference as TypeInference
private import codeql.unified.internal.typeinference.TypeInferencePlugin

private string getTupleFieldName(NameBinding decl) {
  decl = any(TupleType tt).getField(result).getPattern()
}

private string defaultName(NameBinding decl) {
  exists(string name |
    name = getTupleFieldName(decl)
    or
    not exists(getTupleFieldName(decl)) and name = decl.getName()
  |
    exists(ClassLikeDeclaration cls |
      decl.getDeclaration() = cls.getAMemberIncludingExtensions() and
      result = cls.getQualifiedName() + "." + name
    )
    or
    not decl.getDeclaration() = any(ClassLikeDeclaration cls).getAMemberIncludingExtensions() and
    result = name
  )
}

private predicate declAt(NameBinding v, string filepath, int line) {
  v.getLocation().hasLocationInfo(filepath, line, _, _, _)
}

/** Holds if the name-binding `v` has been assigned the given `alias` by a comment in the test code. */
predicate nameBinding(NameBinding v, string alias) {
  exists(string filepath, int line | declAt(v, filepath, line) |
    keyValueCommentAt(filepath, line, "name", alias)
    or
    not keyValueCommentAt(filepath, line, "name", _) and
    alias = defaultName(v)
  )
}

private predicate callableAt(Callable c, string filepath, int line) {
  c.getLocation().hasLocationInfo(filepath, line, _, _, _)
}

/** Holds if the callable `c` has been assigned the given `alias` by a comment in the test code. */
predicate callableName(Callable c, string alias) {
  exists(string filepath, int line | callableAt(c, filepath, line) |
    keyValueCommentAt(filepath, line, "name", alias)
    or
    not keyValueCommentAt(filepath, line, "name", _) and
    (
      not c instanceof EnumCaseConstructor and
      alias = c.(Member).getQualifiedName()
      or
      alias = c.(EnumCaseConstructor).getEnumCaseClass().getQualifiedName()
    )
  )
}
