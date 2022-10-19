fun sink(a: Any?) { }

class TestMember {

  fun f(x: String, y: String = x, z: String = "hello world") {
    sink(y)
  }

  fun user() {
    f("member sunk")
    f("member sunk fp", "member sunk 2")
    f("not sunk", "member sunk 3", "not sunk")
  }

}

class TestExtensionMember {

  fun String.f(x: String, y: String = x, z: String = "hello world") {
    sink(this)
    sink(y)
  }

  fun user(sunk: String) {
    sunk.f("extension sunk")
    sunk.f("extension sunk fp", "extension sunk 2")
    sunk.f("not sunk", "extension sunk 3", "not sunk")
  }

}

object TestStaticMember {

  @JvmStatic fun f(x: String, y: String = x, z: String = "hello world") {
    sink(y)
  }

  fun user() {
    f("static sunk")
    f("static sunk fp", "static sunk 2")
    f("not sunk", "static sunk 3", "not sunk")
  }

}

class ExtendMe {

  fun f(x: String) = x

}

class TestReceiverReferences {

  fun g(x: String) = x

  fun ExtendMe.test(x: String, y: String = this.f(this@TestReceiverReferences.g(x)), z: String = "hello world") {
    sink(y)
  }
  
  fun user(t: ExtendMe) {
    t.test("receiver refs sunk")
    t.test("receiver refs sunk fp", "receiver refs sunk 2")
    t.test("not sunk", "receiver refs sunk 3", "not sunk")
  }

}

class TestConstructor(x:  String, y: String = x, z: String = "hello world") {

  init {
    sink(y)
  }

  fun user() {
    TestConstructor("constructor sunk")
    TestConstructor("constructor sunk fp", "constructor sunk 2")
    TestConstructor("not sunk", "constructor sunk 3", "not sunk")
  }

}

class TestLocal {

  fun enclosing() {

    fun f(x: String, y: String = x, z: String = "hello world") {
      sink(y)
    }
  
    fun user() {
      f("local sunk")
      f("local sunk fp", "local sunk 2")
      f("not sunk", "local sunk 3", "not sunk")
    }

  }

}

class TestLocalClass {

  fun enclosingFunction() {  

    class EnclosingLocalClass {

      fun f(x: String, y: String = x, z: String = "hello world") {
        sink(y)
      }
  
      fun user() {
        f("local sunk")
        f("local sunk fp", "local sunk 2")
        f("not sunk", "local sunk 3", "not sunk")
      }

    }

  }

}

class TestGeneric<T> {

  fun f(x: T, y: T = x, z: T? = null) {
    sink(y)
  }

  fun user(tgs: TestGeneric<String>, tcs: TestGeneric<CharSequence>) {
    tgs.f("generic sunk")
    tcs.f("generic sunk fp", "generic sunk 2")
    tgs.f("not sunk", "generic sunk 3", "not sunk")
    tcs.f("not sunk", "generic sunk 3", "not sunk")
  }

  fun testReturn(t1: T, t2: T? = null) = t1

  fun testReturnUser(tgs: TestGeneric<String>) {
    sink(tgs.testReturn("sunk return value"))
  }

}

class TestGenericFunction<T> {

  fun <S : T> f(x: S, y: T = x, def1: T? = null, def2: List<T> = listOf(y), def3: S? = null, def4: List<S>? = listOf(x)) {
    sink(y)
  }

  fun user(inst: TestGenericFunction<String>) {
    inst.f<String>("generic function sunk")
    inst.f("generic function sunk fp", "generic function sunk 2")
  }

}

class VisibilityTests {

  fun f(x: Int, y: Int = 0) = x + y
  internal fun g(x: Int, y: Int = 0) = x + y
  protected fun h(x: Int, y: Int = 0) = x + y
  private fun i(x: Int, y: Int = 0) = x + y

}

class TestGenericUsedWithinDefaultValue<T> {

  // This tests parameter erasure works properly: we should notice that here the type variable T
  // isn't used in the specialisation TestGenericUsedWithinDefaultValue<String>, but it can be
  // cited in contexts like "the signature of the source declaration of 'TestGenericUsedWithinDefaultValue<String>.f(String)' is 'f(T)'",
  // not 'f(Object)' as we might mistakenly conclude if we're inappropriately erasing 'T'.
  fun f(x: Int, y: String = TestGenericUsedWithinDefaultValue<String>().ident("Hello world")) { }

  fun ident(t: T) = t

}

class TestOverloadsWithDefaults {

  fun f(x: Int, y: String = "Hello world") { }
  fun f(z: String, w: Int = 0) { }

}
