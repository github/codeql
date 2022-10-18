fun source() = 1

fun sink(x: Any) { }

fun test(c: LibClass, sourcec: SourceClass, sinkc: SinkClass) {

  sink(ConstructorWithDefaults(source(), 0))
  sink(ConstructorWithDefaults(source()))

  sink(topLevelWithDefaults(source(), 0))
  sink(topLevelWithDefaults(source()))

  sink("Hello world".extensionWithDefaults(source(), 0))
  sink("Hello world".extensionWithDefaults(source()))

  sink(c.memberWithDefaults(source(), 0))
  sink(c.memberWithDefaults(source()))

  with(c) {
    sink("Hello world".extensionMemberWithDefaults(source(), 0))
    sink("Hello world".extensionMemberWithDefaults(source()))
  };

  run {
    val st = SomeToken()
    topLevelArgSource(st)
    sink(st)
  }

  run {
    val st = SomeToken()
    "Hello world".extensionArgSource(st)
    sink(st)
  }

  run {
    val st = SomeToken()
    sourcec.memberArgSource(st)
    sink(st)
  }

  SinkClass(source())
  topLevelSink(source())
  "Hello world".extensionSink(source())
  sinkc.memberSink(source())
  with(sinkc) {
    "Hello world".extensionMemberSink(source())
  }

}
