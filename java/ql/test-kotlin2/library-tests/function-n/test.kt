class TakesLambdas {

  fun <T1, T2, T3> test(
    f1: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> String,
    f2: (Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int, Int) -> T1,
    f3: (T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2, T2) -> T3) { }

}
