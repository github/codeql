// Semmle test case for CWE-367: Time-of-check Time-of-use (TOCTOU) Race Condition
// http://cwe.mitre.org/data/definitions/367.html
package test.cwe367.semmle.tests;

class Test {
	public final Object lock = new Object();
	
	public volatile boolean aField = true;
	
	public synchronized void bad1(Resource r) {
		// probably used concurrently due to synchronization
		if (r.getState()) {
			r.act();
		}
	}

	public synchronized void bad2(Resource2 r) {
		// probably used concurrently due to synchronization
		if (r.getState()) {
			r.act();
		}
	}

	public void bad3(Resource r) {
		// probably used concurrently due to use of volatile field
		if (r.getState() && aField) {
			r.act();
		}
	}

	public void bad4(Resource r) {
		// probably used concurrently due to synchronization
		synchronized(this) {
			if (r.getState() && aField) {
				r.act();
			}
		}
	}
	
	public void good1(Resource r) {
		// synchronizes on the same monitor as the called methods
		synchronized(r) {
			if (r.getState()) {
				r.act();
			}
		}
	}
	
	public Resource rField = new Resource();
	
	public void someOtherMethod() {
		synchronized(lock) {
			rField.act();
		}
	}
	
	public void good2() {
		// r is always guarded with the same lock, so okay
		synchronized(lock) {
			if (rField.getState()) {
				rField.act();
			}
		}
	}

	public void good3() {
		// r never escapes, so cannot be used concurrently
		Resource r = new Resource();
		if (r.getState()) {
			r.act();
		}
	}

	// probably not used in a concurrent context, so not worth flagging
	public void good3(Resource r) {
		if (r.getState()) {
			r.act();
		}
	}
	
	class Resource {
		boolean state;
		
		public synchronized void setState(boolean newState) {
			this.state = newState;
		}
		
		public synchronized boolean getState() {
			return state;
		}
		
		public synchronized void act() {
			if (state)
				sideEffect();
			else
				sideEffect();
		}
		
		public void sideEffect() { }
	}

	class Resource2 {
		boolean state;
		
		public void setState(boolean newState) {
			synchronized(this) {
				this.state = newState;
			}
		}
		
		public boolean getState() {
			synchronized(this) {
				return state;
			}
		}
		
		public void act() {
			synchronized(this) {
				if (state)
					sideEffect();
				else
					sideEffect();
			}
		}
		
		public void sideEffect() { }
	}
}
