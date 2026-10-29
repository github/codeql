class FalseSingleton implements Serializable {
	private static final long serialVersionUID = -7480651116825504381L;
	private static FalseSingleton instance;
	
	private FalseSingleton() {}
	
	public static FalseSingleton getInstance() {
		if (instance == null) {
			instance = new FalseSingleton();
		}
		return instance;
	}
	
	// BAD: Signature of 'readResolve' does not match the exact signature that is expected
	// (that is, it does not return 'java.lang.Object').
	public FalseSingleton readResolve() throws ObjectStreamException {
		return FalseSingleton.getInstance();
	}
}

class Singleton implements Serializable {
	private static final long serialVersionUID = -7480651116825504381L;
	private static Singleton instance;
	
	private Singleton() {}
	
	public static Singleton getInstance() {
		if (instance == null) {
			instance = new Singleton();
		}
		return instance;
	}
	
	// GOOD: Signature of 'readResolve' matches the exact signature that is expected.
	// It replaces the singleton that is read from a stream with an instance of 'Singleton',
	// instead of creating a new singleton.
	private Object readResolve() throws ObjectStreamException {
		return Singleton.getInstance();
	}
}