
fun topLevelMethod(x: Int, y: Int): Int {
    if(x > y) {
    } else if(x < y) {
    } else {
    }
    while(x > y)
        return x
    while(x < y) {
        return y
    }
    do {
        return y
    } while(x < y)
    var z = 3
// TODO:    val q1: () -> Unit =          { z = 4 }
    val q2:       Unit = if(true) { z = 4 } else { z = 5 }
    val q3:       Unit = if(true)   z = 4   else   z = 5
    return x + y
}

fun loops(x: Int, y: Int) {
    loop@ while (x < 100) {
        do  {
            if (x > y) break@loop
        } while (y > 100)
    }
    while(x > y)
        continue

    for (i in x..y) {
        if (x > y) break
    }

    forLoop@for (i in x..y) {
        do  {
            if (x > y) break@forLoop
        } while (y > 100)
    }

    for ((v,i) in (x..y).withIndex()) {
        if (x > y) break
    }
}

fun exceptions(): Int {
    try {
        throw Exception("Foo")
    }
    catch (e: Exception) {
        return 1
    }
    finally {
        return 2
    }
}

// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Int.rangeTo in java.lang.Integer%
