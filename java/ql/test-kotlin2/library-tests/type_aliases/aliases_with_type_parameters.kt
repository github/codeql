class Test<T> {}

typealias Alias2<R> = Test<R>

typealias Alias1<S> = Alias2<S>

fun f() : Alias1<String> = Test<String>()
