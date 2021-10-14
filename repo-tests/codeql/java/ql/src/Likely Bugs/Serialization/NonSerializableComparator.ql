/**
 * @name Non-serializable comparator
 * @description A comparator that is passed to an ordered collection (for example, a treemap) must be
 *              serializable, otherwise the collection fails to serialize at run-time.
 * @kind problem
 * @problem.severity warning
 * @precision low
 * @id java/non-serializable-comparator
 * @tags reliability
 *       maintainability
 *       language-features
 */

import java

predicate nonSerializableComparator(Class c) {
  exists(TypeSerializable serializable, GenericInterface comparator |
    comparator.hasQualifiedName("java.util", "Comparator") and
    c.getASourceSupertype+() = comparator and
    not c.getASourceSupertype+() = serializable and
    c.fromSource()
  )
}

predicate sortedCollectionBaseType(RefType t) {
  t.hasName("SortedSet") or
  t.hasName("SortedMap") or
  t.hasName("PriorityQueue")
}

predicate sortedCollectionType(RefType t) {
  sortedCollectionBaseType(t.getASupertype*().getSourceDeclaration())
}

string nameFor(Class c) {
  nonSerializableComparator(c) and
  (
    c instanceof AnonymousClass and result = "This comparator"
    or
    not c instanceof AnonymousClass and result = c.getName()
  )
}

from Class c, Expr arg, ClassInstanceExpr cie
where
  nonSerializableComparator(c) and
  c = arg.getType() and
  arg = cie.getAnArgument() and
  sortedCollectionType(cie.getType())
select arg,
  nameFor(c) + " is not serializable, so should not be used as the comparator in a " +
    cie.getType().getName() + "."
