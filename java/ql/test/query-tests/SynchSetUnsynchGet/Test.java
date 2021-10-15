class SynchSetUnsynchGet {
	private static int var;
	
	public synchronized void setA(int a) {
		this.var = a;
	}
	
	public synchronized int getA() {
		return var; // ok get is synchronized
	}
	
	public synchronized void setB(int a) {
		this.var = a;
	}
	
	public int getB() {
		return var;  // bad
	}
	
	public synchronized void setC(int a) {
		this.var = a;
	}
	
	public int getC() {
		synchronized (this) {
			return var; // ok get uses synchronized block
		}
	}
	
	public void setD(int a) {
		this.var = a;
	}
	
	public int getD() {
		return var; // ok set is not synchronized
	}
	
	public synchronized void setE(int a) {
		this.var = a;
	}
	
	public int getE() {
		synchronized (String.class) {
			return var; // bad synchronize on wrong thing
		}
	}
	
	public static synchronized void setF(int a) {
		var = a;
	}
	
	public static int getF() {
		synchronized (SynchSetUnsynchGet.class) {
			return var; // ok get uses synchronized block
		}
	}
}
