package com.semmle.camel.javadsl;

/**
 * All public methods in this class are considered to be live because this class is registered in a
 * {@code to("bean:dslToTarget")} call in a RouteBuilder.
 */
public class DSLToTarget {
  public Foo applyFoo(Foo foo1) {
    return new Foo();
  }

  public static class Foo {}
}
