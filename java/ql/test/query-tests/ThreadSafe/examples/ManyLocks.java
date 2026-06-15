package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class ManyLocks {
    private int y; // $ Alert

    private final Lock lock1 = new ReentrantLock();
    private final Lock lock2 = new ReentrantLock();
    private final Lock lock3 = new ReentrantLock();

    public void inc() {
        lock1.lock();
        lock2.lock();
        y++;
        lock2.unlock();
        lock1.unlock();
    }

    public void dec() {
        lock2.lock();
        lock3.lock();
        y--;
        lock3.unlock();
        lock2.unlock();
    }

    public void reset() {
        lock1.lock();
        lock3.lock();
        y = 0;
        lock3.unlock();
        lock1.unlock();
    }
}