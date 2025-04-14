public class Test {

  @JvmOverloads fun f(x: Int = 0, y: Int) { }

}

public class AllDefaultsConstructor(val x: Int = 1, val y: Int = 2) { }

public annotation class AllDefaultsAnnotation(val x: Int = 1, val y: Int = 2) { }

public class AllDefaultsExplicitNoargConstructor(val x: Int = 1, val y: Int = 2) {

  constructor() : this(3, 4) { }

}
