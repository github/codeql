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

DataFlow::Node checkForLeadingSlash(ValueEntity v) {
  exists(StringOps::HasPrefix hp, DataFlow::Node substr |
    result = hp and hp.getBaseString() = v.getARead() and hp.getSubstring() = substr
  |
    substr.getStringValue() = "/"
    or
    substr.getIntValue() = 47 // ASCII value for '/'
  )
}

DataFlow::Node checkForSecondSlash(ValueEntity v) {
  exists(StringOps::HasPrefix hp | result = hp and hp.getBaseString() = v.getARead() |
    hp.getSubstring().getStringValue() = "//"
  )
  or
  exists(DataFlow::EqualityTestNode eq, DataFlow::Node slash, DataFlow::ElementReadNode er |
    result = eq
  |
    slash.getIntValue() = 47 and // ASCII value for '/'
    er.getBase() = v.getARead() and
    er.getIndex().getIntValue() = 1 and
    eq.eq(_, er, slash)
  )
}

DataFlow::Node checkForSecondBackslash(ValueEntity v) {
  exists(StringOps::HasPrefix hp | result = hp and hp.getBaseString() = v.getARead() |
    hp.getSubstring().getStringValue() = "/\\"
  )
  or
  exists(DataFlow::EqualityTestNode eq, DataFlow::Node slash, DataFlow::ElementReadNode er |
    result = eq
  |
    slash.getIntValue() = 92 and // ASCII value for '\'
    er.getBase() = v.getARead() and
    er.getIndex().getIntValue() = 1 and
    eq.eq(_, er, slash)
  )
}

predicate isBadRedirectCheck(DataFlow::Node node, ValueEntity v) {
  node = checkForLeadingSlash(v) and
  not (exists(checkForSecondSlash(v)) and exists(checkForSecondBackslash(v)))
}

from DataFlow::Node node, ValueEntity v
where
  isBadRedirectCheck(node, v) and
  v.getName().regexpMatch("(?i).*url.*|.*redir.*|.*target.*")
select node,
  "This expression checks '$@' for a leading slash but checks do not exist for both '/' and '\\' in the second position.",
  v, v.getName()
