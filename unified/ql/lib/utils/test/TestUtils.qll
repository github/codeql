private import unified
private import CommentUtil
private import codeql.unified.internal.NameBinding
private import codeql.unified.internal.typeinference.TypeInferencePlugin

private string deriveClassName(ClassLikeDeclaration cls) {
  not exists(cls.getEnclosingClass()) and
  result = cls.getName()
  or
  result = getStaticBindingTargetFromRef(cls.getExtensionTarget()).getValue()
  or
  result = deriveClassName(cls.getEnclosingClass()) + "." + cls.getName()
}

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
      decl.getDeclaration() = cls.getAMember() and
      result = deriveClassName(cls) + "." + name
    )
    or
    not decl.getDeclaration() = any(ClassLikeDeclaration cls).getAMember() and
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

private string getCallableName(Callable c) {
  result = c.(AccessorDeclaration).getName()
  or
  result = c.(ConstructorDeclaration).getName()
  or
  c instanceof DestructorDeclaration and
  result = "<destructor>"
  or
  result = c.(FunctionDeclaration).getName()
  or
  c instanceof InitializerDeclaration and
  result = "<initializer>"
}

private string defaultCallableName(Callable c) {
  exists(ClassLikeDeclaration cls |
    c = cls.getAMember() and
    result = deriveClassName(cls) + "." + getCallableName(c)
  )
  or
  not c = any(ClassLikeDeclaration cls).getAMember() and
  result = getCallableName(c)
  or
  exists(ClassLikeDeclaration enum |
    enum = c.(EnumConstructor).getEnum() and
    result = deriveClassName(enum) + "." + c.getEnclosingClass().getName()
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
    alias = defaultCallableName(c)
  )
}
