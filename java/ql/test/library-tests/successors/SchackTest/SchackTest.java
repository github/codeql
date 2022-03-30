public class SchackTest {
	class ExA extends Throwable {}
	class ExB extends Throwable {}

	void foo(int x) {
		try {
			try {
				if (x==1)
					throw new ExA();
				if (x==2)
					return;
			} finally {
				if (bar())
					System.out.println("true successor");
			}
			System.out.println("false successor");
		} catch (ExA e) {
			System.out.println("false successor");
		} catch (ExB e) {
			System.out.println("successor (but neither true nor false successor)");
		} finally {
			System.out.println("false successor");
		}
	}

	private boolean bar() throws ExB {
		if (Math.random() > .5)
			throw new ExB();
		return Math.random() > .3;
	}
}