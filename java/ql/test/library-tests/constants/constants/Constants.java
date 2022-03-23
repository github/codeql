package constants;

class Constants {
	void constants(final int notConstant) {
		final int sfield = Initializers.SFIELD;
		final int ifield = new Initializers().IFIELD;
		
		// Not a constant: the type is wrong
		final Object staticObjectField = Initializers.SFIELD_OBJECT;
		
		final int x = 3;
		final int y = x;
		final int z = y;
		
		int binop = Initializers.SFIELD + 1;
		int binopNonConst = Initializers.SFIELD + notConstant;
		
		int paren = (12);
		String string = "a string";
		int ternary = (3 < 5) ? 1 : 2;
		
		return;
	}
}
