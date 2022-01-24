package successors;

class TestThrow2 {
	native void thrower() throws Throwable;
	{
		try {
			thrower();
		} catch (Throwable e) {
			;
		}
	}
}
