private Object lock = new Object();
private volatile MyObject f = null;

public MyObject getMyObject() {
  if (f == null) {
    synchronized(lock) {
      if (f == null) {
        f = new MyObject();
        f.init(); // BAD
      }
    }
  }
  return f;
}
