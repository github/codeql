package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class C {

    private int y;
    private Lock lock = new ReentrantLock();
    private Lock lock2 = new ReentrantLock();

    public void m() {
        this.y = 0; // $ Alert
        this.y += 1;
        this.y = this.y - 1;
    }

    public void n4() {
        this.y = 0;
        this.y += 1;
        this.y = this.y - 1;
    }

    public void setY(int y) {
        this.y = y;
    }

    public void test() {
        if (y == 0) {
            lock.lock();
        }
        y = 0;
        lock.unlock();
    }

    public void n() {
        this.lock.lock();
        this.y = 0;
        this.y += 1;
        this.y = this.y - 1;
        this.lock.unlock();
    }

    public void callTestLock2() {
        lock2.lock();
        setY(1);
        lock2.unlock();
    }

    public void n2() {
        lock.lock();
        this.y = 0;
        this.y += 1;
        this.y = this.y - 1;
        lock.unlock();
    }

    public void n3() {
        lock.lock();
        y = 0;
        y += 1;
        y = y - 1;
        lock.unlock(); 
    }

    public void callTest() {
        lock.lock();
        setY(1);
        lock.unlock();
    }
}