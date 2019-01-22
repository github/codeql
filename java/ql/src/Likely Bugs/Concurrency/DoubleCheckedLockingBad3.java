private Object lock = new Object();
private MyImmutableObject f = null;

public MyImmutableObject getMyImmutableObject() {
  if (f == null) {
    synchronized(lock) {
      if (f == null) {
        f = new MyImmutableObject();
      }
    }
  }
  return f; // BAD
}
