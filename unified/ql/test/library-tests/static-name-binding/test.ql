import unified
import utils.test.InlineExpectationsTest
import utils.test.CommentUtil
import codeql.unified.internal.StaticNameBinding

module StaticDeclAccess implements TestSig {
  string getARelevantTag() { result = "access" }

  private string deriveClassName(ClassLikeDeclaration cls) {
    not exists(cls.getParent().getEnclosingClass()) and
    result = cls.getName().getValue()
    or
    result = deriveClassName(cls.getParent().getEnclosingClass()) + "." + cls.getName().getValue()
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

  additional predicate declAt(NameDeclaration v, string filepath, int line) {
    v.getLocation().hasLocationInfo(filepath, line, _, _, _)
  }

  private predicate decl(NameDeclaration v, string alias) {
    exists(string filepath, int line | declAt(v, filepath, line) |
      keyValueCommentAt(filepath, line, "name", alias)
      or
      not keyValueCommentAt(filepath, line, "name", _) and
      alias = defaultName(v)
    )
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(NameDeclaration decl, Identifier access |
      access = trackNameDeclaration(decl).asIdentifier() and
      not access instanceof NameDeclaration and
      location = access.getLocation() and
      element = access.toString() and
      decl(decl, value) and
      tag = "access"
    )
  }
}

import MakeTest<StaticDeclAccess>
