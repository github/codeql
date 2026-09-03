private import unified
private import CommentUtil
private import codeql.unified.internal.StaticNameBinding

private string deriveClassName(ClassLikeDeclaration cls) {
  not exists(cls.getParent().getEnclosingClass()) and
  result = cls.getNameNode().getValue()
  or
  result = deriveClassName(cls.getParent().getEnclosingClass()) + "." + cls.getNameNode().getValue()
}

private string defaultName(NameDeclaration decl) {
  exists(ClassLikeDeclaration cls |
    decl.getDeclaration() = cls.getAMember() and
    result = deriveClassName(cls) + "." + decl.getName()
  )
  or
  not decl.getDeclaration() = any(ClassLikeDeclaration cls).getAMember() and
  result = decl.getName()
}

private predicate declAt(NameDeclaration v, string filepath, int line) {
  v.getLocation().hasLocationInfo(filepath, line, _, _, _)
}

predicate nameDeclaration(NameDeclaration v, string alias) {
  exists(string filepath, int line | declAt(v, filepath, line) |
    keyValueCommentAt(filepath, line, "name", alias)
    or
    not keyValueCommentAt(filepath, line, "name", _) and
    alias = defaultName(v)
  )
}
