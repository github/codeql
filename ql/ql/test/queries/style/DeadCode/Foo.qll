private module Mixed {
  private predicate dead1() { none() }

  predicate alive1() { none() }

  predicate dead2() { none() }
}

predicate usesAlive() { Mixed::alive1() }

cached
private module Cached {
  cached
  predicate isUsed() { any() }

  cached
  predicate isNotUsed() { any() }
}

module UseCache {
  private import Cached

  predicate usesCached() { isUsed() }
}

private module Foo {
  signature predicate bar();
}

module ValidationMethod<Foo::bar/0 sig> {
  predicate impl() { sig() }
}
