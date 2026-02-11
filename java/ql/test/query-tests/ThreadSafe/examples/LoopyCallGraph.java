package examples;

import java.util.Random;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class LoopyCallGraph {
  private Lock lock = new ReentrantLock();
  private int count = 0;
  private Random random = new Random();

  public void entry() {
    if (random.nextBoolean()) {
      increase();  // this could look like an unprotected path to a call to dec()
    } else {
      lock.lock();
      dec();
      lock.unlock();
    }
  }

  private void increase() {
    lock.lock();
    count = 10;
    lock.unlock();
    entry();  // this could look like an unprotected path to a call to dec()
  }

  private void dec() {
    count--;
  }
}