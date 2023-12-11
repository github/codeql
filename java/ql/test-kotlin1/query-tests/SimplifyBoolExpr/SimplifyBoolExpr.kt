fun main() {
    f(null)
    f(true)
    f(false)
}

fun f(x: Boolean?) {
    if(x == true) {
        println("Yes")
    } else {
        println("No")
    }
}
