signature class Foo;

class FooImpl extends string {
  FooImpl() { this = "foo" }
}

signature module ParamSig<Foo F> {
  F getThing();
}

module ParamImpl implements ParamSig<FooImpl> {
  FooImpl getThing() { any() }
}

module ParamMod<ParamSig<FooImpl> Impl> {
  FooImpl getTheThing() { result = Impl::getThing() }
}

FooImpl foo() { result = ParamMod<ParamImpl>::getTheThing() }
