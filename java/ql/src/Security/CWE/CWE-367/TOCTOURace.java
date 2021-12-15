class Resource {
	public synchronized boolean isReady() { ... }

	public synchronized void setReady(boolean ready) { ... }
	
	public synchronized void act() { 
		if (!isReady())
			throw new IllegalStateException();
		...
	}
}
	
public synchronized void bad(Resource r) {
	if (r.isReady()) {
		// r might no longer be ready, another thread might
		// have called setReady(false)
		r.act();
	}
}

public synchronized void good(Resource r) {
	synchronized(r) {
		if (r.isReady()) {
			r.act();
		}
	}
}