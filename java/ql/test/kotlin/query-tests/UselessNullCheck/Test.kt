fun fn(x:Any?, y: Any?) {
    if (x == null && y == null) {
        throw Exception()
    }

    if (x != null) {
        println("x not null")
    } else if (y != null) {
        println("y not null")
    }
}
