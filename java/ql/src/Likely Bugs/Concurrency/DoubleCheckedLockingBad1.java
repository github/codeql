private Object lock = new Object();
private MyObject f = null;

public MyObject getMyObject() {
  if (f == null) {
    synchronized(lock) {
      if (f == null) {
        f = new MyObject(); // BAD
      }
    }
  }
  return f;
}
