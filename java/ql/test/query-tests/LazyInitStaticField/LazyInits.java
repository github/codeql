public class LazyInits {
	private static Object lock = new Object();
	private static Object badLock;
	
	public void resetLock() {
		badLock = new Object();
	}
	
	// Eager init
	public static final LazyInits eager = new LazyInits();
	
	// Correct lazy inits
	public static LazyInits correct1;
	public synchronized static LazyInits getCorrect1() {
		if (correct1 == null)
			correct1 = new LazyInits();
		return correct1;
	}
	
	public static LazyInits correct2;
	public static LazyInits getCorrect2() {
		synchronized(LazyInits.class) {
			if (correct1 == null)
				correct1 = new LazyInits();
			return correct1;
		}
	}
	
	public static LazyInits correct3;
	public static LazyInits getCorrect3() {
		synchronized(lock) {
			if (correct1 == null)
				correct1 = new LazyInits();
			return correct1;
		}
	}
	
	private static class Holder {
		private static LazyInits correct4 = new LazyInits();
	}
	public static LazyInits getCorrect4() {
		return Holder.correct4;
	}
	
	private static LazyInits correct5;
	public static LazyInits getCorrect5() {
		if (correct5 == null) {
			synchronized(lock) {
				// NB: Initialising wrong field, so should not trigger this check.
				if (correct5 == null)
					correct3 = new LazyInits();
			}
		}
		return correct5;
	}
	
	private static volatile LazyInits correct6;
	public static LazyInits getCorrect6() {
		if (correct6 == null) {
			synchronized(lock) {
				if (correct6 == null)
					correct6 = new LazyInits();
			}
		}
		return correct6;
	}
	
	private static LazyInits correct7;
	public static LazyInits getCorrect7() {
		synchronized(LazyInits.class) {
			if (correct7 == null)
				correct7 = new LazyInits();
		}
		return correct7;
	}
	
	private static LazyInits correct8;
	public static LazyInits getCorrect8() {
		synchronized(lock) {
			if (correct8 == null)
				correct8 = new LazyInits();
		}
		return correct8;
	}
	
	private static LazyInits correct9;
	static {
		if (correct9 == null)
			correct9 = new LazyInits();
	}
	
	// Bad cases
	
	// No synch attempt.
	private static LazyInits bad1;
	public static LazyInits getBad1() {
		if (bad1 == null)
			bad1 = new LazyInits();
		return bad1;
	}
	
	// Synch on field.
	private static LazyInits bad2;
	public static LazyInits getBad2() {
		if (bad2 == null) {
			synchronized(bad2) {
				if (bad2 == null)
					bad2 = new LazyInits();
			}
		}
		return bad2;
	}
	
	// Synch on unrelated class.
	private static LazyInits bad3;
	public static LazyInits getBad3() {
		if (bad3 == null) {
			synchronized(Object.class) {
				if (bad3 == null)
					bad3 = new LazyInits();
			}
		}
		return bad3;
	}
	
	// Standard (broken) double-checked locking.
	private static LazyInits bad4;
	public static LazyInits getBad4() {
		if (bad4 == null) {
			synchronized(LazyInits.class) {
				if (bad4 == null)
					bad4 = new LazyInits();
			}
		}
		return bad4;
	}
	
	// Standard (broken) double-checked locking with lock object.
	private static LazyInits bad5;
	public static LazyInits getBad5() {
		if (bad5 == null) {
			synchronized(lock) {
				if (bad5 == null)
					bad5 = new LazyInits();
			}
		}
		return bad5;
	}
	
	// Volatile object with bad lock.
	private static volatile LazyInits bad6;
	public static LazyInits getBad6() {
		if (bad6 == null) {
			synchronized(badLock) {
				if (bad6 == null)
					bad6 = new LazyInits();
			}
		}
		return bad6;
	}

	// Other cases

	// OK
	private static LazyInits ok;
	private static java.util.concurrent.locks.ReentrantLock okLock = new java.util.concurrent.locks.ReentrantLock();
	public static void init() {
		okLock.lock();
		try {
			if (ok==null) {
				ok = new LazyInits();
			}
		} finally {
			okLock.unlock();
		}
	}
}