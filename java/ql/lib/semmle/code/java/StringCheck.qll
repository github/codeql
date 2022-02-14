/**
 * Provides classes and predicates for reasoning about checking characterizations about strings.
 */

import java

/**
 * Holds if `ma` is a call to a method that checks a partial string match.
 */
predicate isStringPartialMatch(MethodAccess ma) {
    ma.getMethod().getDeclaringType() instanceof TypeString and
    ma.getMethod().getName() =
      ["contains", "startsWith", "matches", "regionMatches", "indexOf", "lastIndexOf"]
  }
