class Test {
	static class MyLock {
		void lock() throws RuntimeException { }
		boolean tryLock() { return true; }
		void unlock() { }
		boolean isHeldByCurrentThread() { return true; }
	}
	
	void f() throws RuntimeException { }
	void g() throws RuntimeException { }
	
	MyLock mylock = new MyLock();
	
	void bad1() {
		mylock.lock();
		f();
		mylock.unlock();
	}
	
	void good2() {
		mylock.lock();
		try {
			f();
		} finally {
			mylock.unlock();
		}
	}
	
	void bad3() {
		mylock.lock();
		f();
		try {
			g();
		} finally {
			mylock.unlock();
		}
	}
	
	void bad4() {
		mylock.lock();
		try {
			f();
		} finally {
			g();
			mylock.unlock();
		}
	}
	
	void bad5(boolean lockmore) {
		mylock.lock();
		try {
			f();
			if (lockmore) {
				mylock.lock();
			}
			g();
		} finally {
			mylock.unlock();
		}
	}
	
	void good6() {
		if (!mylock.tryLock()) { return; }
		try {
			f();
		} finally {
			mylock.unlock();
		}
	}
	
	void bad7() {
		if (!mylock.tryLock()) { return; }
		f();
		mylock.unlock();
	}

	void good7() {
		try {
			if (mylock.tryLock()) {
				return;
			}
		} finally {
			if (mylock.isHeldByCurrentThread()) {
				mylock.unlock();
			}
		}
	}

	void good8() {
		boolean locked = mylock.tryLock();
		if (!locked) { return; }
		try {
			f();
		} finally {
			mylock.unlock();
		}
	}
}
