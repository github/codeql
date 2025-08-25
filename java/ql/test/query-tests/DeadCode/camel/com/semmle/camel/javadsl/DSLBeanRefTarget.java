package com.semmle.camel.javadsl;

/**
 * All public methods in this class are considered to be live because this class is registered in a
 * {@code beanRef("dslBeanRefTarget")} call in a RouteBuilder.
 */
public class DSLBeanRefTarget {
  public Foo applyFoo(Foo foo1) {
    return new Foo();
  }

  public static class Foo {}
}
