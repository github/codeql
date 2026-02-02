package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class DeepPaths {
    private int y; // $ Alert

    private final Lock lock1 = new ReentrantLock();
    private final Lock lock2 = new ReentrantLock();
    private final Lock lock3 = new ReentrantLock();

    public void layer1Locked() {
        lock1.lock();
        this.layer2Locked();
        lock1.unlock();
    }

    private void layer2Locked() {
        lock2.lock();
        this.layer3Unlocked();
        lock2.unlock();
    }

    private void layer3Locked() {
        lock3.lock();
        y++;
        lock3.unlock();
    }

    public void layer1Skip() {
        lock2.lock();
        this.layer3Locked();
        lock2.unlock();
    }

    public void layer1Indirect() {
        this.layer2();
    }

    private void layer2() {
        this.layer2Locked();
    }

    public void layer1Unlocked() {
        this.layer2Unlocked();
    }

    private void layer2Unlocked() {
        this.layer3();
    }

    private void layer3() {
        this.layer3Locked();
    }

    private void layer3Unlocked() {
        y++;
    }
}
