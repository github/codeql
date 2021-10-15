public class ThreadDemo {
    public static void main(String args[]) {
    	NewThread runnable = new NewThread();
    	
        runnable.start();                                         // Call 'start' method
        
        System.out.println("Main thread activity.");
    }
}