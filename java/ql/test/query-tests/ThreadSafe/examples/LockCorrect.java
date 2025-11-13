package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class LockCorrect {
  private Lock lock1 = new ReentrantLock();

  private int length = 0;
  private int notRelatedToOther = 10;
  private int[] content  = new int[10];
  private int thisSynchronized = 0;

  public void add(int value) {
    lock1.lock();
    length++;
    content[length] = value;
    lock1.unlock();
  }

  public void removeCorrect() {
    lock1.lock();
    content[length] = 0;
    length--;
    lock1.unlock();
  }

  public void synchronizedOnLock1() {
    synchronized(lock1) {
      notRelatedToOther++;
    }
  }

  public void synchronizedOnLock12() {
    synchronized(lock1) {
      notRelatedToOther++;
    }
  }

  public synchronized void x() {
    thisSynchronized++;
  }

  public void x1() {
    synchronized(this) {
      thisSynchronized++;
    }
  }

}
