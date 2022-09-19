fun fn1(i: Int = 1, j: Int = 2) = i + j

fun fn2(i: Int = fn1(1,1), f: (Int) -> String) = f(i)

fun main() {
    fn1(11, 12)
    fn1()
    fn1(11)
    fn1(j = 12)
    fn1(j = 12, i = 11)

    fn2(21) { it.toString() }
    fn2 { it.toString() }
}
