class StorageThread implements Runnable{
    public static Integer counter = 0;
    private static final Object LOCK = new Object();

    public void run() {
        System.out.println("StorageThread started.");
        synchronized(LOCK) {  // "LOCK" is locked just before the thread goes to sleep
            try {
                Thread.sleep(5000);
            } catch (InterruptedException e) { ... }
        }
        System.out.println("StorageThread exited.");
    }
}

class OtherThread implements Runnable{
    public void run() {
        System.out.println("OtherThread started.");
        synchronized(StorageThread.LOCK) {
            StorageThread.counter++;
        }
        System.out.println("OtherThread exited.");
    }
}

public class SleepWithLock {
    public static void main(String[] args) {
        new Thread(new StorageThread()).start();
        new Thread(new OtherThread()).start();
    }
}
