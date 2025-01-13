package examples;

import java.util.Stack;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class SyncStackExample<T> {
  private Lock lock = new ReentrantLock();
  private Stack<T> stc = new Stack<T>();

  public void push(T item) {
    lock.lock();
    stc.push(item);
    lock.unlock();
  }

  public void pop() {
    lock.lock();
    stc.pop();
    lock.unlock();
  }
}

@ThreadSafe
class FaultySyncStackExample<T> {
  private Lock lock = new ReentrantLock();
  private Stack<T> stc = new Stack<T>();

  public void push(T item) {
    lock.lock();
    stc.push(item); // $ Alert
    lock.unlock();
  }

  public void pop() {
    stc.pop();
  }
}
