// This example shows that we only get one alert "per concurrency problem":
// For each problematic variable, we get one alert at the earliest conflicting write.
// If the variable is involved in several different monitors, we get an alert for each monitor that
// is not correctly used.
// A single alert can have many related locations, since each conflicting access which is not
// properly synchronized is a related location.
// This leads to many lines in the .expected file.
package examples;

import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

@ThreadSafe
public class LockExample {
  private Lock lock1 = new ReentrantLock();
  private Lock lock2 = new ReentrantLock();

  private int length = 0; // $ Alert
  private int notRelatedToOther = 10; // $ Alert
  private int[] content  = new int[10]; // $ Alert

  public void add(int value) {
    lock1.lock();
    length++;
    content[length] = value;
    lock1.unlock();
  }

  public void removeCorrect() {
    lock1.lock();
    length--;
    content[length] = 0;
    lock1.unlock();
  }

  public void notTheSameLockAsAdd() { // use locks, but different ones
    lock2.lock();
    length--;
    content[length] = 0;
    lock2.unlock();
  }

  public void noLock() { // no locks
    length--; // $ Alert
    content[length] = 0; // $ Alert
  }

  public void fieldUpdatedOutsideOfLock() { // adjusts length without lock
    length--; // $ Alert

    lock1.lock();
    content[length] = 0;
    lock1.unlock();
  }

  public synchronized void synchronizedLock() { // no locks, but with synchronized
    length--;
    content[length] = 0;
  }

  public void onlyLocked() { // never unlocked, only locked
    length--; // $ Alert

    lock1.lock();
    content[length] = 0; // $ Alert
  }

  public void onlyUnlocked() { // never locked, only unlocked
    length--; // $ Alert

    content[length] = 0; // $ Alert
    lock1.unlock();
  }

  public void notSameLock() {
    length--; // $ Alert

    lock2.lock();// Not the same lock
    content[length] = 0; // $ Alert
    lock1.unlock();
  }

  public void updateCount() {
    lock2.lock();
    notRelatedToOther++;
    lock2.unlock();
  }

  public void updateCountTwiceCorrect() {
    lock2.lock();
    notRelatedToOther++;
    lock2.unlock();
    lock1.lock();
    notRelatedToOther++;
    lock1.unlock();
  }

  public void updateCountTwiceDifferentLocks() {
    lock2.lock();
    notRelatedToOther++;
    lock2.unlock();
    lock1.lock();
    notRelatedToOther++;
    lock2.unlock();
  }

  public void updateCountTwiceLock() {
    lock2.lock();
    notRelatedToOther++;
    lock2.unlock();
    lock1.lock();
    notRelatedToOther++; // $ Alert
  }

  public void updateCountTwiceUnLock() {
    lock2.lock();
    notRelatedToOther++;
    lock2.unlock();
    notRelatedToOther++; // $ Alert
    lock1.unlock();
  }

  public void synchronizedNonRelatedOutside() {
    notRelatedToOther++; // $ Alert

    synchronized(this) {
      length++;
    }
  }

  public void synchronizedNonRelatedOutside2() {
    int x = 0;
    x++;

    synchronized(this) {
      length++;
    }
  }

  public void synchronizedNonRelatedOutside3() {
    synchronized(this) {
      length++;
    }

    notRelatedToOther = 1; // $ Alert
  }

  public void synchronizedNonRelatedOutside4() {
    synchronized(lock1) {
      length++;
    }

    notRelatedToOther = 1; // $ Alert
  }

}
