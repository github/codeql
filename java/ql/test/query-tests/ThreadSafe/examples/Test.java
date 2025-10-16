package examples;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class Test {
  /**
   * Escaping field due to public visibility.
   */
  int publicField;
  
  private int y;
  final int immutableField = 1;

  // As of the below examples with synchronized as well. Except the incorrectly placed lock.

  private Lock lock = new ReentrantLock();

  /**
   * Calls the a method where y field escapes.
   * @param y
   */
  public void setYAgainInCorrect(int t) {
    setYPrivate(t);
  }

  /**
   * Locks the method where y field escapes.
   * @param y
   */
  public void setYAgainCorrect(int y) {
    lock.lock();
    setYPrivate(y);
    lock.unlock();
  }

  /**
   * No escaping y field. Locks the y before assignment.
   * @param y
   */
  public void setYCorrect(int y) {
    lock.lock();
    this.y = y;
    lock.unlock();
  }

  /**
   * No direct escaping, since it method is private. Only escaping if another public method uses this.
   * @param y
   */
  private void setYPrivate(int y) {
    this.y = y; // $ Alert
  }

  /**
   * Incorrectly locks y.
   * @param y
   */
  public void setYWrongLock(int y) {
    this.y = y; // $ Alert
    lock.lock();
    lock.unlock();
  }

  public synchronized int getImmutableField() {
    return immutableField;
  }

  public synchronized int getImmutableField2() {
    return immutableField;
  }

  public void testMethod() {
    this.y = y + 2; // $ Alert
  }
}
