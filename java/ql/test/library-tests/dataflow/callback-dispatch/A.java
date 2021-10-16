package my.callback.qltest;

public class A {
  public interface Consumer1 {
    void eat(Object o);
  }

  public interface Consumer2 {
    void eat(Object o);
  }

  public interface Consumer3<T> {
    void eat(T o);
  }

  static void applyConsumer1(Object x, Consumer1 con) {
    // summary:
    // con.eat(x);
  }

  static void applyConsumer2(Object x, Consumer2 con) {
    // summary:
    // con.eat(x);
  }

  static <T> void applyConsumer3(T x, Consumer3<T> con) {
    // summary:
    // con.eat(x);
  }

  public interface Producer1<T> {
    T make();
  }

  static <T> T applyProducer1(Producer1<T> prod) {
    // summary:
    // return prod.make();
    return null;
  }

  public interface Converter1<T1,T2> {
    T2 conv(T1 x);
  }

  static <T1,T2> T2 applyConverter1(T1 x, Converter1<T1,T2> con) {
    // summary:
    // return con.conv(x);
    return null;
  }

  static Object source(int i) { return null; }

  static void sink(Object o) { }

  void foo(boolean b1, boolean b2) {
    applyConsumer1(source(1), p -> {
      sink(p); // $ flow=1
    });

    Object handler;
    if (b1) {
      handler = (Consumer1)(p -> { sink(p); }); // $ flow=2
    } else {
      handler = (Consumer2)(p -> { sink(p); }); // $ flow=3
    }
    if (b2) {
      applyConsumer1(source(2), (Consumer1)handler);
    } else {
      applyConsumer2(source(3), (Consumer2)handler);
    }

    applyConsumer1(source(4), new Consumer1() {
      @Override public void eat(Object o) {
        sink(o); // $ MISSING: flow=4
      }
    });

    applyConsumer1(source(5), A::sink); // $ flow=5

    Consumer2 c = new MyConsumer2();
    applyConsumer2(source(6), c);
  }

  static class MyConsumer2 implements Consumer2 {
    @Override public void eat(Object o) {
      sink(o); // $ MISSING: flow=6
    }
  }

  void foo2() {
    Consumer3<Integer> c = i -> sink(i); // $ flow=7
    applyConsumer3((Integer)source(7), c);

    sink(applyProducer1(() -> (Integer)source(8))); // $ flow=8

    sink(applyConverter1((Integer)source(9), i -> i)); // $ flow=9

    sink(applyConverter1((Integer)source(10), i -> new int[]{i})[0]); // $ flow=10
  }
}
