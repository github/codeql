
fun topLevelMethod(x: Int, y: Int) {
}

class Class {
    fun classMethod(x: Int, y: Int) {
    }

    fun anotherClassMethod(a: Int, b: Int) {
        classMethod(a, 3)
        // TODO topLevelMethod(b, 4)
    }
}

