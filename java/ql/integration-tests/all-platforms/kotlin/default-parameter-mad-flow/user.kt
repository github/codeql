fun source() = 1

fun sink(x: Any) { }

fun test(c: LibClass, sourcec: SourceClass, sinkc: SinkClass) {

  sink(ConstructorWithDefaults(source(), 0)) // $ flow
  sink(ConstructorWithDefaults(source())) // $ flow

  sink(topLevelWithDefaults(source(), 0)) // $ flow
  sink(topLevelWithDefaults(source())) // $ flow

  sink("Hello world".extensionWithDefaults(source(), 0)) // $ flow
  sink("Hello world".extensionWithDefaults(source())) // $ flow

  sink(c.memberWithDefaults(source(), 0)) // $ flow
  sink(c.memberWithDefaults(source())) // $ flow

  sink(c.multiParameterTest(source(), 0, 0)) // $ flow
  sink(c.multiParameterTest(0, source(), 0)) // $ flow
  sink(c.multiParameterTest(0, 0, source()))

  with(c) {
    sink("Hello world".extensionMemberWithDefaults(source(), 0)) // $ flow
    sink("Hello world".extensionMemberWithDefaults(source())) // $ flow
  }

  with(c) {
    sink(source().multiParameterExtensionTest(0, 0)) // $ flow
    sink(0.multiParameterExtensionTest(source(), 0)) // $ flow
    sink(0.multiParameterExtensionTest(0, source()))
  }

  run {
    val st = SomeToken()
    topLevelArgSource(st)
    sink(st) // $ flow
  }

  run {
    val st = SomeToken()
    "Hello world".extensionArgSource(st)
    sink(st) // $ flow
  }

  run {
    val st = SomeToken()
    sourcec.memberArgSource(st)
    sink(st) // $ flow
  }

  SinkClass(source()) // $ flow
  topLevelSink(source()) // $ flow
  "Hello world".extensionSink(source()) // $ flow
  sinkc.memberSink(source()) // $ flow
  with(sinkc) {
    "Hello world".extensionMemberSink(source()) // $ flow
  }

}
