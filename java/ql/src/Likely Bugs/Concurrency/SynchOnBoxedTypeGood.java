class GoodSynchronize{
		
	class ThreadA extends Thread{
		private Object lock = new Object();
		
		public void run(){
			synchronized(lock){
				//...
			}
		}
	}
	
	class ThreadB extends Thread{
		private Object lock = new Object();
				
		public void run(){
			synchronized(lock){
				//...
			}
		}
	}
	
	public void run(){
		new ThreadA().start();
		new ThreadB().start();
	}
		
}