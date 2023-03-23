var x = 42

struct Generic<T> {}

var instantiated_generic = Generic<Int>()

func function(_: Int) -> Int { return 42 }
