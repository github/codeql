module PredicateSig {
  signature predicate fooSig(int i);

  module UsesFoo<fooSig/1 fooImpl> {
    predicate bar(int i) { fooImpl(i + 1) }
  }

  predicate myFoo(int i) { i = 42 }

  predicate use(int i) { UsesFoo<myFoo/1>::bar(i) }
}

module ClassSig {
  // TODO:
}

module ModuleSig {
  // TODO:
}
