import java.util.function.UnaryOperator

fun f(x: UnaryOperator<String>) { }

fun test() {

  f({x -> x})

}
