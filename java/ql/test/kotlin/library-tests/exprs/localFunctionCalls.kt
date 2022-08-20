package foo.bar

fun x() {
    var x = 5
    fun <T> a(i: Int) = i + x
    x = 6
    a<String>(42)
    x = 7
    fun <T1> C1<T1>.f1(i: Int) = 5
    C1<Int>().f1(42)
    C1<Int>().f1(42)
}

class C1<T> {}
