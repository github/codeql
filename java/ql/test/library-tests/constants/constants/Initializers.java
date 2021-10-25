package constants;

class Initializers {
	static final int SFIELD = 12;

	final int IFIELD = 20;

	final int IFIELD2;

	Initializers() {
		// Not an initializer
		IFIELD2 = 22;
	}

	void stuff() {
		int x = 300;
		int y;
		y = 400;
	}

	static final Object SFIELD_OBJECT = "a string";

	final static int fsf;
	static int sf = 3;
	final int ff;
	int f = 4;

	static {
		// Not initializers
		fsf = 42;
		sf = 42;
	}

	{
		// Not initializers
		ff = 42;
		f = 42;
	}
}
