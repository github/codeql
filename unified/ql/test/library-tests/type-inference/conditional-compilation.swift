class Postfix {
  func toString() -> String { return "" }
}

func testPostfixConditionalCompilation() {
  let a = Postfix()  // $ MISSING: type=a:String target=Postfix.init
    #if FIRST
      .toString()  // $ MISSING: target=Postfix.toString
    #else
      .toString()  // $ MISSING: target=Postfix.toString
    #endif
}
