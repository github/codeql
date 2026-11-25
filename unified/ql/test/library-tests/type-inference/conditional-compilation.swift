class Postfix {
  func toString() -> String { return "" }
}

func testPostfixConditionalCompilation() {
  let a = Postfix()  // $ type=a:String target=Postfix.init
    #if FIRST
      .toString()  // $ target=Postfix.toString
    #else
      .toString()  // $ target=Postfix.toString
    #endif
}
