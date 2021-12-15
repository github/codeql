class NotifyWithoutSynch {
	private Object obj1;
	private Object obj2;

	public synchronized void pass_unqualified_wait() throws InterruptedException {
		wait();
	}

	public void fail_unqualified_wait() throws InterruptedException {
		wait();
	}

	public synchronized void pass_unqualified_notify() throws InterruptedException {
		notify();
	}

	public void fail_unqualified_notify() throws InterruptedException {
		notify();
	}

	public synchronized void pass_unqualified_notifyAll() throws InterruptedException {
		notifyAll();
	}

	public void fail_unqualified_notifyAll() throws InterruptedException {
		notifyAll();
	}

	public void pass_unqualified_wait2() throws InterruptedException {
		synchronized(this) {
			wait();
		}
	}

	public synchronized void pass_qualified_wait01() throws InterruptedException {
		this.wait();
	}

	public void pass_qualified_wait02() throws InterruptedException {
		synchronized(this) {
			this.wait();
		}
	}

	public void pass_qualified_wait03() throws InterruptedException {
		synchronized(obj1) {
			obj1.wait();
		}
	}

	public void fail_qualified_wait01() throws InterruptedException {
		this.wait();
	}

	public void fail_qualified_wait02() throws InterruptedException {
		this.wait();
	}

	public void fail_qualified_wait03() throws InterruptedException {
		synchronized(obj1) {
			this.wait();
		}
	}

	public void fail_qualified_wait04() throws InterruptedException {
		synchronized(this) {
			obj1.wait();
		}
	}

	public synchronized void fail_qualified_wait05() throws InterruptedException {
		obj1.wait();
	}

	public synchronized void fail_qualified_wait06() throws InterruptedException {
		synchronized(obj1) {
			obj2.wait();
		}
	}

	private void pass_indirect_callee07() throws InterruptedException {
		this.wait();
	}

	private void pass_indirect_callee08() throws InterruptedException {
		pass_indirect_callee07();
	}

	private void pass_indirect_callee09() throws InterruptedException {
		pass_indirect_callee07();
	}

	private void pass_indirect_callee10() throws InterruptedException {
		pass_indirect_callee07();
	}

	public synchronized void pass_indirect_caller11() throws InterruptedException {
		pass_indirect_callee08();
	}

	public void pass_indirect_caller12() throws InterruptedException {
		synchronized(this) {
			pass_indirect_callee09();
		}
	}

	public void pass_indirect_caller13() throws InterruptedException {
		synchronized(NotifyWithoutSynch.this) {
			pass_indirect_callee10();
		}
	}

	private void fail_indirect_callee14() throws InterruptedException {
		wait();
	}

	public void fail_indirect_caller15() throws InterruptedException {
		fail_indirect_callee14();
	}
}
