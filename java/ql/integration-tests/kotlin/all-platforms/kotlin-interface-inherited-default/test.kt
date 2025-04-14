interface Test {

  fun f() = 1

  fun g(x: Int) = x

  val x : Int
    get() = 3

}

class Real : Test { }

interface MiddleInterface : Test { }

class RealIndirect : MiddleInterface { }
