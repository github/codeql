var def_int = 42

struct Generic<T> {}

var def_instantiated_generic = Generic<Int>()

func def_function(_: Int) -> Int { return 42 }
