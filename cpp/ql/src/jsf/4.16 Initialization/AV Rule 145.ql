/**
 * @name Irregular enum initialization
 * @description In an enumerator list, the = construct should not be used to explicitly initialize members other than the first, unless all items are explicitly initialized. An exception is the pattern to use the last element of an enumerator list to get the number of possible values.
 * @kind problem
 * @problem.severity recommendation
 * @precision high
 * @id cpp/irregular-enum-init
 * @tags reliability
 *       readability
 *       language-features
 *       external/jsf
 */

import cpp

predicate hasInitializer(EnumConstant c) { c.getInitializer().fromSource() }

/** Does this have an initializer that is not just a ref to another constant in the same enum? */
predicate hasNonReferenceInitializer(EnumConstant c) {
  exists(Initializer init |
    init = c.getInitializer() and
    init.fromSource() and
    not init.getExpr().(EnumConstantAccess).getTarget().getDeclaringEnum() = c.getDeclaringEnum()
  )
}

predicate hasReferenceInitializer(EnumConstant c) {
  exists(Initializer init |
    init = c.getInitializer() and
    init.fromSource() and
    init.getExpr().(EnumConstantAccess).getTarget().getDeclaringEnum() = c.getDeclaringEnum()
  )
}

/**
 * Gets the `rnk`'th (1-based) enumeration constant in `e` that does not have a
 * reference initializer (i.e., an initializer that refers to an enumeration
 * constant from the same enumeration).
 */
EnumConstant getNonReferenceInitializedEnumConstantByRank(Enum e, int rnk) {
  result =
    rank[rnk](EnumConstant cand, int pos, string filepath, int startline, int startcolumn |
      e.getEnumConstant(pos) = cand and
      not hasReferenceInitializer(cand) and
      cand.getLocation().hasLocationInfo(filepath, startline, startcolumn, _, _)
    |
      cand order by pos, filepath, startline, startcolumn
    )
}

/**
 * Holds if `ec` is not the last enumeration constant in `e` that has a non-
 * reference initializer.
 */
predicate hasNextWithoutReferenceInitializer(Enum e, EnumConstant ec) {
  exists(int rnk |
    ec = getNonReferenceInitializedEnumConstantByRank(e, rnk) and
    exists(getNonReferenceInitializedEnumConstantByRank(e, rnk + 1))
  )
}

// There exists another constant whose value is implicit, but it's
// not the last one: the last value is okay to use to get the highest
// enum value automatically. It can be followed by aliases though.
predicate enumThatHasConstantWithImplicitValue(Enum e) {
  exists(EnumConstant ec |
    ec = e.getAnEnumConstant() and
    not hasInitializer(ec) and
    hasNextWithoutReferenceInitializer(e, ec)
  )
}

from Enum e, int i
where
  // e is at position i, and has an explicit value in the source - but
  // not just a reference to another enum constant
  hasNonReferenceInitializer(e.getEnumConstant(i)) and
  // but e is not the first or the last constant of the enum
  i != 0 and
  exists(e.getEnumConstant(i + 1)) and
  // and there exists another constant whose value is implicit, but it's
  // not the last one: the last value is okay to use to get the highest
  // enum value automatically. It can be followed by aliases though.
  enumThatHasConstantWithImplicitValue(e)
select e,
  "In an enumerator list, the = construct should not be used to explicitly initialize members other than the first, unless all items are explicitly initialized."
