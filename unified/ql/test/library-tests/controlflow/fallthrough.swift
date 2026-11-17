func fallthroughChain(_ x: Int, _ flag: Bool) {
  switch x {
  case 0: // $ bbStep='0 : match -> Block(+1)' bbStep='0 : no-match -> SwitchCase(+7)'
    if flag { // $ bbStep='flag : false -> print(+4)' bbStep='flag : true -> Block(+0)'
      fallthrough
      print("unreachable") // $ bbStep='print(...) : successor -> print(+2)'
    }
    print("stay in first case")
    break // $ bbStep='BreakExpr : break -> print(+10)'
  case 1 where flag: // $ bbStep='ConditionalPattern : match -> Block(+1)' bbStep='ConditionalPattern : no-match -> SwitchCase(+3)' nonSimple='SwitchCase -V flag -? 1 -^ ConditionalPattern'
    print("second case")
    fallthrough // $ bbStep=' : successor -> print(+7)'
  case 2: // $ bbStep='2 : match -> Block(+1)' bbStep='2 : no-match -> SwitchCase(+3)'
    print("third case")
    fallthrough // $ bbStep=' : successor -> print(+4)'
  default:
    print("default case") // $ bbStep='print(...) : successor -> print(+2)'
  }
  print("after switch")
}

func nestedFallthrough(_ x: Int, _ y: Int) {
  switch x {
  case 0: // $ bbStep='0 : match -> Block(+1)' bbStep='0 : no-match -> SwitchCase(+9)'
    switch y {
    case 0: // $ bbStep='0 : match -> Block(+1)' bbStep='0 : no-match -> SwitchCase(+2)'
      fallthrough // $ bbStep=' : successor -> print(+4)'
    default:
      print("inner default") // $ bbStep='print(...) : successor -> print(+2)'
    }
    print("after inner switch")
    fallthrough // $ bbStep=' : successor -> print(+4)'
  default:
    print("outer default") // $ bbStep='print(...) : successor -> print(+2)'
  }
  print("after outer switch")
}

func fallthroughWithDefer(_ x: Int, _ flag: Bool) {
  switch x {
  case 0: // $ bbStep='0 : match -> Block(+1)' bbStep='0 : no-match -> SwitchCase(+10)'
    defer { // $ bbContinues='DeferStmt goto TryExpr(+3)'
      print("outer defer") // $ bbStep='print(...) : successor -> print(+13)'
    }
    do {
      defer { // $ bbContinues='DeferStmt goto (+3)'
        print("inner defer") // $ bbContinues='print(...) goto Block(-5)'
      }
      fallthrough // $ bbContinues=' goto Block(-3)'
    }
  case 1 where flag: // $ bbStep='ConditionalPattern : match -> Block(+1)' bbStep='ConditionalPattern : no-match -> SwitchCase(+2)' nonSimple='SwitchCase -V flag -? 1 -^ ConditionalPattern'
    print("next case") // $ bbStep='print(...) : successor -> print(+4)'
  default:
    break // $ bbStep='BreakExpr : break -> print(+2)'
  }
  print("after deferred fallthrough")
}
