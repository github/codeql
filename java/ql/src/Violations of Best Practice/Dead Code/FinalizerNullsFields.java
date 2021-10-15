class FinalizedClass {
	Object o = new Object();
	String s = "abcdefg";
	Integer i = Integer.valueOf(2);
	
	@Override
	protected void finalize() throws Throwable {
		super.finalize();
		//No need to nullify fields
		this.o = null;
		this.s = null;
		this.i = null;
	}
}