fun fn0() { throw java.io.IOException() }

fun fn1() {
    try {
        throw java.io.IOException()
    } catch (e: java.io.FileNotFoundException) {
        println(e)
    } catch (e: java.io.IOException) {
        println(e)
    }
}

fun fn2() {
    try {
        fn0()
    } catch (e: java.io.FileNotFoundException) {
        println(e)
    } catch (e: java.io.IOException) {
        println(e)
    }
}

fun fn3() {
    try {
        throw java.io.FileNotFoundException()
    } catch (e: java.io.FileNotFoundException) {
        println(e)
    } catch (e: java.io.IOException) {	// TODO: False negative
        println(e)
    }
}
