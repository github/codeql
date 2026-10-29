package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class TurnstileExample {
  private Lock lock = new ReentrantLock();
  private int count = 0;

  public void inc() {
    Lock l = lock;
    l.lock();
    count++;
    l.unlock();
  }

  public void dec() {
    lock.lock();
    count--;
    lock.unlock();
  }
}