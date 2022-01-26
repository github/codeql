/**
 * @name Should be non-member predicate
 * @description A predicate that does not use `this` nor any fields should be a non-member predicate instead.
 * @kind problem
 * @problem.severity recommendation
 * @id ql/should-be-non-member
 * @precision medium
 */

import ql

from ClassPredicate p
where
  // no this/super/field access
  not exists(ThisAccess t | t.getEnclosingPredicate() = p) and
  not exists(Super s | s.getEnclosingPredicate() = p) and
  not exists(FieldAccess f | f.getEnclosingPredicate() = p) and
  // doesn't call a "this" method using an implicit this.
  not exists(PredicateCall call |
    call.getEnclosingPredicate() = p and
    call.getTarget().(ClassPredicate).getParent().getType() =
      p.getParent().getType().getASuperType*()
  ) and
  // not a trivial predicate
  not p.getBody() instanceof NoneCall and
  not p.getBody() instanceof AnyCall and
  exists(p.getBody()) and
  not p.getBody().(ComparisonFormula).getOperator() = "=" and // single "assignment"
  not p.getBody() instanceof InstanceOf and // just a single "assignment" using instanceof
  // not an override, and is not overriden
  not p.isOverride() and // isn't an override
  not exists(ClassPredicate other | other.overrides(p)) and // and isn't overridden
  // location stuff is fine
  not p.getName() = ["hasLocationInfo", "getLocation"] and
  // private is OK - it's usually an internal utility predicate
  not p.isPrivate() and
  // if it's called from another file, having it inside a class works as "name-spacing".
  not exists(Call c | c.getTarget() = p | c.getLocation().getFile() != p.getLocation().getFile()) and
  // if multiple predicates have the same name in the same file, keeping them in the class works as "name-spcaing"
  not exists(Predicate other |
    other.getName() = p.getName() and
    other.getLocation().getFile() = p.getLocation().getFile() and
    other != p
  )
select p, p.getParent().getName() + "." + p.getName() + " could be a non-member predicate instead."
