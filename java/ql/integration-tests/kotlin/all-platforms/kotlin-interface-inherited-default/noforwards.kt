interface NoForwards {

  fun f() = 4

  fun g(x: Int) = x

  val x : Int
    get() = 6

}

class RealNoForwards : NoForwards { }
