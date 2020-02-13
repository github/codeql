/**
 * @name Bad redirect check
 * @description A redirect check that checks for a leading slash but not two
 *              leading slashes or a leading slash followed by a backslash is
 *              incomplete.
 * @kind problem
 * @problem.severity warning
 * @id go/bad-redirect-check
 * @tags security
 *       external/cwe/cwe-601
 * @precision high
 */

import go

StringOps::HasPrefix checkForLeadingSlash(SsaWithFields v) {
  exists(DataFlow::Node substr |
    result.getBaseString() = v.getAUse() and result.getSubstring() = substr
  |
    substr.getStringValue() = "/"
  )
}

DataFlow::Node checkForSecondSlash(SsaWithFields v) {
  exists(StringOps::HasPrefix hp | result = hp and hp.getBaseString() = v.getAUse() |
    hp.getSubstring().getStringValue() = "//"
  )
  or
  exists(DataFlow::EqualityTestNode eq, DataFlow::Node slash, DataFlow::ElementReadNode er |
    result = eq
  |
    slash.getStringValue() = "/" and
    er.getBase() = v.getAUse() and
    er.getIndex().getIntValue() = 1 and
    eq.eq(_, er, slash)
  )
}

DataFlow::Node checkForSecondBackslash(SsaWithFields v) {
  exists(StringOps::HasPrefix hp | result = hp and hp.getBaseString() = v.getAUse() |
    hp.getSubstring().getStringValue() = "/\\"
  )
  or
  exists(DataFlow::EqualityTestNode eq, DataFlow::Node slash, DataFlow::ElementReadNode er |
    result = eq
  |
    slash.getStringValue() = "\\" and
    er.getBase() = v.getAUse() and
    er.getIndex().getIntValue() = 1 and
    eq.eq(_, er, slash)
  )
}

from DataFlow::Node node, SsaWithFields v
where
  // there is a check for a leading slash
  node = checkForLeadingSlash(v) and
  // but not a check for both a second slash and a second backslash
  not (exists(checkForSecondSlash(v)) and exists(checkForSecondBackslash(v))) and
  v.getQualifiedName().regexpMatch("(?i).*url.*|.*redir.*|.*target.*")
select node,
  "This expression checks '$@' for a leading slash but checks do not exist for both '/' and '\\' in the second position.",
  v, v.getQualifiedName()
