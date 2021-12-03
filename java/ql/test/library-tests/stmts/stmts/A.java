package stmts;

public class A {
	public int foo(int x) {
		switch(x) {
		case 23:
			return 42;
		case 42:
			return 23;
		default:
			return x;
		}
	}
}
