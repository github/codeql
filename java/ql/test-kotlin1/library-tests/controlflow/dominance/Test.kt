class Test {
	fun test(px: Int, pw: Int, pz: Int): Int {
        var x = px
        var w = pw
        var z = pz

		var j: Int
		var y: Long = 50

		// if-else, multiple statements in block
		if (x > 0) {
			y = 20
			z = 10
		} else {
			y = 30
		}

		z = (x + y) as Int

		// if-else with return in one branch
		if (x < 0)
			y = 40
		else
			return z

		// this is not the start of a BB due to the return
		z = 10

		// single-branch if-else
		if (x == 0) {
			y = 60
			z = 10
		}

		z += x

		// while loop
		while (x > 0) {
			y = 10
			x--
		}

		z += y as Int

/*
TODO
		// for loop
		for (j = 0; j < 10; j++) {
			y = 0;
			w = 10;
		}

		z += w;

		// nested control flow
		for (j = 0; j < 10; j++) {
			y = 30;
			if (z > 0)
				if (y > 0) {
					w = 0;
					break;
				} else {
					w = 20;
				}
			else {
				w = 10;
				continue;
			}
			x = 0;
		}
*/

		z += x + y + w

		// nested control-flow

		w = 40
		return w
	}

	fun test2(a: Int): Int {
		/* Some more complex flow control */
		var b: Int
		var c: Int
		c = 0
		while(true) {
			b = 10
			if (a > 100) {
				c = 10
				b = c
			}
			if (a == 10)
				break
			if (a == 20)
				return c
		}
		return b
	}

}

// Diagnostic Matches: % Couldn't find a Java equivalent function to kotlin.Int.dec in java.lang.Integer  ...while extracting a call (<no name>) at %Test.kt:40:4:40:6%
