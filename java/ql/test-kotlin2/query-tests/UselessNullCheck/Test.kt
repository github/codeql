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

fun fn0(o: Any?) {
    if (o != null) {
        o?.toString()
        o.toString()
    }
}
