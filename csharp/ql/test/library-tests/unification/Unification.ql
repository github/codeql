import semmle.code.csharp.Unification

class InterestingType extends Type {
  InterestingType() {
    this.fromSource() or
    this.(TupleType).getAChild() instanceof InterestingType
  }
}

query predicate constrainedTypeParameterSubsumes(InterestingType tp, InterestingType t) {
  tp.(Unification::ConstrainedTypeParameter).subsumes(t)
}

// Should be empty
query predicate constrainedTypeParameterSubsumptionImpliesUnification(
  InterestingType tp, InterestingType t
) {
  tp.(Unification::ConstrainedTypeParameter).subsumes(t) and
  not tp.(Unification::ConstrainedTypeParameter).unifiable(t)
}

query predicate constrainedTypeParameterUnifiable(InterestingType tp, InterestingType t) {
  tp.(Unification::ConstrainedTypeParameter).unifiable(t)
}

query predicate subsumes(InterestingType t1, InterestingType t2) { Unification::subsumes(t1, t2) }

// Should be empty
query predicate subsumptionImpliesUnification(Type t1, Type t2) {
  Unification::subsumes(t1, t2) and
  not Unification::unifiable(t1, t2)
}

query predicate unifiable(InterestingType t1, InterestingType t2) {
  Unification::unifiable(t1, t2) and
  not Unification::subsumes(t1, t2)
}

// Should be empty
query predicate unificationImpliesCompatible(Type t1, Type t2) {
  Unification::unifiable(t1, t2) and
  not Unification::compatible(t1, t2)
}

// Should be empty
query predicate validTypeParameterImpliesCompatible(Type t1, Type t2) {
  (
    t1.(Unification::ConstrainedTypeParameter).unifiable(t2)
    or
    t1 instanceof Unification::UnconstrainedTypeParameter
    or
    t2 instanceof Unification::UnconstrainedTypeParameter
  ) and
  not Unification::compatible(t1, t2)
}

query predicate compatible(InterestingType t1, InterestingType t2) {
  Unification::compatible(t1, t2) and
  not Unification::unifiable(t1, t2) and
  not t1.(Unification::ConstrainedTypeParameter).unifiable(t2) and
  not t2.(Unification::ConstrainedTypeParameter).unifiable(t1) and
  not t1 instanceof Unification::UnconstrainedTypeParameter and
  not t2 instanceof Unification::UnconstrainedTypeParameter
}
