import java.lang.InterruptedException;
import java.lang.Thread;

public class Test {
    static {
        try {
            Thread.sleep(20);
        } catch(InterruptedException e) {
            System.out.println("Interrupted");
        }
    }

    public void sleepCorrect() {
        try {
            Thread.sleep(20);
        } catch(InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new RuntimeException("Thread was interrupted!", e);
        }
    }

    public void sleepCorrect2() throws InterruptedException {
        try {
            Thread.sleep(20);
        } catch(InterruptedException e) {
            throw new InterruptedException("Thread was interrupted while sleeping!");
        }
    }

    public void sleepCorrect3() {
        try {
            Thread.sleep(20);
        } catch(InterruptedException e) {
            {
                Thread.currentThread().interrupt();
            }
            throw new RuntimeException("Thread was interrupted!", e);
        }
    }

    public void sleepCorrect4() {
        try {
            Thread.sleep(20);
        } catch(InterruptedException e) {
            willSetInterruptFlag();
            throw new RuntimeException("Thread was interrupted!", e);
        }
    }

    public void busyWaitIncorrect() {
        try {
            while(true) {
                // do work
                if (Thread.interrupted()) {
                    throw new InterruptedException("Thread was interrupted!");
                }
            }
        } catch (InterruptedException e) {
            throw new RuntimeException("Thread was interrupted!", e);
        }
    }

    public static void willSetInterruptFlag() {
        Thread.currentThread().interrupt();
    }
}
