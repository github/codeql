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
