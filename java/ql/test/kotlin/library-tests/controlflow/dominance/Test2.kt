import java.math.*

class MyExn: Throwable() {}

public class Test2 {
    @Throws(Throwable::class)
	fun f() {}

    @Throws(Throwable::class)
	fun g(b: Boolean) {
		while (b) {
			if (b) {
			} else {
				try {
					f()
				} catch (e: MyExn) {}
				;
			}
		}
	}
	
	fun t(x: Int) {
		if (x < 0) {
			return
		}
        var y = x
		while(y >= 0) {
			if (y > 10) {
				try {
					val n: BigInteger = BigInteger( "wrong" );
				} catch (e: NumberFormatException) { // unchecked exception
				}
			}
			y--
		}
	}
}
