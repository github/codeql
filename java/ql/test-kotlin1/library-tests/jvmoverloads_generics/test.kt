public class A {

  @JvmOverloads
  fun <T> genericFunctionWithOverloads(x: T? = null, y: List<T>? = null, z: T? = null): T? = z

}
