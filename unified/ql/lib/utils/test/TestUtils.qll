private import unified
private import CommentUtil
private import codeql.unified.internal.StaticNameBinding

private string deriveClassName(ClassLikeDeclaration cls) {
  not exists(cls.getEnclosingClass()) and
  result = cls.getName()
  or
  result = deriveClassName(cls.getEnclosingClass()) + "." + cls.getName()
}

private string defaultName(NameBinding decl) {
  exists(ClassLikeDeclaration cls |
    decl.getDeclaration() = cls.getAMember() and
    result = deriveClassName(cls) + "." + decl.getName()
  )
  or
  not decl.getDeclaration() = any(ClassLikeDeclaration cls).getAMember() and
  result = decl.getName()
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
