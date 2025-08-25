let use_int = def_int
let use_instantiated_generic = def_instantiated_generic
let answer = use_instantiated_generic.def_generic_method(t: 42, u: "hello", v: 0.0)
let use_function = def_function
func use_generic_function_type<AA, BB, CC>(_: AA, _: BB, _: CC) {}
func use_async_function_type(_: Int) async {}
func use_throwing_function_type(_: Int) throws {}
func use_async_throwing_function_type(_: Int) async throws {}
func use_generic_function_with_conformance_type<AA, BB, CC>(_: AA, _: BB, _: CC) where AA: Protocol1, AA: Protocol2, BB: Class, CC == AA.Associated {}

extension Class {}
