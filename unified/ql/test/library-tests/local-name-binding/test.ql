import unified
import utils.test.InlineExpectationsTest
import utils.test.CommentUtil
import codeql.unified.internal.LocalNameBinding

module VariableAccessTest implements TestSig {
  string getARelevantTag() { result = ["access", "implicit-qualifier"] }

  additional predicate declAt(LocalName v, string filepath, int line) {
    v.getLocation().hasLocationInfo(filepath, line, _, _, _)
  }

  private predicate decl(LocalName v, string alias) {
    exists(string filepath, int line, string tag |
      declAt(v, filepath, line) and
      if exists(v.getABinding())
      then
        // explicit declarations must be annotated with 'name'
        tag = "name"
      else (
        // implicit declarations have their own tags
        v.getName() = "self" and tag = "implicit-self"
      )
    |
      keyValueCommentAt(filepath, line, tag, alias)
      or
      not keyValueCommentAt(filepath, line, tag, _) and
      alias = v.getName()
    )
  }

  private PotentialLocalNameAccess getUniqueDeclarationSite(LocalName name) {
    result = unique(PotentialLocalNameAccess ac | ac.isBindingSite() and ac.getLocalName() = name)
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
    or
    exists(UnqualifiedMemberAccess access, LocalName v |
      v = access.getImplicitQualifierVariable() and
      location = access.getLocation() and
      element = access.toString() and
      decl(v, value) and
      access.isInstanceAccess() and // For now, don't annotate receiver access in static methods. It technically exists, it's just not important yet.
      tag = "implicit-qualifier"
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
