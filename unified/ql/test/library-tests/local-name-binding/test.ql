import unified
import utils.test.InlineExpectationsTest
import utils.test.CommentUtil
import codeql.unified.internal.LocalNameBinding

module VariableAccessTest implements TestSig {
  string getARelevantTag() { result = "access" }

  additional predicate declAt(LocalName v, string filepath, int line) {
    v.getLocation().hasLocationInfo(filepath, line, _, _, _)
  }

  private predicate decl(LocalName v, string alias) {
    exists(string filepath, int line | declAt(v, filepath, line) |
      keyValueCommentAt(filepath, line, "name", alias)
      or
      not keyValueCommentAt(filepath, line, "name", _) and
      alias = v.getName()
    )
  }

  private PotentialLocalNameAccess getUniqueDeclarationSite(LocalName name) {
    result =
      unique(PotentialLocalNameAccess ac | ac.isDeclarationSite() and ac.getLocalName() = name)
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(PotentialLocalNameAccess va, LocalName v |
      v = va.getLocalName() and
      not va = getUniqueDeclarationSite(v) and // no need to annotate declaration site, if there is only one
      location = va.getLocation() and
      element = va.toString() and
      decl(v, value) and
      tag = "access"
    )
  }
}

import MakeTest<VariableAccessTest>

private LocalName getVariableAt(string name, string filepath, int line) {
  VariableAccessTest::declAt(result, filepath, line) and
  result.getName() = name
}

query predicate ambiguousVariable(LocalName v, string name, string filepath, int line) {
  v = getVariableAt(name, filepath, line) and
  strictcount(getVariableAt(name, filepath, line)) >= 2
}
