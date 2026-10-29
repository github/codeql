package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class Alias {
    private int y;

    private final ReentrantLock lock = new ReentrantLock();

    public void notMismatch() {
        final ReentrantLock lock = this.lock;
        lock.lock();
        try {
            y = 42;
        } finally {
            this.lock.unlock();
        }
    }
}