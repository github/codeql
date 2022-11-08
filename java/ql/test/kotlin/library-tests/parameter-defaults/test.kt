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

fun varargsTest(x: String = "before-vararg-default sunk", vararg y: String = arrayOf("first-vararg-default sunk", "second-vararg-default sunk"), z: String = "after-vararg-default sunk") {
  sink(x)
  sink(y[0])
  sink(z)
}

fun varargsUser() {
  varargsTest()
  varargsTest(x = "no-varargs-before, no-z-parameter sunk")
  varargsTest(x = "no-varargs-before sunk", z = "no-varargs-after sunk")
  varargsTest(x = "one-vararg-before sunk", "one-vararg sunk", z = "one-vararg-after sunk")
  varargsTest(x = "two-varargs-before sunk", "two-vararg-first sunk", "two-vararg-second sunk", z = "two-varargs-after sunk")
  varargsTest("no-z-parmeter sunk", "no-z-parameter first vararg sunk", "no-z-parameter second vararg sunk")
}

fun varargsTestOnlySinkVarargs(x: String = "before-vararg-default not sunk 2", vararg y: String = arrayOf("first-vararg-default sunk 2", "second-vararg-default sunk 2"), z: String = "after-vararg-default not sunk 2") {
  sink(y[0])
}

fun varargsUserOnlySinkVarargs() {
  varargsTestOnlySinkVarargs()
  varargsTestOnlySinkVarargs(x = "no-varargs-before, no-z-parameter not sunk 2")
  varargsTestOnlySinkVarargs(x = "no-varargs-before not sunk 2", z = "no-varargs-after not sunk 2")
  varargsTestOnlySinkVarargs(x = "one-vararg-before not sunk 2", "one-vararg sunk 2", z = "one-vararg-after not sunk 2")
  varargsTestOnlySinkVarargs(x = "two-varargs-before not sunk 2", "two-vararg-first sunk 2", "two-vararg-second sunk 2", z = "two-varargs-after not sunk 2")
  varargsTestOnlySinkVarargs("no-z-parmeter not sunk 2", "no-z-parameter first vararg sunk 2", "no-z-parameter second vararg sunk 2")
}

fun varargsTestOnlySinkRegularArgs(x: String = "before-vararg-default sunk 3", vararg y: String = arrayOf("first-vararg-default not sunk 3", "second-vararg-default not sunk 3"), z: String = "after-vararg-default sunk 3") {
  sink(x)
  sink(z)
}

fun varargsUserOnlySinkRegularArgs() {
  varargsTestOnlySinkRegularArgs()
  varargsTestOnlySinkRegularArgs(x = "no-varargs-before, no-z-parameter sunk 3")
  varargsTestOnlySinkRegularArgs(x = "no-varargs-before sunk 3", z = "no-varargs-after sunk 3")
  varargsTestOnlySinkRegularArgs(x = "one-vararg-before sunk 3", "one-vararg not sunk 3", z = "one-vararg-after sunk 3")
  varargsTestOnlySinkRegularArgs(x = "two-varargs-before sunk 3", "two-vararg-first not sunk 3", "two-vararg-second not sunk 3", z = "two-varargs-after sunk 3")
  varargsTestOnlySinkRegularArgs("no-z-parmeter sunk 3", "no-z-parameter first vararg not sunk 3", "no-z-parameter second vararg not sunk 3")
}

class VarargsConstructorTest(x: String, vararg y: String) {
  init {
    sink(x)
  }
}

fun varargsConstructorUser() {
  VarargsConstructorTest("varargs constructor test sunk")
  VarargsConstructorTest("varargs constructor test sunk 2", "varargs constructor test not sunk 1", "varargs constructor test not sunk 2")
}
