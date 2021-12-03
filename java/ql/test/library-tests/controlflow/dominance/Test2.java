import java.math.*;

class MyExn extends Throwable {}

public class Test2 {
	void f() throws Throwable {}

	void g(boolean b) throws Throwable {
		while (b) {
			if (b) {
			} else {
				try {
					f();
				} catch (MyExn e) {}
				;
			}
		}
	}
	
	void t(int x) {
		if (x < 0) {
			return;
		}
		while(x >= 0) {
			if (x > 10) {
				try {
					BigInteger n = new BigInteger( "wrong" );
				} catch ( NumberFormatException e ) { // unchecked exception
				}
			}
			x--;
		}
	}
}