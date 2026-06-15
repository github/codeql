class A {
    val x = if (true) {
        class L { }
        L()
    } else {}

    val y = if (true) {
        class L { }
        L()
    } else {}
}
