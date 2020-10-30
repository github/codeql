import csharp

query predicate implicitlyTypedObjectCreation(ObjectCreation creation) {
  creation.isImplicitlyTyped()
}

query predicate implicitlyTypedDelegateCreation(ExplicitDelegateCreation creation) {
  creation.isImplicitlyTyped()
}
