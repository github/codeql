class BusyWaits {
	public void badWait() throws InterruptedException {
		while(this.hashCode() != 0)
			Thread.sleep(1);
	}
	
	public void badWait2() throws InterruptedException, CloneNotSupportedException {
		while (this.hashCode() < 3) {
			for (int i = 0; i < this.hashCode(); this.clone())
				Thread.sleep(new String[1].length);
		}
	}
	
	public void noError() throws InterruptedException {
		while(this.hashCode() < 0) {
			this.wait();
			this.notify();
			if (1 < 2)
				Thread.sleep(2);
		}
	}
	
	public void noError2() {
		while (this.hashCode() < 0)
			synchronized(this) {
				System.out.println("foo");
			}
	}
}