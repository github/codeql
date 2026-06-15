public class Test {

  val lazyVal: Int by lazy { 5 }

  // Both of these constructors will need to extract the implicit classes created by `lazyVal` and initialize it--
  // This test checks we don't introduce any inconsistency this way.

  constructor(x: Int) { }

  constructor(y: String) { }

}
