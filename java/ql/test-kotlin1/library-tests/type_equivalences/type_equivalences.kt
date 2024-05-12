
class Par<T> {}

fun fooUnit(x: Unit, y: Par<Unit>): Unit { return fooUnit(x, y) }
fun fooVoid(x: Void, y: Par<Void>): Void { return fooVoid(x, y) }
fun fooNothing(x: Nothing, y: Par<Nothing>): Nothing { return fooNothing(x, y) }
fun fooInt(x: Int, y: Par<Int>): Int { return fooInt(x, y) }

