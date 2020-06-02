import semmle.code.csharp.Unification

class InterestingType extends @type {
  InterestingType() {
    this.(Type).fromSource() or
    this.(TupleType).getAChild() instanceof InterestingType
  }

  string toString() {
    result = this.(Type).getQualifiedNameWithTypes()
    or
    not exists(this.(Type).getQualifiedNameWithTypes()) and
    result = this.(Type).toStringWithTypes()
  }

  Location getLocation() { result = this.(Type).getLocation() }
}

query predicate constrainedTypeParameterSubsumes(InterestingType tp, InterestingType t) {
  tp.(Unification::ConstrainedTypeParameter).subsumes(t)
}

// Should be empty
query predicate constrainedTypeParameterSubsumptionImpliesUnification(Type tp, Type t) {
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
