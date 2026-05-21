private import swift
private import TestUtils as TestUtils
import utils.test.InlineExpectationsTest

predicate toBeTested(Locatable e) {
  TestUtils::toBeTested(e) and
  exists(e.getLocation().getFile().getRelativePath()) and
  not e.(CallExpr).getStaticTarget().getName() =
    "_unimplementedInitializer(className:initName:file:line:column:)"
}

pragma[nomagic]
private predicate declHasPotentialCommentAt(Decl d, string path, int line) {
  d.getLocation().hasLocationInfo(path, line + 1, _, _, _)
}

pragma[nomagic]
private SingleLineComment getPrecedingComment(Decl d) {
  exists(string path, int line |
    declHasPotentialCommentAt(d, path, line) and
    result.getLocation().hasLocationInfo(path, line, _, _, _)
  )
}

predicate declHasName(Decl c, string value) {
  exists(string s |
    s = getPrecedingComment(c).getText() and
    value = s.substring(3, s.length() - 1)
  )
  or
  not exists(getPrecedingComment(c)) and
  value = [c.(EnumElementDecl).getName(), c.(Function).getName()]
}
