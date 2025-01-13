package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class SynchronizedAndLock {
    private Lock lock = new ReentrantLock();

    private int length = 0;

    public void add(int value) {
        lock.lock();
        length++; // $ Alert
        lock.unlock();
    }

    public synchronized void subtract() {
        length--;
    }
}
