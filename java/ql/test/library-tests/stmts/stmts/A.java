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

	public int nestedSwitchExpr(int x, int y) {
		return switch(x) {
			case 1 -> {
				yield 1;
			}
			case 2 -> switch(y) {
				case 0 -> {
					yield 0;
				}
				default -> {
					yield 1;
				}
			};
			case 3 -> 3;
			default -> {
				// SwitchStmt inside SwitchExpr
				switch (y) {
					case 1 -> System.out.println("1");
					case 2 -> {
						yield 2;
					}
				}
				yield -1;
			}
		};
	}
}
