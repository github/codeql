import ql

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

signature module InputSig {
  predicate foo();
}

module ParameterizedModule<InputSig Input> { }

private module Input1 implements InputSig {
  predicate foo() { any() }
}

private module Input2 implements InputSig {
  predicate foo() { any() }
}

private module Input3 implements InputSig {
  predicate foo() { any() }
}

module M1 = ParameterizedModule<Input1>;

private module M2 = ParameterizedModule<Input2>;

import ParameterizedModule<Input3>

private module MImpl { }

module MPublic = MImpl;

private class CImpl1 extends AstNode { }

final class CPublic1 = CImpl1;

private class CImpl2 extends AstNode { }
