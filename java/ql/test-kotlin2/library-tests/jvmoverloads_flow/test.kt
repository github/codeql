fun getString() = "Hello world"

fun source() = "tainted"

fun sink(s: String) { }

object Test {

  @JvmOverloads @JvmStatic
  fun taintSuppliedAsDefault(before: Int, s: String = source(), after: Int) { sink(s) }
  
  @JvmOverloads @JvmStatic
  fun noTaintByDefault(before: Int, s: String = "no taint", after: Int, after2: Int = 1) { sink(s) }

}

public class Test2 {

  companion object {

    @JvmOverloads @JvmStatic
    fun taintSuppliedAsDefaultStatic(before: Int, s: String = source(), after: Int) { sink(s) }

    @JvmOverloads @JvmStatic
    fun noTaintByDefaultStatic(before: Int, s: String = "no taint", after: Int, after2: Int = 1) { sink(s) }

  }

  @JvmOverloads
  fun taintSuppliedAsDefault(before: Int, s: String = source(), after: Int) { sink(s) }

  @JvmOverloads
  fun noTaintByDefault(before: Int, s: String = "no taint", after: Int, after2: Int = 1) { sink(s) }

}

public class GenericTest<T> {

  @JvmOverloads
  fun taintSuppliedAsDefault(before: T, s: String = source(), after: T) { sink(s) }

  @JvmOverloads
  fun noTaintByDefault(before: T, s: String = "no taint", after: T, after2: Int = 1) { sink(s) }

}

public class ConstructorTaintsByDefault @JvmOverloads constructor(before: Int, s: String = source(), after: Int) {

  init {
    sink(s)
  }

}

public class ConstructorDoesNotTaintByDefault @JvmOverloads constructor(before: Int, s: String = "no taint", after: Int, after2: Int = 1) {

  init {
    sink(s)
  }
   
}

public class GenericConstructorTaintsByDefault<T> @JvmOverloads constructor(before: T, s: String = source(), after: T) {  

  init {
    sink(s)
  }
   
}
 
public class GenericConstructorDoesNotTaintByDefault<T> @JvmOverloads constructor(before: T, s: String = "no taint", after: T, after2: T? = null) { 

  init {
    sink(s)
  }

}

fun ident(s: String) = s

public class TestDefaultParameterReference {

  @JvmOverloads fun f(x: String, y: String = ident(x)) {
    sink(y)
  }

}
