var def_int = 42

struct Generic<T> {}

var def_instantiated_generic = Generic<Int>()

func def_function(_: Int) -> Int { return 42 }

func def_generic_function<A, B>(_: A, _: B) {}
