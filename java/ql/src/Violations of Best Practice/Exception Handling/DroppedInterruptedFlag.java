public class DroppedInterruptedFlag {

    void doSleep() {
        try {
            Thread.sleep(20);
        } catch (InterruptedException e) {
            // BAD: The interrupted flag is dropped!
            throw new RuntimeException("Thread was interrupted!", e);
        }
    }

    void doSleep() {
        try {
            Thread.sleep(20);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt(); // GOOD: The interrupted flag is reset!
            throw new RuntimeException("Thread was interrupted!", e);
        }
    }
    
}
