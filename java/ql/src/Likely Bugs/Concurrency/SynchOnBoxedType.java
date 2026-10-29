class BadSynchronize{
		
	class ThreadA extends Thread{
		private String value = "lock"
		
		public void run(){
			synchronized(value){
				//...
			}
		}
	}
	
	class ThreadB extends Thread{
		private String value = "lock"
		
		public void run(){
			synchronized(value){
				//...
			}
		}
	}
	
	public void run(){
		new ThreadA().start();
		new ThreadB().start();
	}
		
}