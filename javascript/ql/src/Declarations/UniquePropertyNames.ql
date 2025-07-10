/**
 * @name Overwritten property
 * @description If an object literal has two properties with the same name,
 *              the second property overwrites the first one,
 *              which makes the code hard to understand and error-prone.
 * @kind problem
 * @problem.severity error
 * @id js/overwritten-property
 * @tags reliability
 *       correctness
 *       external/cwe/cwe-563
 * @precision very-high
 */

import Expressions.Clones

/**
 * Holds if `p` is the `i`th property of object expression `o`, and its
 * kind is `kind`.
 *
 * The kind is an integer value indicating whether `p` is a value property (0),
 * a getter (1) or a setter (2).
 */
predicate hasProperty(ObjectExpr o, Property p, string name, int kind, int i) {
  p = o.getProperty(i) and
  name = p.getName() and
  kind = p.getKind()
}

/**
 * Holds if property `p` appears before property `q` in the same object literal and
 * both have the same name and kind, but are not structurally identical.
 */
predicate overwrittenBy(Property p, Property q) {
  exists(ObjectExpr o, string name, int i, int j, int kind |
    hasProperty(o, p, name, kind, i) and
    hasProperty(o, q, name, kind, j) and
    i < j
  ) and
  // exclude structurally identical properties: they are flagged by
  // the DuplicateProperty query
  not p.getInit().(DuplicatePropertyInitDetector).same(q.getInit())
}

from Property p, Property q
where
  overwrittenBy(p, q) and
  // ensure that `q` is the last property with the same name as `p`
  not overwrittenBy(q, _)
select p, "This property is overwritten by $@ in the same object literal.", q, "another property"
