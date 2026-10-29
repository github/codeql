package stmts;

public class B {
	public void foo(boolean b, boolean c) {
		outer:
		for (int i=0; i<10; ++i) {
			if (b)
				break;
			if (b)
				continue;
			while (i < 20) {
				if (c)
					break;
				if (b && c)
					break outer;
				if (b)
					continue;
				if (c && b)
					continue outer;
				switch (i) {
				case 23:
					break;
				case 42:
					break outer;
				case 56:
					continue;
				}
			}
		}
	}
}