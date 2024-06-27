class Test<T : Number, S : T, R> {

  fun <Q : Number> f() { }

}

class MultipleBounds<P> where P : List<String>, P : Set<String> { }

class RecursiveBound<T : RecursiveBound<T>> { }

class MutualRecursiveBound<T : MutualRecursiveBound<T, S>, S : MutualRecursiveBound<T, S>> { }
