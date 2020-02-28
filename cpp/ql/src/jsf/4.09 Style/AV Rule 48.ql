/**
 * @name AV Rule 48
 * @description Indentifiers will not differ by: (a) only case, (b) only underscores, (c) O vs 0 and D, (d) I vs 1 and l, (e) S vs 5, (f) Z vs 2, (g) n vs h
 * @kind problem
 * @id cpp/jsf/av-rule-48
 * @problem.severity warning
 * @tags maintainability
 *       readability
 *       external/jsf
 */

import cpp

/*
 * The rule applies in an almost completely global way since that is the way it appears to be phrased, and
 * it may be sufficiently rare to be okay that way. We make a small exception: two locals in separate scopes
 * cannot trigger the rule
 *
 * Note: rule (a) interferes with the others, since H=h by (a) and h=n by (g) but surely H != n
 * For implementation it's important that this can be viewed as canonicalisation of names to avoid a quadratic
 * test but that would imply transitivity
 * To resolve this we interpret the rule as: it is a violation if
 *   - a combination of (a)-(b) makes the names identical OR
 *   - a combination of (b)-(g) makes the names identical
 */

// Implement rules (a) and (b)
predicate canonicalName1(Declaration d, string canonical) {
  canonical = d.getName().replaceAll("_", "").toLowerCase()
}

predicate canonicalName2(Declaration d, string canonical) {
  canonical =
    d
        .getName()
        .replaceAll("_", "")
        .replaceAll("0", "O")
        .replaceAll("D", "O")
        .replaceAll("1", "I")
        .replaceAll("l", "I")
        .replaceAll("S", "5")
        .replaceAll("Z", "2")
        .replaceAll("n", "h")
}

predicate same(Declaration d1, Declaration d2) {
  exists(string common | canonicalName1(d1, common) and canonicalName1(d2, common))
  or
  exists(string common | canonicalName2(d1, common) and canonicalName2(d2, common))
}

/** Is the declaration local to that function? */
predicate local(Declaration d, Function f) {
  d.(Parameter).getFunction() = f
  or
  exists(DeclStmt ds | d = ds.getADeclaration().(LocalVariable) and ds.getEnclosingFunction() = f)
}

/**
 * Is the declaration local to that struct? Reduce false warning by taking into
 * account struct lookup rules - since a struct members can never be referred to
 * other than in a qualified way it doesn't really count.
 */
predicate structLocal(Declaration d, Struct s) { d = s.getAMemberVariable() }

predicate compatibleScopes(Declaration d1, Declaration d2) {
  // Either they're both local to the same struct, or
  exists(Struct s | structLocal(d1, s) and structLocal(d2, s))
  or
  // Neither of them is a struct member and ...
  not structLocal(d1, _) and
  not structLocal(d2, _) and
  same(d1, d2) and
  (
    // d2 is global and d1 is either, or
    not local(d2, _)
    or
    // both are local to the same function
    exists(Function f | local(d1, f) and local(d2, f))
  )
}

from Declaration d1, Declaration d2
where
  d1.fromSource() and
  d2.fromSource() and
  // Test that the names are confusing according to the above criteria
  same(d1, d2) and
  d1.getName() != d2.getName() and
  (
    // either they are both type names, or
    d1 instanceof UserType and d2 instanceof UserType
    or
    // they are both variable names in close enough scopes for the confusion to matter
    d1 instanceof Variable and d2 instanceof Variable and compatibleScopes(d1, d2)
  )
select d1, "AV Rule 48: this identifier is too close to another identifier (" + d2.getName() + ")"
