package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
class FaultyTurnstileExample {
  private Lock lock = new ReentrantLock();
  private int count = 0;

  public void inc() {
    lock.lock();
    count++; // $ MISSING: Alert
    lock.unlock();
  }

  public void dec() {
    count--; // $ Alert
  }
}

@ThreadSafe
class FaultyTurnstileExample2 {
  private Lock lock1 = new ReentrantLock();
  private Lock lock2 = new ReentrantLock();
  private int count = 0; // $ Alert

  public void inc() {
    lock1.lock();
    count++;
    lock1.unlock();
  }

  public void dec() {
    lock2.lock();
    count--;
    lock2.unlock();
  }
}

