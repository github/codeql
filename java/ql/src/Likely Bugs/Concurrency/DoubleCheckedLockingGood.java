private Object lock = new Object();
private volatile MyObject f = null;

public MyObject getMyObject() {
  MyObject result = f;
  if (result == null) {
    synchronized(lock) {
      result = f;
      if (result == null) {
        result = new MyObject();
        result.init();
        f = result; // GOOD
      }
    }
  }
  return result;
}
