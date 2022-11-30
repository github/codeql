package dominance;

public class Test {
	fun test() {
		var x: Int = 0
		var y: Long = 50
		var z: Int = 0
		var w: Int = 0

		// if-else, multiple statements in block
		if (x > 0) {
			y = 20
			z = 10
		} else {
			y = 30
		}

		z = 0

		// if-else with return in one branch
		if(x < 0)
			y = 40
		else
			return

		// this is not the start of a BB due to the return
		z = 10

		// single-branch if-else
		if (x == 0) {
			y = 60
			z = 10
		}

		z = 20

		// while loop
		while(x > 0) {
			y = 10
			x--
		}

		z = 30

/*
TODO
		// for loop
		for(j in 0 .. 19) {
			y = 0
			w = 10
		}

		z = 40

		// nested control flow
		for(j in 0 .. 9) {
			y = 30
			if(z > 0)
				if(y > 0) {
					w = 0
					break;
				} else {
					w = 20
				}
			else {
				w = 10
				continue
			}
			x = 0
		}
*/

		z = 50

		// nested control-flow

		w = 40
		return
	}
}

fun t1(o: Any): Int {
	try {
		val x = o as Int
		return 1
	} catch (e: ClassCastException) {
		return 2
	}
}

fun t2(o: Any?): Int {
	try {
		val x = o!!
		return 1
	} catch (e: NullPointerException) {
		return 2
	}
}

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

fun fn(x: Boolean, y: Boolean) {
    if (x && y) {

    }
}

fun fn_when(x: Boolean, y: Boolean) {
	when {
		when {
			x -> y
			else -> false
		} -> { } }
}

// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Int.dec in java.lang.Integer  ...while extracting a call (<no name>) at %Test.kt:40:4:40:6%
