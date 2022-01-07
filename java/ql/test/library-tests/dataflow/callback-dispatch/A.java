package my.callback.qltest;

import java.util.*;

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

  static <T> T applyConsumer3_ret_postup(Consumer3<T> con) {
    // summary:
    // x = new T();
    // con.eat(x);
    // return x;
    return null;
  }

  static <T> void forEach(T[] xs, Consumer3<T> con) {
    // summary:
    // x = xs[..];
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

  static <T> T produceConsume(Producer1<T> prod, Consumer3<T> con) {
    // summary:
    // x = prod.make();
    // con.eat(x);
    // return x;
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

  public interface Producer1Consumer3<E> extends Producer1<E[]>, Consumer3<E[]> { }

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
        sink(o); // $ flow=4
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

    Producer1Consumer3<Integer> pc = new Producer1Consumer3<Integer>() {
      @Override public Integer[] make() {
        return new Integer[] { (Integer)source(11) };
      }
      @Override public void eat(Integer[] xs) {
        sink(xs[0]); // $ flow=12
      }
    };
    applyConsumer3(new Integer[] { (Integer)source(12) }, pc);
    sink(applyProducer1(pc)[0]); // $ flow=11

    Integer res = applyProducer1(new Producer1<Integer>() {
      private Integer ii = (Integer)source(13);
      @Override public Integer make() {
        return this.ii;
      }
    });
    sink(res); // $ flow=13

    ArrayList<Object> list = new ArrayList<>();
    applyConsumer3(list, l -> l.add(source(14)));
    sink(list.get(0)); // $ flow=14

    Consumer3<ArrayList<Object>> tainter = l -> l.add(source(15));
    sink(applyConsumer3_ret_postup(tainter).get(0)); // $ flow=15

    forEach(new Object[] {source(16)}, x -> sink(x)); // $ flow=16

    forEach(new Object[2][], xs -> { sink(xs[0]); xs[0] = source(17); });

    Object[][] xss = new Object[][] { { null } };
    forEach(xss, x -> {x[0] = source(18);});
    sink(xss[0][0]); // $ flow=18

    Object res2 = produceConsume(() -> source(19), A::sink); // $ flow=19
    sink(res2); // $ flow=19
  }

  static void applyConsumer1Field1Field2(A a1, A a2, Consumer1 con) {
    // summary:
    // con.eat(a1.field1);
    // con.eat(a2.field2);
  }

  static void wrapSinkToAvoidFieldSsa(A a) { sink(a.field1); } // $ flow=20

  void foo3() {
    A a1 = new A();
    a1.field1 = source(20);
    A a2 = new A();
    applyConsumer1Field1Field2(a1, a2, p -> {
      sink(p); // $ flow=20
    });
    wrapSinkToAvoidFieldSsa(a1);
    sink(a2.field2);
  }

  public Object field1;
  public Object field2;
}
