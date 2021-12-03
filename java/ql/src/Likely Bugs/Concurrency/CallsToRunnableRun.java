public class ThreadDemo {
    public static void main(String args[]) {
        NewThread runnable = new NewThread();

        runnable.run();    // Call to 'run' does not start a separate thread

        System.out.println("Main thread activity.");
    }
}

class NewThread extends Thread {
    public void run() {
        try {
            Thread.sleep(10000);
        }
        catch (InterruptedException e) {
            System.out.println("Child interrupted.");
        }
        System.out.println("Child thread activity.");
    }
}