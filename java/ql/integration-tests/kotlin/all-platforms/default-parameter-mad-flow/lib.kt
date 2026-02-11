class ConstructorWithDefaults(x: Int, y: Int = 1) { }

fun topLevelWithDefaults(x: Int, y: Int = 1) = 0
fun String.extensionWithDefaults(x: Int, y: Int = 1) = 0

class LibClass {

  fun memberWithDefaults(x: Int, y: Int = 1) = 0
  fun String.extensionMemberWithDefaults(x: Int, y: Int = 1) = 0

  fun multiParameterTest(x: Int, y: Int, z: Int, w: Int = 0) = 0
  fun Int.multiParameterExtensionTest(x: Int, y: Int, w: Int = 0) = 0

}

class SomeToken {}

fun topLevelArgSource(st: SomeToken, x: Int = 0) {}
fun String.extensionArgSource(st: SomeToken, x: Int = 0) {}

class SourceClass {

  fun memberArgSource(st: SomeToken, x: Int = 0) {}

}

fun topLevelSink(x: Int, y: Int = 1) {}
fun String.extensionSink(x: Int, y: Int = 1) {}

class SinkClass(x: Int, y: Int = 1) {

  fun memberSink(x: Int, y: Int = 1) {}
  fun String.extensionMemberSink(x: Int, y: Int = 1) {}

}
