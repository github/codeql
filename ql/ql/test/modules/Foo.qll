private signature module MySig {
  predicate foo();
}

private module MyImpl implements MySig {
  predicate foo() { none() }
}

private module MkThing<MySig Impl> {
  signature module SubMod {
    predicate bar();
  }
}

module SimpleMod { }

import SimpleMod

private module SecondImpl implements MkThing<MyImpl>::SubMod {
  predicate bar() { none() }
}
